import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/use_cases/use_case.dart';
import '../../../domain/entities/alert.dart';
import '../../../domain/entities/alert_page.dart';
import '../../../domain/entities/alert_page_request.dart';
import '../../../domain/usecases/get_alerts_use_case.dart';
import '../../../domain/usecases/watch_alerts_live_status_use_case.dart';
import '../../../domain/usecases/watch_alerts_use_case.dart';

part 'alerts_event.dart';
part 'alerts_state.dart';

class AlertsBloc extends Bloc<AlertsEvent, AlertsState> {
  AlertsBloc({
    required GetAlertsUseCase getAlerts,
    required WatchAlertsUseCase watchAlerts,
    required WatchAlertsLiveStatusUseCase watchLiveStatus,
  }) : _getAlerts = getAlerts,
       _watchAlerts = watchAlerts,
       _watchLiveStatus = watchLiveStatus,
       super(const AlertsLoading()) {
    on<AlertsStarted>(_onStarted);
    on<AlertsRefreshRequested>(_onRefreshRequested, transformer: restartable());
    on<AlertsNextPageRequested>(_onNextPageRequested, transformer: droppable());
    on<AlertsAlertReceived>(_onAlertReceived);
  }

  static const pageSize = 20;

  final GetAlertsUseCase _getAlerts;
  final WatchAlertsUseCase _watchAlerts;
  final WatchAlertsLiveStatusUseCase _watchLiveStatus;

  Future<void> _onStarted(AlertsStarted event, Emitter<AlertsState> emit) {
    add(const AlertsRefreshRequested());
    return Future.wait([
      emit.onEach(
        _watchAlerts(const NoParams()),
        onData: (alert) => add(AlertsAlertReceived(alert)),
      ),
      emit.onEach(
        _watchLiveStatus(const NoParams()),
        onData: (isLive) => emit(state.withLive(isLive)),
      ),
    ]);
  }

  Future<void> _onRefreshRequested(
    AlertsRefreshRequested event,
    Emitter<AlertsState> emit,
  ) async {
    emit(AlertsLoading(isLive: state.isLive));
    final result = await _getAlerts(_request(1));
    emit(
      result.fold(
        (failure) => AlertsError(failure.message, isLive: state.isLive),
        (page) => AlertsLoaded(page, isLive: state.isLive),
      ),
    );
  }

  Future<void> _onNextPageRequested(
    AlertsNextPageRequested event,
    Emitter<AlertsState> emit,
  ) async {
    final current = state;
    if (current is! AlertsLoaded || !current.page.hasNextPage) return;
    emit(
      AlertsLoaded(
        current.page,
        isLive: current.isLive,
        isLoadingMore: true,
      ),
    );
    final result = await _getAlerts(_request(current.page.page + 1));
    final latest = state;
    if (latest is! AlertsLoaded || !latest.isLoadingMore) return;
    emit(
      result.fold(
        (failure) => AlertsLoaded(
          latest.page,
          isLive: latest.isLive,
          nextPageError: failure.message,
        ),
        (next) => AlertsLoaded(
          latest.page.append(next),
          isLive: latest.isLive,
        ),
      ),
    );
  }

  void _onAlertReceived(AlertsAlertReceived event, Emitter<AlertsState> emit) {
    final alert = event.alert;
    final current = state;
    if (current is! AlertsLoaded) return;

    final shown = current.page.find(alert.id);
    if (shown != null) {
      if (shown.isAcknowledged && !alert.isAcknowledged) return;
      emit(current.withPage(current.page.replace(alert)));
      return;
    }
    if (alert.isAcknowledged) return;
    emit(current.withPage(current.page.addOnTop(alert)));
  }

  static AlertPageRequest _request(int page) =>
      AlertPageRequest(page: page, pageSize: pageSize);
}

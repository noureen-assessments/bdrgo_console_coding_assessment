import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/use_cases/use_case.dart';
import '../../../domain/entities/kpi_range.dart';
import '../../../domain/entities/kpis.dart';
import '../../../domain/usecases/get_kpis_use_case.dart';
import '../../../domain/usecases/watch_kpis_use_case.dart';
import '../../../domain/usecases/watch_live_status_use_case.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';


class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    required GetKpisUseCase getKpis,
    required WatchKpisUseCase watchKpis,
    required WatchLiveStatusUseCase watchLiveStatus,
  }) : _getKpis = getKpis,
       _watchKpis = watchKpis,
       _watchLiveStatus = watchLiveStatus,
       super(const DashboardLoading()) {
    on<DashboardStarted>(_onStarted);
    on<DashboardRefreshRequested>(
      _onRefreshRequested,
      transformer: droppable(),
    );
  }

  final GetKpisUseCase _getKpis;
  final WatchKpisUseCase _watchKpis;
  final WatchLiveStatusUseCase _watchLiveStatus;


  Future<void> _onStarted(
    DashboardStarted event,
    Emitter<DashboardState> emit,
  ) {
    add(const DashboardRefreshRequested());
    return Future.wait([
      emit.onEach(
        _watchKpis(const NoParams()),
        onData: (kpis) => _show(kpis, emit, isLive: true),
      ),
      emit.onEach(
        _watchLiveStatus(const NoParams()),
        onData: (isLive) {
          final current = state;
          if (current is DashboardLoaded) {
            emit(DashboardLoaded(current.kpis, isLive: isLive));
          }
        },
      ),
    ]);
  }

  Future<void> _onRefreshRequested(
    DashboardRefreshRequested event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is! DashboardLoaded) emit(const DashboardLoading());
    final result = await _getKpis(KpiRange.last24Hours);
    result.fold((failure) {
      if (state is! DashboardLoaded) emit(DashboardError(failure.message));
    }, (kpis) => _show(kpis, emit));
  }


  void _show(Kpis kpis, Emitter<DashboardState> emit, {bool? isLive}) {
    final current = state;
    if (current is DashboardLoaded) {
      if (kpis.isOlderThan(current.kpis)) return;
      emit(DashboardLoaded(kpis, isLive: isLive ?? current.isLive));
      return;
    }
    emit(DashboardLoaded(kpis, isLive: isLive ?? false));
  }
}

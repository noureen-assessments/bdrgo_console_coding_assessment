import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/use_cases/use_case.dart';
import '../../../domain/entities/alert.dart';
import '../../../domain/usecases/watch_critical_alerts_use_case.dart';

part 'critical_alerts_event.dart';
part 'critical_alerts_state.dart';

class CriticalAlertsBloc extends Bloc<CriticalAlertsEvent, CriticalAlertsState> {
  CriticalAlertsBloc({required WatchCriticalAlertsUseCase watchCriticalAlerts}): _watchCriticalAlerts = watchCriticalAlerts, super(const CriticalAlertsState()) {
    on<CriticalAlertsStarted>(_onStarted);
    on<CriticalAlertsReceived>(_onReceived);
    on<CriticalAlertsDismissed>(_onDismissed);
  }

  final WatchCriticalAlertsUseCase _watchCriticalAlerts;

  Future<void> _onStarted(
    CriticalAlertsStarted event,
    Emitter<CriticalAlertsState> emit,
  ) {
    return emit.onEach(
      _watchCriticalAlerts(const NoParams()),
      onData: (alert) => add(CriticalAlertsReceived(alert)),
    );
  }

  void _onReceived(
    CriticalAlertsReceived event,
    Emitter<CriticalAlertsState> emit,
  ) {
    final alert = event.alert;
    final others = <Alert>[];
    var isShown = false;
    for (final shown in state.alerts) {
      if (shown.id == alert.id) {
        isShown = true;
      } else {
        others.add(shown);
      }
    }
    if (alert.isAcknowledged) {
      if (isShown) emit(CriticalAlertsState(alerts: others));
      return;
    }
    if (isShown) return;
    emit(CriticalAlertsState(alerts: [alert, ...state.alerts]));
  }

  void _onDismissed(
    CriticalAlertsDismissed event,
    Emitter<CriticalAlertsState> emit,
  ) {
    emit(const CriticalAlertsState());
  }
}

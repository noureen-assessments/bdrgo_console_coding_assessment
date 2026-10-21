part of 'critical_alerts_bloc.dart';

sealed class CriticalAlertsEvent {
  const CriticalAlertsEvent();
}

final class CriticalAlertsStarted extends CriticalAlertsEvent {
  const CriticalAlertsStarted();
}

final class CriticalAlertsReceived extends CriticalAlertsEvent {
  const CriticalAlertsReceived(this.alert);

  final Alert alert;
}

final class CriticalAlertsDismissed extends CriticalAlertsEvent {
  const CriticalAlertsDismissed();
}

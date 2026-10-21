part of 'alerts_bloc.dart';

sealed class AlertsEvent {
  const AlertsEvent();
}

final class AlertsStarted extends AlertsEvent {
  const AlertsStarted();
}

final class AlertsFilterChanged extends AlertsEvent {
  const AlertsFilterChanged({required this.openOnly});

  final bool openOnly;
}

final class AlertsNextPageRequested extends AlertsEvent {
  const AlertsNextPageRequested();
}

final class AlertsAlertReceived extends AlertsEvent {
  const AlertsAlertReceived(this.alert);

  final Alert alert;
}

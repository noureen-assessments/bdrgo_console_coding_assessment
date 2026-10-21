part of 'critical_alerts_bloc.dart';

final class CriticalAlertsState extends Equatable {
  const CriticalAlertsState({this.alerts = const []});

  final List<Alert> alerts;

  bool get hasAlerts => alerts.isNotEmpty;

  @override
  List<Object?> get props => [alerts];
}

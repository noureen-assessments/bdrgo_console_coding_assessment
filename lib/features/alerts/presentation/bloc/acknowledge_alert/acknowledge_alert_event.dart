part of 'acknowledge_alert_bloc.dart';

sealed class AcknowledgeAlertEvent {
  const AcknowledgeAlertEvent();
}

final class AcknowledgeAlertSubmitted extends AcknowledgeAlertEvent {
  const AcknowledgeAlertSubmitted(this.alertId);

  final String alertId;
}

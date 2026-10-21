part of 'acknowledge_alert_bloc.dart';

sealed class AcknowledgeAlertState extends Equatable {
  const AcknowledgeAlertState();

  @override
  List<Object?> get props => [];
}

final class AcknowledgeAlertIdle extends AcknowledgeAlertState {
  const AcknowledgeAlertIdle();
}

final class AcknowledgeAlertSending extends AcknowledgeAlertState {
  const AcknowledgeAlertSending();
}

final class AcknowledgeAlertDone extends AcknowledgeAlertState {
  const AcknowledgeAlertDone(this.alert);

  final Alert alert;

  @override
  List<Object?> get props => [alert];
}

final class AcknowledgeAlertFailed extends AcknowledgeAlertState {
  const AcknowledgeAlertFailed(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/alert.dart';
import '../../../domain/usecases/acknowledge_alert_use_case.dart';

part 'acknowledge_alert_event.dart';
part 'acknowledge_alert_state.dart';

class AcknowledgeAlertBloc
    extends Bloc<AcknowledgeAlertEvent, AcknowledgeAlertState> {
  AcknowledgeAlertBloc({required AcknowledgeAlertUseCase acknowledgeAlert})
    : _acknowledgeAlert = acknowledgeAlert,
      super(const AcknowledgeAlertIdle()) {
    on<AcknowledgeAlertSubmitted>(_onSubmitted, transformer: droppable());
  }

  final AcknowledgeAlertUseCase _acknowledgeAlert;

  Future<void> _onSubmitted(
    AcknowledgeAlertSubmitted event,
    Emitter<AcknowledgeAlertState> emit,
  ) async {
    emit(const AcknowledgeAlertSending());
    final result = await _acknowledgeAlert(event.alertId);
    emit(
      result.fold(
        (failure) => AcknowledgeAlertFailed(failure),
        (alert) => AcknowledgeAlertDone(alert),
      ),
    );
  }
}

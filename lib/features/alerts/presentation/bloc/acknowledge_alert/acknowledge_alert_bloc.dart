import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/alert.dart';

part 'acknowledge_alert_event.dart';
part 'acknowledge_alert_state.dart';

class AcknowledgeAlertBloc
    extends Bloc<AcknowledgeAlertEvent, AcknowledgeAlertState> {
  AcknowledgeAlertBloc() : super(const AcknowledgeAlertIdle());
}

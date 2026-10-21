import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/alert.dart';

part 'critical_alerts_event.dart';
part 'critical_alerts_state.dart';

class CriticalAlertsBloc extends Bloc<CriticalAlertsEvent, CriticalAlertsState> {
  CriticalAlertsBloc() : super(const CriticalAlertsState());
}

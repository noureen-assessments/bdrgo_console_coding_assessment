import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/use_cases/use_case.dart';
import '../../domain/entities/maintenance_info.dart';
import '../../domain/usecases/poll_until_up_use_case.dart';
import '../../domain/usecases/watch_maintenance_use_case.dart';

part 'maintenance_event.dart';
part 'maintenance_state.dart';

class MaintenanceBloc extends Bloc<MaintenanceEvent, MaintenanceState> {
  MaintenanceBloc({
    required WatchMaintenanceUseCase watchMaintenance,
    required PollUntilUpUseCase pollUntilUp,
  }) : _watchMaintenance = watchMaintenance,
       _pollUntilUp = pollUntilUp,
       super(const MaintenanceOff()) {
    on<MaintenanceStarted>(_onStarted);
    on<MaintenanceDetected>(_onDetected, transformer: droppable());
  }

  final WatchMaintenanceUseCase _watchMaintenance;
  final PollUntilUpUseCase _pollUntilUp;

  Future<void> _onStarted(
    MaintenanceStarted event,
    Emitter<MaintenanceState> emit,
  ) {
    return emit.onEach(
      _watchMaintenance(const NoParams()),
      onData: (info) => add(MaintenanceDetected(info)),
    );
  }

  Future<void> _onDetected(
    MaintenanceDetected event,
    Emitter<MaintenanceState> emit,
  ) async {
    emit(MaintenanceOn(event.info));
    await emit.forEach<MaintenanceInfo>(
      _pollUntilUp(event.info),
      onData: MaintenanceOn.new,
    );
    if (emit.isDone) return;
    emit(const MaintenanceOff());
  }
}

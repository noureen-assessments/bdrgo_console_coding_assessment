import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/available_driver.dart';
import '../../../domain/usecases/get_available_drivers_use_case.dart';

part 'available_drivers_event.dart';
part 'available_drivers_state.dart';

class AvailableDriversBloc
    extends Bloc<AvailableDriversEvent, AvailableDriversState> {
  AvailableDriversBloc({
    required GetAvailableDriversUseCase getAvailableDrivers,
  }) : _getAvailableDrivers = getAvailableDrivers,
       super(const AvailableDriversLoading()) {
    on<AvailableDriversRequested>(_onRequested, transformer: restartable());
  }

  final GetAvailableDriversUseCase _getAvailableDrivers;

  Future<void> _onRequested(
    AvailableDriversRequested event,
    Emitter<AvailableDriversState> emit,
  ) async {
    emit(const AvailableDriversLoading());
    final result = await _getAvailableDrivers(event.cityId);
    emit(
      result.fold(
        (failure) => AvailableDriversError(failure.message),
        (drivers) => AvailableDriversLoaded(drivers),
      ),
    );
  }
}

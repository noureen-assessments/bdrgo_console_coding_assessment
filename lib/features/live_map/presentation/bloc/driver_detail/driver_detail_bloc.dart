import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/driver_detail.dart';
import '../../../domain/usecases/get_driver_detail_use_case.dart';

part 'driver_detail_event.dart';
part 'driver_detail_state.dart';

class DriverDetailBloc extends Bloc<DriverDetailEvent, DriverDetailState> {
  DriverDetailBloc({required GetDriverDetailUseCase getDriverDetail})
    : _getDriverDetail = getDriverDetail,
      super(const DriverDetailClosed()) {
    on<DriverDetailRequested>(_onRequested, transformer: restartable());
    on<DriverDetailDismissed>(_onDismissed);
  }

  final GetDriverDetailUseCase _getDriverDetail;

  Future<void> _onRequested(
    DriverDetailRequested event,
    Emitter<DriverDetailState> emit,
  ) async {
    emit(const DriverDetailLoading());
    final result = await _getDriverDetail(event.driverId);
    if (state is DriverDetailClosed) return;
    result.fold(
      (failure) {
        if (failure is NotFoundFailure) {
          emit(const DriverDetailNotFound());
        } else {
          emit(DriverDetailError(event.driverId, failure.message));
        }
      },
      (driver) {
        if (driver == null) {
          emit(const DriverDetailNotFound());
        } else {
          emit(DriverDetailLoaded(driver));
        }
      },
    );
  }

  void _onDismissed(
    DriverDetailDismissed event,
    Emitter<DriverDetailState> emit,
  ) {
    emit(const DriverDetailClosed());
  }
}

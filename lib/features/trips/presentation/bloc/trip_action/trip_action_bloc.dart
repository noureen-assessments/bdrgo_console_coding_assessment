import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/trip_action.dart';
import '../../../domain/usecases/perform_trip_action_use_case.dart';

part 'trip_action_event.dart';
part 'trip_action_state.dart';

class TripActionBloc extends Bloc<TripActionEvent, TripActionState> {
  TripActionBloc({required PerformTripActionUseCase performTripAction})
    : _performTripAction = performTripAction,
      super(const TripActionIdle()) {
    on<TripActionSubmitted>(_onSubmitted, transformer: droppable());
  }

  final PerformTripActionUseCase _performTripAction;

  Future<void> _onSubmitted(
    TripActionSubmitted event,
    Emitter<TripActionState> emit,
  ) async {
    emit(const TripActionSending());
    final result = await _performTripAction(event.action);
    emit(
      result.fold(
        (failure) => TripActionFailed(failure),
        (_) => const TripActionDone(),
      ),
    );
  }
}

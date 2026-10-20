part of 'trip_action_bloc.dart';

sealed class TripActionState extends Equatable {
  const TripActionState();

  @override
  List<Object?> get props => [];
}

final class TripActionIdle extends TripActionState {
  const TripActionIdle();
}

final class TripActionSending extends TripActionState {
  const TripActionSending();
}

final class TripActionDone extends TripActionState {
  const TripActionDone();
}


final class TripActionFailed extends TripActionState {
  const TripActionFailed(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

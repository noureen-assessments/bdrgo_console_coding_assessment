part of 'trip_action_bloc.dart';

sealed class TripActionEvent {
  const TripActionEvent();
}

final class TripActionSubmitted extends TripActionEvent {
  const TripActionSubmitted(this.action);

  final TripAction action;
}

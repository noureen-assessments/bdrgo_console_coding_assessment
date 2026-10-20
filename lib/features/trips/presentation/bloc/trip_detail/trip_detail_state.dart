part of 'trip_detail_bloc.dart';

sealed class TripDetailState extends Equatable {
  const TripDetailState();

  @override
  List<Object?> get props => [];
}

final class TripDetailLoading extends TripDetailState {
  const TripDetailLoading();
}

final class TripDetailLoaded extends TripDetailState {
  const TripDetailLoaded(this.trip);

  final TripDetail trip;

  @override
  List<Object?> get props => [trip];
}

final class TripDetailNotFound extends TripDetailState {
  const TripDetailNotFound();
}

final class TripDetailError extends TripDetailState {
  const TripDetailError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

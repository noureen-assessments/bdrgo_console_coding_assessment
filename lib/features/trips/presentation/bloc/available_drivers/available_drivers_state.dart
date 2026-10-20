part of 'available_drivers_bloc.dart';

sealed class AvailableDriversState extends Equatable {
  const AvailableDriversState();

  @override
  List<Object?> get props => [];
}

final class AvailableDriversLoading extends AvailableDriversState {
  const AvailableDriversLoading();
}

final class AvailableDriversError extends AvailableDriversState {
  const AvailableDriversError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class AvailableDriversLoaded extends AvailableDriversState {
  const AvailableDriversLoaded(this.drivers);

  final List<AvailableDriver> drivers;

  @override
  List<Object?> get props => [drivers];
}

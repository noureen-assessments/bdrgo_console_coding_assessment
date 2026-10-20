part of 'driver_detail_bloc.dart';

sealed class DriverDetailState extends Equatable {
  const DriverDetailState();

  @override
  List<Object?> get props => [];
}

final class DriverDetailClosed extends DriverDetailState {
  const DriverDetailClosed();
}

final class DriverDetailLoading extends DriverDetailState {
  const DriverDetailLoading();
}

final class DriverDetailLoaded extends DriverDetailState {
  const DriverDetailLoaded(this.driver);

  final DriverDetail driver;

  @override
  List<Object?> get props => [driver];
}

final class DriverDetailNotFound extends DriverDetailState {
  const DriverDetailNotFound();
}

final class DriverDetailError extends DriverDetailState {
  const DriverDetailError(this.driverId, this.message);

  final String driverId;
  final String message;

  @override
  List<Object?> get props => [driverId, message];
}

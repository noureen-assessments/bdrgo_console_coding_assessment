part of 'driver_detail_bloc.dart';

sealed class DriverDetailEvent {
  const DriverDetailEvent();
}

final class DriverDetailRequested extends DriverDetailEvent {
  const DriverDetailRequested(this.driverId);

  final String driverId;
}

final class DriverDetailDismissed extends DriverDetailEvent {
  const DriverDetailDismissed();
}

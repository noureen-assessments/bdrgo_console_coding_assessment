part of 'available_drivers_bloc.dart';

sealed class AvailableDriversEvent {
  const AvailableDriversEvent();
}

final class AvailableDriversRequested extends AvailableDriversEvent {
  const AvailableDriversRequested(this.cityId);

  final String cityId;
}

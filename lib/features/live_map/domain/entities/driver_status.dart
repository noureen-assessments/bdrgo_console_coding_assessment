import '../../../../core/constants/app_strings.dart';

enum DriverStatus {
  available('AVAILABLE', AppStrings.driverAvailable),
  onTrip('ON_TRIP', AppStrings.driverOnTrip),
  offline('OFFLINE', AppStrings.driverOffline);

  const DriverStatus(this.value, this.label);

  final String value;
  final String label;

  static DriverStatus fromValue(String value) {
    final upper = value.toUpperCase();
    for (final status in values) {
      if (status.value == upper) return status;
    }
    throw FormatException('driver status', value);
  }
}

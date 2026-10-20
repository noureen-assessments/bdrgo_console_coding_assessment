import '../../../../core/constants/app_strings.dart';


enum TripStatus {
  requested('REQUESTED', AppStrings.tripRequested),
  assigned('ASSIGNED', AppStrings.tripAssigned),
  inProgress('IN_PROGRESS', AppStrings.tripInProgress),
  completed('COMPLETED', AppStrings.tripCompleted),
  cancelled('CANCELLED', AppStrings.tripCancelled);

  const TripStatus(this.value, this.label);

  final String value;
  final String label;

  static TripStatus fromValue(String value) {
    final upper = value.toUpperCase();
    for (final status in values) {
      if (status.value == upper) return status;
    }
    throw FormatException('trip status', value);
  }
}

import '../../../../core/constants/app_strings.dart';

enum MaintenanceReason {
  planned('planned', AppStrings.maintenancePlanned),
  unavailable('unavailable', AppStrings.maintenanceUnavailable);

  const MaintenanceReason(this.value, this.label);

  final String value;
  final String label;

  static MaintenanceReason fromValue(String? value) {
    if (value == null) return unavailable;
    final lower = value.toLowerCase();
    for (final reason in values) {
      if (reason.value == lower) return reason;
    }
    return unavailable;
  }
}

import '../../../../core/constants/app_strings.dart';

enum AlertType {
  sos('sos', AppStrings.alertSos),
  noDriverAvailable('no_driver_available', AppStrings.alertNoDriverAvailable),
  highDemand('high_demand', AppStrings.alertHighDemand),
  refundIssued('refund_issued', AppStrings.alertRefundIssued);

  const AlertType(this.value, this.label);

  final String value;
  final String label;

  static AlertType fromValue(String value) {
    final lower = value.toLowerCase();
    for (final type in values) {
      if (type.value == lower) return type;
    }
    throw FormatException('alert type', value);
  }
}

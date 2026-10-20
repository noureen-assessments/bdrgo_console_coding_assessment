import '../../../../core/constants/app_strings.dart';


abstract final class TripActionValidators {
  static const _reasonMinLength = 3;
  static const reasonMaxLength = 200;

  static String? reason(String? value) {
    final length = (value ?? '').trim().length;
    if (length < _reasonMinLength || length > reasonMaxLength) {
      return AppStrings.reasonLength;
    }
    return null;
  }
}

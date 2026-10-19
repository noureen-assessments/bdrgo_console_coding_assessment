import '../../../../core/constants/app_strings.dart';

/// Client-side checks so obviously incomplete forms never reach the server.
/// Credential errors come from the server and are shown as-is.
abstract final class SignInValidators {
  static final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return AppStrings.emailRequired;
    if (!_email.hasMatch(email)) return AppStrings.emailInvalid;
    return null;
  }

  static String? password(String? value) =>
      (value == null || value.isEmpty) ? AppStrings.passwordRequired : null;
}

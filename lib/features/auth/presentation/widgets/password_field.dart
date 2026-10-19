import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../validators/sign_in_validators.dart';

/// Password input with a show/hide toggle. The toggle is view-only state.
class PasswordField extends StatefulWidget {
  const PasswordField({
    required this.controller,
    required this.onSubmitted,
    this.enabled = true,
    super.key,
  });

  final TextEditingController controller;
  final VoidCallback onSubmitted;
  final bool enabled;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      enabled: widget.enabled,
      obscureText: _obscured,
      autofillHints: const [AutofillHints.password],
      textInputAction: TextInputAction.done,
      validator: SignInValidators.password,
      onFieldSubmitted: (_) => widget.onSubmitted(),
      decoration: InputDecoration(
        labelText: AppStrings.password,
        prefixIcon: const Icon(AppAssets.password),
        suffixIcon: IconButton(
          tooltip: _obscured
              ? AppStrings.showPassword
              : AppStrings.hidePassword,
          icon: Icon(
            _obscured ? AppAssets.showPassword : AppAssets.hidePassword,
          ),
          onPressed: () => setState(() => _obscured = !_obscured),
        ),
      ),
    );
  }
}

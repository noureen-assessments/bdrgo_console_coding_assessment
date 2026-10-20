import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/sign_in/sign_in_bloc.dart';
import '../validators/sign_in_validators.dart';
import 'password_field.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<SignInBloc>().add(
      SignInSubmitted(email: _email.text, password: _password.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final busy = context.select(
      (SignInBloc bloc) =>
          bloc.state is SignInInProgress || bloc.state is SignInSucceeded,
    );
    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _email,
              enabled: !busy,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              textInputAction: TextInputAction.next,
              validator: SignInValidators.email,
              decoration: const InputDecoration(
                labelText: AppStrings.email,
                prefixIcon: Icon(AppAssets.email),
              ),
            ),
            const SizedBox(height: AppDimensions.spaceMd),
            PasswordField(
              controller: _password,
              enabled: !busy,
              onSubmitted: _submit,
            ),
            const SizedBox(height: AppDimensions.spaceLg),
            FilledButton(
              onPressed: busy ? null : _submit,
              child: busy
                  ? const SizedBox.square(
                      dimension: AppDimensions.progressMd,
                      child: CircularProgressIndicator(
                        strokeWidth: AppDimensions.progressStroke,
                      ),
                    )
                  : const Text(AppStrings.signIn),
            ),
          ],
        ),
      ),
    );
  }
}

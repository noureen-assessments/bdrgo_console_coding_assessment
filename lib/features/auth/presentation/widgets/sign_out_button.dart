import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/app_snack_bar.dart';
import '../../../../core/utils/responsive.dart';
import '../bloc/auth/auth_bloc.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthAuthenticated &&
          current.signOutError != null &&
          previous != current,
      listener: (context, state) {
        AppSnackBar.showError(
          context,
          (state as AuthAuthenticated).signOutError!,
        );
      },
      builder: (context, state) {
        final busy = state is AuthAuthenticated && state.isSigningOut;
        final onPressed = busy
            ? null
            : () => context.read<AuthBloc>().add(const AuthSignOutRequested());
        final icon = busy
            ? const SizedBox.square(
                dimension: AppDimensions.progressSm,
                child: CircularProgressIndicator(
                  strokeWidth: AppDimensions.progressStroke,
                ),
              )
            : const Icon(AppAssets.signOut);

        if (context.isMobile) {
          return IconButton(
            tooltip: AppStrings.signOut,
            onPressed: onPressed,
            icon: icon,
          );
        }
        return TextButton.icon(
          onPressed: onPressed,
          icon: icon,
          label: const Text(AppStrings.signOut),
        );
      },
    );
  }
}

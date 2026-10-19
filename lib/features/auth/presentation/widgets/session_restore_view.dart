import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/no_data_found_widget.dart';
import '../bloc/auth/auth_bloc.dart';

/// Shown instead of the app while the stored session is checked, or when
/// that check failed. A failed check retries by itself once the browser is
/// back online.
class SessionRestoreView extends StatelessWidget {
  const SessionRestoreView({this.errorMessage, super.key});

  /// Null while still checking.
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final message = errorMessage;
    return Scaffold(
      body: message == null
          ? const NoDataFoundWidget(
              icon: AppAssets.restoringSession,
              title: AppStrings.restoringSession,
              action: CircularProgressIndicator(),
            )
          : NoDataFoundWidget(
              icon: AppAssets.restoreFailed,
              title: AppStrings.restoreFailed,
              message: message,
              action: FilledButton(
                onPressed: () =>
                    context.read<AuthBloc>().add(const AuthRestoreRequested()),
                child: const Text(AppStrings.retry),
              ),
            ),
    );
  }
}

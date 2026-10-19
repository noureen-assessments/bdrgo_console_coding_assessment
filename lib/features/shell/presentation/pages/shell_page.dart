import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/no_data_found_widget.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../auth/presentation/widgets/sign_out_button.dart';
import '../widgets/signed_in_user_label.dart';

/// Signed-in landing page. The permission-driven navigation (M2) and the
/// dashboard (M3) replace the placeholder body.
///
/// Narrow windows show the user under the title; wide ones beside the
/// sign-out button.
class ShellPage extends StatelessWidget {
  const ShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select(
      (AuthBloc bloc) => switch (bloc.state) {
        AuthAuthenticated(:final user) => user,
        _ => null,
      },
    );
    // Briefly null while signing out, before the page is replaced.
    if (user == null) return const Scaffold();

    final isMobile = context.isMobile;
    return Scaffold(
      appBar: AppBar(
        title: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(AppStrings.appName),
                  SignedInUserLabel(user: user),
                ],
              )
            : const Text(AppStrings.appName),
        actions: [
          if (!isMobile) Center(child: SignedInUserLabel(user: user)),
          const SizedBox(width: AppDimensions.spaceXs),
          const SignOutButton(),
          const SizedBox(width: AppDimensions.spaceXs),
        ],
      ),
      body: NoDataFoundWidget(
        icon: AppAssets.dashboard,
        title: AppStrings.welcome(user.name),
        message: user.roleDescription.isEmpty
            ? AppStrings.consolePlaceholder
            : user.roleDescription,
      ),
    );
  }
}

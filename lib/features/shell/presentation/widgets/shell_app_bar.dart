import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/responsive.dart';
import '../../../auth/domain/entities/current_user.dart';
import '../../../auth/presentation/widgets/sign_out_button.dart';
import 'signed_in_user_label.dart';

/// App name, the signed-in user (name, role, city) and sign-out. Phones show
/// the user under the title; web beside the sign-out button.
class ShellAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ShellAppBar({required this.user, super.key});

  final CurrentUser user;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    return AppBar(
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
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../auth/domain/entities/current_user.dart';
import '../../../auth/presentation/widgets/sign_out_button.dart';
import 'signed_in_user_label.dart';

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
                const AppLogo(height: AppDimensions.logoAppBarCompact),
                SignedInUserLabel(user: user),
              ],
            )
          : const AppLogo(height: AppDimensions.logoAppBar),
      actions: [
        if (!isMobile) Center(child: SignedInUserLabel(user: user)),
        const SizedBox(width: AppDimensions.spaceXs),
        const SignOutButton(),
        const SizedBox(width: AppDimensions.spaceXs),
      ],
    );
  }
}

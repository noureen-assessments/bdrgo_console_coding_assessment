import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/app_logo.dart';
import 'sign_in_form.dart';
import 'sign_in_status_message.dart';

class SignInCard extends StatelessWidget {
  const SignInCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(
          isMobile ? AppDimensions.spaceLg : AppDimensions.spaceXl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Align(
              alignment: AlignmentDirectional.centerStart,
              child: AppLogo(height: AppDimensions.logoSignIn),
            ),
            const SizedBox(height: AppDimensions.spaceSm),
            const Text(AppStrings.signInSubtitle, style: AppTextStyles.body),
            const SizedBox(height: AppDimensions.spaceLg),
            const SignInStatusMessage(),
            const SignInForm(),
          ],
        ),
      ),
    );
  }
}

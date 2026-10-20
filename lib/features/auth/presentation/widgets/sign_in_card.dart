import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/responsive.dart';
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
            Text(
              AppStrings.appName,
              style: isMobile
                  ? AppTextStyles.headlineCompact
                  : AppTextStyles.headline,
            ),
            const SizedBox(height: AppDimensions.spaceXxs),
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

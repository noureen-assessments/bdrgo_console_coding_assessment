import 'package:flutter/material.dart';

import '../../config/theme/app_dimensions.dart';
import '../../config/theme/app_text_styles.dart';
import '../../core/constants/app_assets.dart';
import '../../core/utils/responsive.dart';


class NoDataFoundWidget extends StatelessWidget {
  const NoDataFoundWidget({
    required this.title,
    this.icon = AppAssets.empty,
    this.message,
    this.action,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.pagePadding),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppDimensions.formMaxWidth,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: AppDimensions.iconXl),
              const SizedBox(height: AppDimensions.spaceMd),
              Text(
                title,
                textAlign: TextAlign.center,
                style: context.isMobile
                    ? AppTextStyles.headlineCompact
                    : AppTextStyles.headline,
              ),
              if (message case final message?) ...[
                const SizedBox(height: AppDimensions.spaceXs),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body,
                ),
              ],
              if (action case final action?) ...[
                const SizedBox(height: AppDimensions.spaceLg),
                action,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../config/theme/app_dimensions.dart';
import '../../config/theme/app_styles.dart';
import '../../core/constants/app_assets.dart';

/// Inline notice inside a page or form: an error, or neutral information.
class MessageBanner extends StatelessWidget {
  const MessageBanner({
    required this.message,
    this.isError = true,
    this.detail,
    super.key,
  });

  final String message;
  final String? detail;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: AppStyles.notice(isError: isError),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceSm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isError ? AppAssets.error : AppAssets.info,
                size: AppDimensions.iconMd,
                color: AppStyles.noticeForeground(isError: isError),
              ),
              const SizedBox(width: AppDimensions.spaceXs),
              Expanded(
                child: Text(
                  detail == null ? message : '$message\n$detail',
                  style: AppStyles.noticeText(isError: isError),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

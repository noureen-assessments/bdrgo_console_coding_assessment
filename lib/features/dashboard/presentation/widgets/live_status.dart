import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_styles.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/app_formatters.dart';


class LiveStatus extends StatelessWidget {
  const LiveStatus({
    required this.isLive,
    required this.updatedAt,
    super.key,
  });

  final bool isLive;
  final DateTime updatedAt;

  @override
  Widget build(BuildContext context) {
    final status = isLive ? AppStrings.live : AppStrings.reconnecting;
    return Semantics(
      liveRegion: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: AppStyles.statusDot(isLive: isLive),
            child: const SizedBox.square(dimension: AppDimensions.statusDot),
          ),
          const SizedBox(width: AppDimensions.spaceXs),
          Text(
            '$status · ${AppStrings.updatedAt(AppFormatters.time(updatedAt))}',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}

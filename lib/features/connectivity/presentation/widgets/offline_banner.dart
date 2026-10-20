import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_styles.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/connectivity_bloc.dart';


class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isOffline = context.select(
      (ConnectivityBloc bloc) => bloc.state is ConnectivityOffline,
    );
    return AnimatedSize(
      duration: AppStyles.animationDuration,
      child: !isOffline
          ? const SizedBox(width: double.infinity)
          : Material(
              color: AppColors.errorBackground,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceMd,
                  vertical: AppDimensions.spaceXs,
                ),
                child: Row(
                  children: [
                    Icon(
                      AppAssets.offline,
                      size: AppDimensions.iconSm,
                      color: AppStyles.noticeForeground(isError: true),
                    ),
                    const SizedBox(width: AppDimensions.spaceXs),
                    Expanded(
                      child: Text(
                        AppStrings.offline,
                        style: AppStyles.noticeText(isError: true),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

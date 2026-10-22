import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/trips/trips_bloc.dart';


class TripListFooter extends StatelessWidget {
  const TripListFooter({
    required this.state,
    required this.onLoadMore,
    super.key,
  });

  final TripsLoaded state;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    final error = state.nextPageError;
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(AppDimensions.spaceMd),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (error != null) {
      return Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceMd),
        child: Column(
          children: [
            const Text(AppStrings.loadMoreFailed, style: AppTextStyles.title),
            const SizedBox(height: AppDimensions.spaceXxs),
            Text(error, style: AppTextStyles.body, textAlign: TextAlign.center),
            const SizedBox(height: AppDimensions.spaceSm),
            FilledButton(
              onPressed: onLoadMore,
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      );
    }
    if (state.page.hasNextPage) {
      return Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceXs),
        child: Center(
          child: TextButton(
            onPressed: onLoadMore,
            child: const Text(AppStrings.loadMore),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

import 'package:flutter/material.dart';

import '../../config/theme/app_dimensions.dart';
import '../../config/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';

class LoadMoreFooter extends StatelessWidget {
  const LoadMoreFooter({
    required this.isLoadingMore,
    required this.hasNextPage,
    required this.onLoadMore,
    this.error,
    super.key,
  });

  final bool isLoadingMore;
  final bool hasNextPage;
  final VoidCallback onLoadMore;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final message = error;
    if (isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(AppDimensions.spaceMd),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (message != null) {
      return Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceMd),
        child: Column(
          children: [
            const Text(AppStrings.loadMoreFailed, style: AppTextStyles.title),
            const SizedBox(height: AppDimensions.spaceXxs),
            Text(message, style: AppTextStyles.body, textAlign: TextAlign.center),
            const SizedBox(height: AppDimensions.spaceSm),
            FilledButton(
              onPressed: onLoadMore,
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      );
    }
    if (hasNextPage) {
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

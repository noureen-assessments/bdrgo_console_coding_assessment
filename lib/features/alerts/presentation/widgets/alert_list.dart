import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../shared/widgets/load_more_footer.dart';
import '../../domain/entities/alert.dart';
import '../bloc/alerts/alerts_bloc.dart';
import 'alert_list_tile.dart';

class AlertList extends StatelessWidget {
  const AlertList({
    required this.state,
    required this.onLoadMore,
    required this.onAcknowledged,
    super.key,
  });

  final AlertsLoaded state;
  final VoidCallback onLoadMore;
  final ValueChanged<Alert> onAcknowledged;

  @override
  Widget build(BuildContext context) {
    final alerts = state.page.alerts;
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final nearEnd =
            notification.metrics.extentAfter < AppDimensions.loadMoreThreshold;
        if (nearEnd && state.canLoadMore) onLoadMore();
        return false;
      },
      child: ListView.separated(
        itemCount: alerts.length + 1,
        separatorBuilder: (_, _) =>
            const Divider(height: AppDimensions.dividerThin),
        itemBuilder: (context, index) {
          if (index == alerts.length) {
            return LoadMoreFooter(
              isLoadingMore: state.isLoadingMore,
              hasNextPage: state.page.hasNextPage,
              error: state.nextPageError,
              onLoadMore: onLoadMore,
            );
          }
          final alert = alerts[index];
          return AlertListTile(
            key: ValueKey(alert.id),
            alert: alert,
            onAcknowledged: onAcknowledged,
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../bloc/trips/trips_bloc.dart';
import 'trip_list_footer.dart';
import 'trip_list_tile.dart';

class TripList extends StatelessWidget {
  const TripList({required this.state, required this.onLoadMore, super.key});

  final TripsLoaded state;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    final trips = state.page.trips;
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final nearEnd =
            notification.metrics.extentAfter < AppDimensions.loadMoreThreshold;
        if (nearEnd && state.canLoadMore) onLoadMore();
        return false;
      },
      child: ListView.separated(
        itemCount: trips.length + 1,
        separatorBuilder: (_, _) =>
            const Divider(height: AppDimensions.dividerThin),
        itemBuilder: (context, index) {
          if (index == trips.length) {
            return TripListFooter(state: state, onLoadMore: onLoadMore);
          }
          final trip = trips[index];
          return TripListTile(key: ValueKey(trip.id), trip: trip);
        },
      ),
    );
  }
}

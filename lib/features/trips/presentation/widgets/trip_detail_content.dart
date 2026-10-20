import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/trip_detail.dart';
import '../../domain/entities/trip_status.dart';
import 'trip_cancellation_section.dart';
import 'trip_driver_section.dart';
import 'trip_fare_section.dart';
import 'trip_rider_section.dart';
import 'trip_route_section.dart';
import 'trip_status_badge.dart';
import 'trip_timeline_section.dart';

class TripDetailContent extends StatelessWidget {
  const TripDetailContent({required this.trip, super.key});

  final TripDetail trip;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.tripRoute(trip.pickupAddress, trip.dropoffAddress),
            style: context.isMobile
                ? AppTextStyles.headlineCompact
                : AppTextStyles.headline,
          ),
          const SizedBox(height: AppDimensions.spaceXs),
          TripStatusBadge(status: trip.status),
          const SizedBox(height: AppDimensions.spaceLg),
          Wrap(
            spacing: AppDimensions.spaceMd,
            runSpacing: AppDimensions.spaceMd,
            children: [
              TripRiderSection(trip: trip),
              TripDriverSection(trip: trip),
              TripRouteSection(trip: trip),
              TripFareSection(trip: trip),
              if (trip.status == TripStatus.cancelled)
                TripCancellationSection(trip: trip),
              TripTimelineSection(trip: trip),
            ],
          ),
        ],
      ),
    );
  }
}

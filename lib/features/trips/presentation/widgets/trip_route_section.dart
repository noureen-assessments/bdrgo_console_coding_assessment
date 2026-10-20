import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/number_formatters.dart';
import '../../domain/entities/trip_detail.dart';
import 'trip_detail_row.dart';
import 'trip_detail_section.dart';

class TripRouteSection extends StatelessWidget {
  const TripRouteSection({required this.trip, super.key});

  final TripDetail trip;

  @override
  Widget build(BuildContext context) {
    return TripDetailSection(
      title: AppStrings.sectionRoute,
      children: [
        TripDetailRow(label: AppStrings.labelPickup, value: trip.pickupAddress),
        TripDetailRow(
          label: AppStrings.labelDropoff,
          value: trip.dropoffAddress,
        ),
        TripDetailRow(
          label: AppStrings.labelDistance,
          value: AppStrings.distanceKm(
            NumberFormatters.decimal(trip.distanceKm),
          ),
        ),
        TripDetailRow(label: AppStrings.labelCity, value: trip.cityName),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/number_formatters.dart';
import '../../domain/entities/trip_detail.dart';
import 'trip_detail_row.dart';
import 'trip_detail_section.dart';

class TripRiderSection extends StatelessWidget {
  const TripRiderSection({required this.trip, super.key});

  final TripDetail trip;

  @override
  Widget build(BuildContext context) {
    final email = trip.riderEmail;
    return TripDetailSection(
      title: AppStrings.sectionRider,
      children: [
        TripDetailRow(label: AppStrings.labelName, value: trip.riderName),
        TripDetailRow(label: AppStrings.labelPhone, value: trip.riderPhone),
        if (email != null)
          TripDetailRow(label: AppStrings.labelEmail, value: email),
        TripDetailRow(
          label: AppStrings.labelRating,
          value: NumberFormatters.decimal(trip.riderRating),
        ),
      ],
    );
  }
}

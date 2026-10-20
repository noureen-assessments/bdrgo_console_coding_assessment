import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/number_formatters.dart';
import '../../domain/entities/trip_detail.dart';
import '../../../../shared/widgets/detail_row.dart';
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
        DetailRow(label: AppStrings.labelName, value: trip.riderName),
        DetailRow(label: AppStrings.labelPhone, value: trip.riderPhone),
        if (email != null)
          DetailRow(label: AppStrings.labelEmail, value: email),
        DetailRow(
          label: AppStrings.labelRating,
          value: NumberFormatters.decimal(trip.riderRating),
        ),
      ],
    );
  }
}

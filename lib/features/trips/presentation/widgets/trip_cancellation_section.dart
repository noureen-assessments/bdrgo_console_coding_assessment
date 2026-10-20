import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/trip_detail.dart';
import 'trip_detail_row.dart';
import 'trip_detail_section.dart';

class TripCancellationSection extends StatelessWidget {
  const TripCancellationSection({required this.trip, super.key});

  final TripDetail trip;

  @override
  Widget build(BuildContext context) {
    return TripDetailSection(
      title: AppStrings.sectionCancellation,
      children: [
        TripDetailRow(
          label: AppStrings.labelReason,
          value: trip.cancelReason ?? AppStrings.noValue,
        ),
        TripDetailRow(
          label: AppStrings.labelCancelledBy,
          value: trip.cancelledBy ?? AppStrings.noValue,
        ),
      ],
    );
  }
}

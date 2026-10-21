import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../../shared/widgets/detail_row.dart';
import '../../domain/entities/trip_detail.dart';
import 'trip_detail_section.dart';

class TripTimelineSection extends StatelessWidget {
  const TripTimelineSection({required this.trip, super.key});

  final TripDetail trip;

  @override
  Widget build(BuildContext context) {
    return TripDetailSection(
      title: AppStrings.sectionTimeline,
      children: [
        for (final entry in trip.timeline)
          DetailRow(
            label: entry.status.label,
            value: DateFormatters.dayTime(entry.at),
          ),
      ],
    );
  }
}

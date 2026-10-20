import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../domain/entities/trip_filter.dart';
import 'trip_date_range_button.dart';
import 'trip_search_field.dart';
import 'trip_status_filter.dart';


class TripFilterBar extends StatelessWidget {
  const TripFilterBar({
    required this.filter,
    required this.onChanged,
    super.key,
  });

  final TripFilter filter;
  final ValueChanged<TripFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppDimensions.spaceSm,
          runSpacing: AppDimensions.spaceXs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            TripSearchField(
              search: filter.search,
              onSubmitted: (text) => onChanged(filter.withSearch(text)),
            ),
            TripDateRangeButton(
              from: filter.from,
              to: filter.to,
              onChanged: (from, to) => onChanged(filter.withDates(from, to)),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceSm),
        TripStatusFilter(
          selected: filter.statuses,
          onChanged: (statuses) => onChanged(filter.withStatuses(statuses)),
        ),
      ],
    );
  }
}

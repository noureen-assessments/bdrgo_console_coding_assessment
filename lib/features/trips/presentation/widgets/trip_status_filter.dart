import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../domain/entities/trip_status.dart';

class TripStatusFilter extends StatelessWidget {
  const TripStatusFilter({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final Set<TripStatus> selected;
  final ValueChanged<Set<TripStatus>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.spaceXs,
      runSpacing: AppDimensions.spaceXs,
      children: [
        for (final status in TripStatus.values)
          FilterChip(
            label: Text(status.label),
            selected: selected.contains(status),
            onSelected: (isSelected) => _select(status, isSelected),
          ),
      ],
    );
  }

  void _select(TripStatus status, bool isSelected) {
    final statuses = Set<TripStatus>.of(selected);
    if (isSelected) {
      statuses.add(status);
    } else {
      statuses.remove(status);
    }
    onChanged(statuses);
  }
}

import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/kpi_range.dart';

/// Last 24h / Last 7 days.
class TripRangeSwitch extends StatelessWidget {
  const TripRangeSwitch({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final KpiRange selected;
  final ValueChanged<KpiRange> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<KpiRange>(
      segments: const [
        ButtonSegment(
          value: KpiRange.last24Hours,
          label: Text(AppStrings.rangeLast24Hours),
        ),
        ButtonSegment(
          value: KpiRange.last7Days,
          label: Text(AppStrings.rangeLast7Days),
        ),
      ],
      selected: {selected},
      showSelectedIcon: false,
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}

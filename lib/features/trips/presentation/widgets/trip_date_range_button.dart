import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_formatters.dart';

class TripDateRangeButton extends StatelessWidget {
  const TripDateRangeButton({
    required this.from,
    required this.to,
    required this.onChanged,
    super.key,
  });

  final DateTime? from;
  final DateTime? to;

  final void Function(DateTime? from, DateTime? to) onChanged;

  @override
  Widget build(BuildContext context) {
    final start = from;
    final end = to;
    final hasDates = start != null && end != null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton.icon(
          onPressed: () => _pick(context),
          icon: const Icon(AppAssets.dateRange),
          label: Text(
            hasDates
                ? AppStrings.dateRange(
                    DateFormatters.pickedDay(start),
                    DateFormatters.pickedDay(end),
                  )
                : AppStrings.anyDate,
          ),
        ),
        if (hasDates)
          IconButton(
            tooltip: AppStrings.clearDates,
            onPressed: () => onChanged(null, null),
            icon: const Icon(AppAssets.clear),
          ),
      ],
    );
  }

  Future<void> _pick(BuildContext context) async {
    final today = DateUtils.dateOnly(DateTime.now());
    final oneYearAgo = DateTime(today.year - 1, today.month, today.day);
    final start = from;
    final end = to;
    DateTimeRange? current;
    if (start != null && end != null) {
      current = DateTimeRange(start: start, end: end);
    }
    final picked = await showDateRangePicker(
      context: context,
      firstDate: oneYearAgo,
      lastDate: today,
      initialDateRange: current,
    );
    if (picked != null) onChanged(picked.start, picked.end);
  }
}

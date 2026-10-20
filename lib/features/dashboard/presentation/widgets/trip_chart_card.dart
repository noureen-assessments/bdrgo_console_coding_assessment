import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/kpi_range.dart';
import '../bloc/trip_chart/trip_chart_bloc.dart';
import 'trip_line_chart.dart';
import 'trip_range_switch.dart';

class TripChartCard extends StatelessWidget {
  const TripChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceMd),
        child: BlocBuilder<TripChartBloc, TripChartState>(
          builder: (context, state) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: AppDimensions.spaceMd,
                runSpacing: AppDimensions.spaceXs,
                children: [
                  const Text(
                    AppStrings.tripsOverTime,
                    style: AppTextStyles.title,
                  ),
                  TripRangeSwitch(
                    selected: state.range,
                    onChanged: (range) => _select(context, range),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceMd),
              SizedBox(
                height: AppDimensions.chartHeight,
                child: _body(context, state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, TripChartState state) {
    return switch (state) {
      TripChartLoading() => const Center(child: CircularProgressIndicator()),
      final TripChartError error => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(AppStrings.chartLoadFailed, style: AppTextStyles.title),
            const SizedBox(height: AppDimensions.spaceXxs),
            Text(
              error.message,
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spaceSm),
            FilledButton(
              onPressed: () => _select(context, error.range),
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      ),
      final TripChartLoaded loaded =>
        loaded.points.isEmpty
            ? const Center(
                child: Text(
                  AppStrings.noTripsInRange,
                  style: AppTextStyles.body,
                ),
              )
            : TripLineChart(points: loaded.points, range: loaded.range),
    };
  }

  void _select(BuildContext context, KpiRange range) =>
      context.read<TripChartBloc>().add(TripChartRangeSelected(range));
}

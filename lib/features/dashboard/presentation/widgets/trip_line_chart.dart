import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_styles.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../../core/utils/number_formatters.dart';
import '../../domain/entities/kpi_range.dart';
import '../../domain/entities/trip_series_point.dart';

class TripLineChart extends StatelessWidget {
  const TripLineChart({required this.points, required this.range, super.key});

  final List<TripSeriesPoint> points;
  final KpiRange range;

  static const _maxBottomLabels = 6;

  static const _seriesLabels = [
    AppStrings.seriesTotal,
    AppStrings.seriesCompleted,
    AppStrings.seriesCancelled,
  ];
  static const _seriesColors = [
    AppColors.chartTotal,
    AppColors.chartCompleted,
    AppColors.chartCancelled,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: LineChart(
            LineChartData(
              lineBarsData: [
                _line((point) => point.total, AppColors.chartTotal),
                _line((point) => point.completed, AppColors.chartCompleted),
                _line((point) => point.cancelled, AppColors.chartCancelled),
              ],
              minY: 0,
              gridData: FlGridData(
                verticalInterval: _bottomInterval(),
                getDrawingHorizontalLine: _gridLine,
                getDrawingVerticalLine: _gridLine,
              ),
              borderData: FlBorderData(
                border: const Border(
                  left: BorderSide(color: AppColors.chartAxis),
                  bottom: BorderSide(color: AppColors.chartAxis),
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: AppDimensions.chartLeftAxisSpace,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: AppDimensions.chartBottomAxisSpace,
                    interval: _bottomInterval(),
                    getTitlesWidget: _bottomTitle,
                  ),
                ),
              ),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => AppColors.chartTooltip,
                  getTooltipItems: _tooltipItems,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceXs),
        const _Legend(),
      ],
    );
  }

  LineChartBarData _line(int Function(TripSeriesPoint) value, Color color) {
    final spots = <FlSpot>[];
    for (var i = 0; i < points.length; i++) {
      spots.add(FlSpot(i.toDouble(), value(points[i]).toDouble()));
    }
    return LineChartBarData(
      spots: spots,
      color: color,
      barWidth: AppDimensions.chartLineWidth,
      isCurved: true,
      preventCurveOverShooting: true,
      dotData: const FlDotData(show: false),
    );
  }

  static FlLine _gridLine(double value) => const FlLine(
    color: AppColors.chartGrid,
    strokeWidth: AppDimensions.dividerThin,
  );

  double _bottomInterval() {
    if (points.length <= _maxBottomLabels) return 1;
    return (points.length / _maxBottomLabels).ceilToDouble();
  }

  Widget _bottomTitle(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index != value || index < 0 || index >= points.length) {
      return const SizedBox.shrink();
    }
    return SideTitleWidget(
      meta: meta,
      child: Text(_bucketLabel(points[index]), style: AppTextStyles.caption),
    );
  }

  String _bucketLabel(TripSeriesPoint point) => range == KpiRange.last24Hours
      ? DateFormatters.hour(point.bucket)
      : DateFormatters.day(point.bucket);

  List<LineTooltipItem> _tooltipItems(List<LineBarSpot> spots) {
    final items = <LineTooltipItem>[];
    for (final spot in spots) {
      var text = AppStrings.seriesValue(
        _seriesLabels[spot.barIndex],
        NumberFormatters.count(spot.y.toInt()),
      );
      if (items.isEmpty) {
        text = '${_bucketLabel(points[spot.x.toInt()])}\n$text';
      }
      items.add(LineTooltipItem(text, AppStyles.chartTooltipText));
    }
    return items;
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final entries = <Widget>[];
    for (var i = 0; i < TripLineChart._seriesLabels.length; i++) {
      entries.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: AppStyles.legendDot(TripLineChart._seriesColors[i]),
              child: const SizedBox.square(dimension: AppDimensions.statusDot),
            ),
            const SizedBox(width: AppDimensions.spaceXxs),
            Text(TripLineChart._seriesLabels[i], style: AppTextStyles.caption),
          ],
        ),
      );
    }
    return Wrap(
      spacing: AppDimensions.spaceMd,
      runSpacing: AppDimensions.spaceXxs,
      children: entries,
    );
  }
}

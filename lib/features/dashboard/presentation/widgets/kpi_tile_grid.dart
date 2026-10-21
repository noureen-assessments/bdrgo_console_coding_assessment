import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/number_formatters.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/kpis.dart';
import 'kpi_tile.dart';


class KpiTileGrid extends StatelessWidget {
  const KpiTileGrid({required this.kpis, super.key});

  final Kpis kpis;

  @override
  Widget build(BuildContext context) {
    final trips = kpis.trips;
    final drivers = kpis.drivers;
    final tiles = [
      KpiTile(
        label: AppStrings.kpiActiveTrips,
        accent: AppColors.kpiActiveTrips,
        value: NumberFormatters.count(trips.active),
        detail: AppStrings.kpiActiveBreakdown(
          NumberFormatters.count(trips.requested),
          NumberFormatters.count(trips.assigned),
          NumberFormatters.count(trips.inProgress),
        ),
      ),
      KpiTile(
        label: AppStrings.kpiCompleted,
        accent: AppColors.kpiCompleted,
        value: NumberFormatters.count(trips.completed),
        detail: AppStrings.kpiLast24Hours,
      ),
      KpiTile(
        label: AppStrings.kpiCancellationRate,
        accent: AppColors.kpiCancellation,
        value: NumberFormatters.percent(trips.cancellationRate),
        detail: AppStrings.kpiCancelled(
          NumberFormatters.count(trips.cancelled),
        ),
      ),
      KpiTile(
        label: AppStrings.kpiDrivers,
        accent: AppColors.kpiDrivers,
        value: AppStrings.kpiDriverPair(
          NumberFormatters.count(drivers.available),
          NumberFormatters.count(drivers.onTrip),
        ),
        detail: AppStrings.kpiDriversTotal(
          NumberFormatters.count(drivers.total),
        ),
      ),
      KpiTile(
        label: AppStrings.kpiOpenAlerts,
        accent: AppColors.kpiOpenAlerts,
        value: NumberFormatters.count(kpis.openAlerts),
        detail: AppStrings.kpiOpenAlertsDetail,
      ),
    ];

    final columns = context.isDesktop
        ? AppDimensions.kpiColumnsDesktop
        : AppDimensions.kpiColumnsMobile;
    final rows = <Widget>[];
    for (var start = 0; start < tiles.length; start += columns) {
      if (rows.isNotEmpty) {
        rows.add(const SizedBox(height: AppDimensions.spaceMd));
      }
      rows.add(_row(tiles, start, columns));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }

  static Widget _row(List<Widget> tiles, int start, int columns) {
    final cells = <Widget>[];
    for (var index = start; index < start + columns; index++) {
      if (cells.isNotEmpty) {
        cells.add(const SizedBox(width: AppDimensions.spaceMd));
      }
      if (index < tiles.length) {
        cells.add(Expanded(child: tiles[index]));
      } else {
        cells.add(const Spacer());
      }
    }
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: cells,
      ),
    );
  }
}

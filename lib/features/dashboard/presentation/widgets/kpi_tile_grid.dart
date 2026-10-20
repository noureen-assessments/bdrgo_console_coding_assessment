import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/entities/money.dart';
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
        icon: AppAssets.activeTrips,
        value: AppFormatters.count(trips.active),
        detail: AppStrings.kpiActiveBreakdown(
          AppFormatters.count(trips.requested),
          AppFormatters.count(trips.assigned),
          AppFormatters.count(trips.inProgress),
        ),
      ),
      KpiTile(
        label: AppStrings.kpiCompleted,
        icon: AppAssets.completedTrips,
        value: AppFormatters.count(trips.completed),
        detail: AppStrings.kpiLast24Hours,
      ),
      KpiTile(
        label: AppStrings.kpiCancellationRate,
        icon: AppAssets.cancellationRate,
        value: AppFormatters.percent(trips.cancellationRate),
        detail: AppStrings.kpiCancelled(AppFormatters.count(trips.cancelled)),
      ),
      KpiTile(
        label: AppStrings.kpiRevenue,
        icon: AppAssets.revenue,
        value: _revenue(kpis.revenue),
        detail: AppStrings.kpiLast24Hours,
      ),
      KpiTile(
        label: AppStrings.kpiDrivers,
        icon: AppAssets.drivers,
        value: AppStrings.kpiDriverPair(
          AppFormatters.count(drivers.available),
          AppFormatters.count(drivers.onTrip),
        ),
        detail: AppStrings.kpiDriversTotal(AppFormatters.count(drivers.total)),
      ),
      KpiTile(
        label: AppStrings.kpiOpenAlerts,
        icon: AppAssets.openAlerts,
        value: AppFormatters.count(kpis.openAlerts),
        detail: AppStrings.kpiOpenAlertsDetail,
      ),
    ];

    final columns = context.isDesktop
        ? AppDimensions.kpiColumnsDesktop
        : AppDimensions.kpiColumnsMobile;
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = AppDimensions.spaceMd;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: tiles
              .map((tile) => SizedBox(width: width, child: tile))
              .toList(),
        );
      },
    );
  }

  /// One line per currency
  static String _revenue(List<Money> revenue) {
    if (revenue.isEmpty) return AppStrings.noValue;
    return revenue
        .map((money) => AppFormatters.currency(money.amount, money.currency))
        .join('\n');
  }
}

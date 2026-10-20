import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/number_formatters.dart';
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
        value: NumberFormatters.count(trips.active),
        detail: AppStrings.kpiActiveBreakdown(
          NumberFormatters.count(trips.requested),
          NumberFormatters.count(trips.assigned),
          NumberFormatters.count(trips.inProgress),
        ),
      ),
      KpiTile(
        label: AppStrings.kpiCompleted,
        icon: AppAssets.completedTrips,
        value: NumberFormatters.count(trips.completed),
        detail: AppStrings.kpiLast24Hours,
      ),
      KpiTile(
        label: AppStrings.kpiCancellationRate,
        icon: AppAssets.cancellationRate,
        value: NumberFormatters.percent(trips.cancellationRate),
        detail: AppStrings.kpiCancelled(
          NumberFormatters.count(trips.cancelled),
        ),
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
          NumberFormatters.count(drivers.available),
          NumberFormatters.count(drivers.onTrip),
        ),
        detail: AppStrings.kpiDriversTotal(
          NumberFormatters.count(drivers.total),
        ),
      ),
      KpiTile(
        label: AppStrings.kpiOpenAlerts,
        icon: AppAssets.openAlerts,
        value: NumberFormatters.count(kpis.openAlerts),
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
        .map((money) => NumberFormatters.currency(money.amount, money.currency))
        .join('\n');
  }
}

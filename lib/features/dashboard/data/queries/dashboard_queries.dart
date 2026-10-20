import '../../domain/entities/kpi_range.dart';


abstract final class DashboardQueries {
  static const kpis = r'''
    query DashboardKpis($range: KpiRange!) {
      kpis(range: $range) {
        generatedAt
        openAlerts
        trips {
          active
          completed
          cancelled
          cancellationRate
          requested
          assigned
          inProgress
        }
        drivers {
          available
          onTrip
          offline
          total
        }
        revenue {
          amount
          currency
        }
      }
    }
  ''';

  /// chart for the last 7 days.
  static const tripSeries = r'''
    query DashboardTripSeries($range: KpiRange!) {
      kpis(range: $range) {
        series {
          bucket
          total
          completed
          cancelled
        }
      }
    }
  ''';

  static Map<String, Object?> rangeVariables(KpiRange range) => {
    'range': range.value,
  };
}

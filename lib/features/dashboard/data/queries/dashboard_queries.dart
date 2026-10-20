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

  static Map<String, Object?> kpisVariables(KpiRange range) => {
    'range': range.value,
  };
}

/// The time window KPIs cover, with the API's `KpiRange` enum value.
enum KpiRange {
  last24Hours('LAST_24H'),
  last7Days('LAST_7D');

  const KpiRange(this.value);

  final String value;
}

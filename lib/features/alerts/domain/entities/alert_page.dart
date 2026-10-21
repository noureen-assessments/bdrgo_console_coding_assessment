import 'package:equatable/equatable.dart';

import 'alert.dart';

class AlertPage extends Equatable {
  const AlertPage({
    required this.alerts,
    required this.page,
    required this.totalPages,
  });

  final List<Alert> alerts;
  final int page;
  final int totalPages;

  bool get hasNextPage => page < totalPages;

  AlertPage append(AlertPage next) {
    final shownIds = <String>{};
    for (final alert in alerts) {
      shownIds.add(alert.id);
    }
    final merged = [...alerts];
    for (final alert in next.alerts) {
      if (!shownIds.contains(alert.id)) merged.add(alert);
    }
    return AlertPage(
      alerts: merged,
      page: next.page,
      totalPages: next.totalPages,
    );
  }

  Alert? find(String alertId) {
    for (final alert in alerts) {
      if (alert.id == alertId) return alert;
    }
    return null;
  }

  bool contains(String alertId) => find(alertId) != null;

  AlertPage replace(Alert alert) {
    final updated = <Alert>[];
    for (final row in alerts) {
      updated.add(row.id == alert.id ? alert : row);
    }
    return AlertPage(alerts: updated, page: page, totalPages: totalPages);
  }

  AlertPage addOnTop(Alert alert) => AlertPage(
    alerts: [alert, ...alerts],
    page: page,
    totalPages: totalPages,
  );

  @override
  List<Object?> get props => [alerts, page, totalPages];
}

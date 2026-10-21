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

  @override
  List<Object?> get props => [alerts, page, totalPages];
}

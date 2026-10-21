import '../../domain/entities/alert_page.dart';
import 'alert_model.dart';

class AlertPageModel extends AlertPage {
  const AlertPageModel({
    required List<AlertModel> super.alerts,
    required super.page,
    required super.totalPages,
  });

  factory AlertPageModel.fromJson(Map<String, dynamic> json) => AlertPageModel(
    alerts: AlertModel.listFromJson(json['data'] as List<dynamic>),
    page: (json['page'] as num).toInt(),
    totalPages: (json['totalPages'] as num).toInt(),
  );

  @override
  List<AlertModel> get alerts => super.alerts as List<AlertModel>;

  Map<String, dynamic> toJson() => {
    'data': alerts.map((alert) => alert.toJson()).toList(),
    'page': page,
    'totalPages': totalPages,
  };
}

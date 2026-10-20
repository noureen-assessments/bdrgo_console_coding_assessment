import '../../domain/entities/available_driver.dart';

class AvailableDriverModel extends AvailableDriver {
  const AvailableDriverModel({
    required super.id,
    required super.name,
  });

  factory AvailableDriverModel.fromJson(Map<String, dynamic> json) =>
      AvailableDriverModel(
        id: json['id'] as String,
        name: json['name'] as String,
      );

  static List<AvailableDriverModel> listFromJson(List<dynamic> json) {
    final drivers = <AvailableDriverModel>[];
    for (final item in json) {
      drivers.add(AvailableDriverModel.fromJson(item as Map<String, dynamic>));
    }
    return drivers;
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

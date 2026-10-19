import '../../domain/entities/city.dart';

/// The `city` object inside `GET /api/me`.
class CityModel extends City {
  const CityModel({required super.id, required super.name});

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      CityModel(id: json['id'] as String, name: json['name'] as String);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

import '../../domain/entities/current_user.dart';
import 'city_model.dart';
import 'permissions_model.dart';

/// `GET /api/me` response:
///
/// ```json
/// {
///   "user": { "id", "name", "email" },
///   "role": "dispatcher",
///   "roleDescription": "…",
///   "city": { "id", "name", … } | null,
///   "permissions": { "trip": ["read", "assign"], … }
/// }
/// ```
class MeModel extends CurrentUser {
  const MeModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required PermissionsModel super.permissions,
    super.roleDescription,
    CityModel? super.city,
  });

  factory MeModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    final city = json['city'] as Map<String, dynamic>?;
    final permissions = json['permissions'] as Map<String, dynamic>?;

    return MeModel(
      id: user['id'] as String,
      name: user['name'] as String,
      email: user['email'] as String,
      role: json['role'] as String,
      roleDescription: json['roleDescription'] as String? ?? '',
      city: city == null ? null : CityModel.fromJson(city),
      permissions: PermissionsModel.fromJson(permissions ?? {}),
    );
  }

  // The constructor only accepts the model types, so these casts are safe.
  @override
  CityModel? get city => super.city as CityModel?;

  @override
  PermissionsModel get permissions => super.permissions as PermissionsModel;

  Map<String, dynamic> toJson() => {
    'user': {'id': id, 'name': name, 'email': email},
    'role': role,
    'roleDescription': roleDescription,
    'city': city?.toJson(),
    'permissions': permissions.toJson(),
  };
}

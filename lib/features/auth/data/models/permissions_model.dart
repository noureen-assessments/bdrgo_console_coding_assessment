import '../../domain/entities/permissions.dart';

/// The `permissions` object inside `GET /api/me`:
/// `{ "trip": ["read", "assign"], "kpi": ["read"] }`.
class PermissionsModel extends Permissions {
  const PermissionsModel(super.grants);

  factory PermissionsModel.fromJson(Map<String, dynamic> json) {
    final grants = <String, Set<String>>{};
    json.forEach((resource, actions) {
      grants[resource] = Set<String>.from(actions as List);
    });
    return PermissionsModel(grants);
  }

  Map<String, dynamic> toJson() => {
    for (final MapEntry(:key, :value) in grants.entries) key: value.toList(),
  };
}

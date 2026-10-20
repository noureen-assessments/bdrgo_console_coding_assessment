import '../../domain/entities/permission.dart';
import '../../domain/entities/permissions.dart';

/// The `permissions` object inside `GET /api/me`:
/// `{ "trip": ["read", "assign"], "kpi": ["read"] }`.
///
/// Resources and actions the app does not know are skipped: nothing can ask
/// for them, so they would never be granted anyway.
class PermissionsModel extends Permissions {
  const PermissionsModel(super.granted);

  factory PermissionsModel.fromJson(Map<String, dynamic> json) {
    final granted = <Permission>{};
    json.forEach((resourceName, actionNames) {
      final resource = PermissionResource.fromValue(resourceName);
      if (resource == null) return;

      for (final actionName in actionNames as List) {
        final permission = resource.action(actionName as String);
        if (permission != null) granted.add(permission);
      }
    });
    return PermissionsModel(granted);
  }

  Map<String, dynamic> toJson() {
    final json = <String, List<String>>{};
    for (final permission in granted) {
      (json[permission.resource.value] ??= []).add(permission.value);
    }
    return json;
  }
}

/// The `role` from `/api/me`. Shown to the user only; access checks use
/// `Permissions`, never the role.
enum UserRole {
  superAdmin('super_admin'),
  opsManager('ops_manager'),
  dispatcher('dispatcher'),
  support('support'),
  viewer('viewer'),

  /// A role this app does not know yet. Access still works, because it comes
  /// from `permissions`.
  unknown('');

  const UserRole(this.value);

  /// The name the API uses.
  final String value;

  static UserRole fromValue(String value) =>
      values.firstWhere((role) => role.value == value, orElse: () => unknown);
}

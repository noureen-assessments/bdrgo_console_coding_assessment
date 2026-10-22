enum UserRole {
  superAdmin('super_admin'),
  opsManager('ops_manager'),
  dispatcher('dispatcher'),
  support('support'),
  viewer('viewer'),

  unknown('');

  const UserRole(this.value);

  final String value;

  static UserRole fromValue(String value) =>
      values.firstWhere((role) => role.value == value, orElse: () => unknown);
}

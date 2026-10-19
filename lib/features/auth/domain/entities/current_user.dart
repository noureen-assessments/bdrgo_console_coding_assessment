import 'package:equatable/equatable.dart';

import 'city.dart';
import 'permissions.dart';

/// The signed-in user as returned by `GET /api/me`.
class CurrentUser extends Equatable {
  const CurrentUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.permissions,
    this.roleDescription = '',
    this.city,
  });

  final String id;
  final String name;
  final String email;

  /// Shown to the user only; access checks use [permissions].
  final String role;
  final String roleDescription;

  /// Null for `super_admin`, who sees every city.
  final City? city;
  final Permissions permissions;

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    role,
    roleDescription,
    city,
    permissions,
  ];
}

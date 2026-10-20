import 'package:equatable/equatable.dart';

import 'city.dart';
import 'permissions.dart';
import 'user_role.dart';

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

  final UserRole role;
  final String roleDescription;

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

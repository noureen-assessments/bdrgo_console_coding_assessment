import 'package:equatable/equatable.dart';

import 'permission.dart';

/// What the signed-in user may do, from the `permissions` map in `/api/me`.
///
/// Navigation, routes and buttons ask [can]; nothing in the app branches on
/// the role.
class Permissions extends Equatable {
  const Permissions(this.granted);

  static const none = Permissions({});

  final Set<Permission> granted;

  bool can(Permission permission) => granted.contains(permission);

  @override
  List<Object?> get props => [granted];
}

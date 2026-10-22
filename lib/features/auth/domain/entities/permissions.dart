import 'package:equatable/equatable.dart';

import 'permission.dart';

class Permissions extends Equatable {
  const Permissions(this.granted);

  static const none = Permissions({});

  final Set<Permission> granted;

  bool can(Permission permission) => granted.contains(permission);

  @override
  List<Object?> get props => [granted];
}

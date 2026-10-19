import 'package:equatable/equatable.dart';

/// The `permissions` map from `/api/me`, e.g. `{ "trip": ["read", "assign"] }`.
///
/// Navigation, routes and buttons ask [can]; nothing in the app branches on
/// the role name.
class Permissions extends Equatable {
  const Permissions(this.grants);

  static const none = Permissions({});

  /// Resource name → allowed actions.
  final Map<String, Set<String>> grants;

  bool can(String resource, String action) =>
      grants[resource]?.contains(action) ?? false;

  @override
  List<Object?> get props => [grants];
}

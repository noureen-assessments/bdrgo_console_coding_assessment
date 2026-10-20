import 'package:equatable/equatable.dart';

/// The city a user is pinned to. Only `super_admin` has none.
class City extends Equatable {
  const City({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

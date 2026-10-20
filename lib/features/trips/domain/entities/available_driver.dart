import 'package:equatable/equatable.dart';

class AvailableDriver extends Equatable {
  const AvailableDriver({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

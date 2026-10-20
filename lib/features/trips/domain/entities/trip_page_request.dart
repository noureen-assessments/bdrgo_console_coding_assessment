import 'package:equatable/equatable.dart';

class TripPageRequest extends Equatable {
  const TripPageRequest({this.after});

  final String? after;

  @override
  List<Object?> get props => [after];
}

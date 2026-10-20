import 'package:equatable/equatable.dart';


class TripChange extends Equatable {
  const TripChange({required this.tripId, required this.isNew});

  final String tripId;

  final bool isNew;

  @override
  List<Object?> get props => [tripId, isNew];
}

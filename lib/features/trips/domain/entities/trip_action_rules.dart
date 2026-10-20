import 'trip_status.dart';

abstract final class TripActionRules {
  static const assignFrom = {TripStatus.requested};
  static const cancelFrom = {TripStatus.requested, TripStatus.assigned};
  static const refundFrom = {TripStatus.completed};
}

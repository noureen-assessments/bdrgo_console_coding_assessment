import 'package:flutter/material.dart';

/// Every icon (and later image) the app uses, so a visual change is made in
/// one place.
abstract final class AppAssets {
  // Sign-in
  static const IconData email = Icons.email_outlined;
  static const IconData password = Icons.lock_outline;
  static const IconData showPassword = Icons.visibility;
  static const IconData hidePassword = Icons.visibility_off;

  // Session
  static const IconData restoringSession = Icons.lock_clock_outlined;
  static const IconData restoreFailed = Icons.cloud_off_outlined;
  static const IconData signOut = Icons.logout;

  // Console sections
  static const IconData dashboard = Icons.dashboard_outlined;
  static const IconData trips = Icons.local_taxi_outlined;
  static const IconData liveMap = Icons.map_outlined;
  static const IconData alerts = Icons.notifications_outlined;
  static const IconData noAccess = Icons.lock_person_outlined;

  // Dashboard KPI tiles
  static const IconData activeTrips = Icons.directions_car_outlined;
  static const IconData completedTrips = Icons.check_circle_outline;
  static const IconData cancellationRate = Icons.cancel_outlined;
  static const IconData revenue = Icons.payments_outlined;
  static const IconData drivers = Icons.people_outline;
  static const IconData openAlerts = Icons.warning_amber_outlined;

  // Connectivity
  static const IconData offline = Icons.wifi_off;

  // Notices and empty states
  static const IconData error = Icons.error_outline;
  static const IconData info = Icons.info_outline;
  static const IconData empty = Icons.inbox_outlined;
  static const IconData notFound = Icons.search_off;
}

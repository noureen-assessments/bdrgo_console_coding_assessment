import 'package:flutter/material.dart';

abstract final class AppAssets {
  static const String logo = 'assets/images/badrgo_logo.svg';

  static const IconData email = Icons.email_outlined;
  static const IconData password = Icons.lock_outline;
  static const IconData showPassword = Icons.visibility;
  static const IconData hidePassword = Icons.visibility_off;

  static const IconData restoringSession = Icons.lock_clock_outlined;
  static const IconData restoreFailed = Icons.cloud_off_outlined;
  static const IconData signOut = Icons.logout;

  static const IconData dashboard = Icons.dashboard_outlined;
  static const IconData trips = Icons.local_taxi_outlined;
  static const IconData liveMap = Icons.map_outlined;
  static const IconData alerts = Icons.notifications_outlined;
  static const IconData noAccess = Icons.lock_person_outlined;

  static const IconData criticalAlert = Icons.sos;

  static const IconData search = Icons.search;
  static const IconData clear = Icons.close;
  static const IconData dateRange = Icons.date_range_outlined;

  static const IconData cancelTrip = Icons.block;
  static const IconData assignDriver = Icons.person_add_alt_1_outlined;
  static const IconData selected = Icons.check_circle;
  static const IconData refund = Icons.currency_exchange;

  static const IconData offline = Icons.wifi_off;
  static const IconData maintenance = Icons.construction;

  static const IconData driverMarker = Icons.directions_car;

  static const IconData error = Icons.error_outline;
  static const IconData info = Icons.info_outline;
  static const IconData empty = Icons.inbox_outlined;
  static const IconData notFound = Icons.search_off;
}

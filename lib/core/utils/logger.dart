import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

import '../constants/log_constants.dart';

/// Debug-only logging to the browser/DevTools console. Never log tokens,
/// passwords or request bodies.
abstract final class AppLogger {
  static void info(String message, {String name = LogTags.app}) =>
      _log(message, name: name);

  static void warning(String message, {String name = LogTags.app}) =>
      _log(message, name: name, level: 900);

  static void error(
    String message, {
    String name = LogTags.app,
    Object? error,
    StackTrace? stackTrace,
  }) => _log(
    message,
    name: name,
    level: 1000,
    error: error,
    stackTrace: stackTrace,
  );

  static void _log(
    String message, {
    required String name,
    int level = 800,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;
    developer.log(
      message,
      name: name,
      level: level,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

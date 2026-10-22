import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/log_constants.dart';
import '../storage/storage_keys.dart';
import '../storage/token_storage.dart';
import 'logger.dart';

AndroidOptions _getAndroidOptions() => const AndroidOptions();

IOSOptions _getIOSOptions() => const IOSOptions(
  accessibility: KeychainAccessibility.first_unlock_this_device,
);


WebOptions _getWebOptions() => const WebOptions(useSessionStorage: true);

class AppSecureStorage implements TokenStorage {
  AppSecureStorage({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          FlutterSecureStorage(
            aOptions: _getAndroidOptions(),
            iOptions: _getIOSOptions(),
            webOptions: _getWebOptions(),
          );

  final FlutterSecureStorage _storage;
  String? _cachedToken;

  @override
  Future<void> saveToken(String tokenValue) async {
    if (tokenValue.isEmpty) {
      _handleError(LogMessages.emptyToken, StackTrace.current);
      return;
    }
    if (await _write(StorageKeys.token, tokenValue)) _cachedToken = tokenValue;
  }

  @override
  Future<String?> getToken() async =>
      _cachedToken ??= await _read(StorageKeys.token);

  @override
  Future<void> deleteToken() async {
    _cachedToken = null;
    await _delete(StorageKeys.token);
  }

  Future<void> deleteAll() async {
    _cachedToken = null;
    try {
      await _storage.deleteAll();
    } on Exception catch (e, stack) {
      _handleError(e, stack);
    }
  }

  Future<bool> _write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      return true;
    } on PlatformException catch (e, stack) {
      if (e.code == StoragePlatformErrors.writeFailedCode ||
          e.message?.contains(StoragePlatformErrors.alreadyExistsMessage) ==
              true) {
        try {
          await _storage.delete(key: key);
          await _storage.write(key: key, value: value);
          return true;
        } on Exception catch (retryError, retryStack) {
          _handleError(retryError, retryStack);
        }
      } else {
        _handleError(e, stack);
      }
    } on Exception catch (e, stack) {
      _handleError(e, stack);
    }
    return false;
  }

  Future<String?> _read(String key) async {
    try {
      return await _storage.read(key: key);
    } on Exception catch (e, stack) {
      _handleError(e, stack);
      return null;
    }
  }

  Future<void> _delete(String key) async {
    try {
      await _storage.delete(key: key);
    } on Exception catch (e, stack) {
      _handleError(e, stack);
    }
  }

  void _handleError(Object error, StackTrace stackTrace) {
    AppLogger.error(
      LogMessages.secureStorageFailed,
      name: LogTags.storage,
      error: sanitizeError(error),
      stackTrace: _sanitizeStackTrace(stackTrace),
    );
  }

  static Object sanitizeError(Object error) {
    var errorString = error.toString();
    for (final pattern in SensitiveDataPatterns.inErrors) {
      errorString = errorString.replaceAll(pattern, LogMessages.redacted);
    }
    return Exception(errorString);
  }

  StackTrace _sanitizeStackTrace(StackTrace stackTrace) {
    final stackString = stackTrace.toString().replaceAllMapped(
      SensitiveDataPatterns.filePath,
      (match) => LogMessages.redactedFrame(match.group(1)),
    );
    return StackTrace.fromString(stackString);
  }
}

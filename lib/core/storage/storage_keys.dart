abstract final class StorageKeys {
  static const token = 'auth_token';
}

/// Platform error signals from `flutter_secure_storage` that mean a stale
/// entry is blocking the write (seen on the iOS Keychain).
abstract final class StoragePlatformErrors {
  static const writeFailedCode = 'write_failed';
  static const alreadyExistsMessage = 'already exists';
}

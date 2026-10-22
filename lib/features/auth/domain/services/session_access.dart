import '../entities/permission.dart';

abstract interface class SessionAccess {
  bool get isSignedIn;

  bool can(Permission permission);
}

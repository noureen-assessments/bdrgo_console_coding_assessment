part of 'connectivity_bloc.dart';

sealed class ConnectivityEvent {
  const ConnectivityEvent();
}

/// Reads the current status, then follows changes until the Bloc closes.
final class ConnectivityStarted extends ConnectivityEvent {
  const ConnectivityStarted();
}

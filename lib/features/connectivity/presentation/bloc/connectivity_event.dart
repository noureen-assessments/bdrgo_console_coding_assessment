part of 'connectivity_bloc.dart';

sealed class ConnectivityEvent {
  const ConnectivityEvent();
}

final class ConnectivityStarted extends ConnectivityEvent {
  const ConnectivityStarted();
}

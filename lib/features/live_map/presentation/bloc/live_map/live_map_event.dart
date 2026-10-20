part of 'live_map_bloc.dart';

sealed class LiveMapEvent {
  const LiveMapEvent();
}

final class LiveMapStarted extends LiveMapEvent {
  const LiveMapStarted();
}

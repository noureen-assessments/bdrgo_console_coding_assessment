part of 'live_map_bloc.dart';

sealed class LiveMapState extends Equatable {
  const LiveMapState();

  @override
  List<Object?> get props => [];
}

final class LiveMapLoading extends LiveMapState {
  const LiveMapLoading();
}

final class LiveMapLoaded extends LiveMapState {
  const LiveMapLoaded(this.drivers, {this.isLive = false});

  final List<DriverLocation> drivers;
  final bool isLive;

  @override
  List<Object?> get props => [drivers, isLive];
}

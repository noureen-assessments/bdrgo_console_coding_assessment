part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

final class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

final class DashboardError extends DashboardState {
  const DashboardError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class DashboardLoaded extends DashboardState {
  const DashboardLoaded(this.kpis, {this.isLive = false});

  final Kpis kpis;
  final bool isLive;

  @override
  List<Object?> get props => [kpis, isLive];
}

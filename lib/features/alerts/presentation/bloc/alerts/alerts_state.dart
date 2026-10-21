part of 'alerts_bloc.dart';

sealed class AlertsState extends Equatable {
  const AlertsState(this.openOnly, {this.isLive = false});

  final bool openOnly;
  final bool isLive;

  AlertsState withLive(bool isLive);

  @override
  List<Object?> get props => [openOnly, isLive];
}

final class AlertsLoading extends AlertsState {
  const AlertsLoading(super.openOnly, {super.isLive});

  @override
  AlertsLoading withLive(bool isLive) =>
      AlertsLoading(openOnly, isLive: isLive);
}

final class AlertsError extends AlertsState {
  const AlertsError(super.openOnly, this.message, {super.isLive});

  final String message;

  @override
  AlertsError withLive(bool isLive) =>
      AlertsError(openOnly, message, isLive: isLive);

  @override
  List<Object?> get props => [openOnly, isLive, message];
}

final class AlertsLoaded extends AlertsState {
  const AlertsLoaded(
    super.openOnly,
    this.page, {
    super.isLive,
    this.isLoadingMore = false,
    this.nextPageError,
  });

  final AlertPage page;
  final bool isLoadingMore;
  final String? nextPageError;

  bool get canLoadMore =>
      page.hasNextPage && !isLoadingMore && nextPageError == null;

  @override
  AlertsLoaded withLive(bool isLive) => AlertsLoaded(
    openOnly,
    page,
    isLive: isLive,
    isLoadingMore: isLoadingMore,
    nextPageError: nextPageError,
  );

  @override
  List<Object?> get props => [
    openOnly,
    isLive,
    page,
    isLoadingMore,
    nextPageError,
  ];
}

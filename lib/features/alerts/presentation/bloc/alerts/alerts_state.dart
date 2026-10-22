part of 'alerts_bloc.dart';

sealed class AlertsState extends Equatable {
  const AlertsState({this.isLive = false});

  final bool isLive;

  AlertsState withLive(bool isLive);

  @override
  List<Object?> get props => [isLive];
}

final class AlertsLoading extends AlertsState {
  const AlertsLoading({super.isLive});

  @override
  AlertsLoading withLive(bool isLive) => AlertsLoading(isLive: isLive);
}

final class AlertsError extends AlertsState {
  const AlertsError(this.message, {super.isLive});

  final String message;

  @override
  AlertsError withLive(bool isLive) => AlertsError(message, isLive: isLive);

  @override
  List<Object?> get props => [isLive, message];
}

final class AlertsLoaded extends AlertsState {
  const AlertsLoaded(
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

  AlertsLoaded withPage(AlertPage page) => AlertsLoaded(
    page,
    isLive: isLive,
    isLoadingMore: isLoadingMore,
    nextPageError: nextPageError,
  );

  @override
  AlertsLoaded withLive(bool isLive) => AlertsLoaded(
    page,
    isLive: isLive,
    isLoadingMore: isLoadingMore,
    nextPageError: nextPageError,
  );

  @override
  List<Object?> get props => [isLive, page, isLoadingMore, nextPageError];
}

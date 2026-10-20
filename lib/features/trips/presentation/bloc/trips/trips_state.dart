part of 'trips_bloc.dart';

sealed class TripsState extends Equatable {
  const TripsState(this.filter);

  final TripFilter filter;

  @override
  List<Object?> get props => [filter];
}

final class TripsLoading extends TripsState {
  const TripsLoading(super.filter);
}

final class TripsError extends TripsState {
  const TripsError(super.filter, this.message);

  final String message;

  @override
  List<Object?> get props => [filter, message];
}

final class TripsLoaded extends TripsState {
  const TripsLoaded(
    super.filter,
    this.page, {
    this.isLoadingMore = false,
    this.nextPageError,
  });

  final TripPage page;
  final bool isLoadingMore;
  final String? nextPageError;
  bool get canLoadMore =>
      page.hasNextPage && !isLoadingMore && nextPageError == null;

  @override
  List<Object?> get props => [filter, page, isLoadingMore, nextPageError];
}

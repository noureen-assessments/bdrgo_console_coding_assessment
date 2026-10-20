part of 'trips_bloc.dart';

sealed class TripsState extends Equatable {
  const TripsState();

  @override
  List<Object?> get props => [];
}

final class TripsLoading extends TripsState {
  const TripsLoading();
}

final class TripsError extends TripsState {
  const TripsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class TripsLoaded extends TripsState {
  const TripsLoaded(
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
  List<Object?> get props => [page, isLoadingMore, nextPageError];
}

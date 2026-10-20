part of 'trips_bloc.dart';

enum TripMark {
  added(AppColors.newRow),
  updated(AppColors.updatedRow);

  const TripMark(this.color);

  final Color color;
}

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
    this.marks = const {},
    this.isLoadingMore = false,
    this.nextPageError,
  });

  final TripPage page;


  final Map<String, TripMark> marks;
  final bool isLoadingMore;
  final String? nextPageError;
  bool get canLoadMore =>
      page.hasNextPage && !isLoadingMore && nextPageError == null;

  TripsLoaded withRow(TripPage page, String tripId, TripMark mark) =>
      TripsLoaded(
        filter,
        page,
        marks: {...marks, tripId: mark},
        isLoadingMore: isLoadingMore,
        nextPageError: nextPageError,
      );

  @override
  List<Object?> get props => [
    filter,
    page,
    marks,
    isLoadingMore,
    nextPageError,
  ];
}

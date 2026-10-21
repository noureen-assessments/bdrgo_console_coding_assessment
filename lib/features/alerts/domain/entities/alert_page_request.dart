import 'package:equatable/equatable.dart';

class AlertPageRequest extends Equatable {
  const AlertPageRequest({required this.page, required this.pageSize,});

  final int page;
  final int pageSize;

  @override
  List<Object?> get props => [page, pageSize];
}

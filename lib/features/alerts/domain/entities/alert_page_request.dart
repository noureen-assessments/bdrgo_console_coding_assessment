import 'package:equatable/equatable.dart';

class AlertPageRequest extends Equatable {
  const AlertPageRequest({required this.page, required this.pageSize, this.acknowledged,});

  final int page;
  final int pageSize;
  final bool? acknowledged;

  @override
  List<Object?> get props => [page, pageSize, acknowledged];
}

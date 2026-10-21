import 'package:equatable/equatable.dart';

class AlertPageRequest extends Equatable {
  const AlertPageRequest({required this.page, this.acknowledged});

  final int page;
  final bool? acknowledged;

  @override
  List<Object?> get props => [page, acknowledged];
}

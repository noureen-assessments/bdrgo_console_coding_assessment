import 'package:equatable/equatable.dart';

class Money extends Equatable {
  const Money({required this.amount, required this.currency});

  final double amount;
  final String currency;

  @override
  List<Object?> get props => [amount, currency];
}

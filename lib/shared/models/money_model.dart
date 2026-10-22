import '../entities/money.dart';


class MoneyModel extends Money {
  const MoneyModel({required super.amount, required super.currency});

  factory MoneyModel.fromJson(Map<String, dynamic> json) => MoneyModel(
    amount: (json['amount'] as num).toDouble(),
    currency: json['currency'] as String,
  );

  static List<MoneyModel> listFromJson(List<dynamic> json) {
    final amounts = <MoneyModel>[];
    for (final item in json) {
      amounts.add(MoneyModel.fromJson(item as Map<String, dynamic>));
    }
    return amounts;
  }

  Map<String, dynamic> toJson() => {'amount': amount, 'currency': currency};
}

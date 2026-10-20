import 'package:intl/intl.dart';

abstract final class NumberFormatters {
  static final _count = NumberFormat.decimalPattern();
  static final _decimal = NumberFormat('0.##');
  static final _percent = NumberFormat.percentPattern()
    ..maximumFractionDigits = 1;

  static String count(int value) => _count.format(value);

  static String percent(double ratio) => _percent.format(ratio);

  static String decimal(double value) => _decimal.format(value);

  static String currency(double amount, String currencyCode) =>
      NumberFormat.currency(
        name: currencyCode,
        symbol: '$currencyCode ',
      ).format(amount);
}

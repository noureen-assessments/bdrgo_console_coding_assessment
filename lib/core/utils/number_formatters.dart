import 'package:intl/intl.dart';

abstract final class NumberFormatters {
  static final _count = NumberFormat.decimalPattern();
  static final _percent = NumberFormat.percentPattern()
    ..maximumFractionDigits = 1;

  /// `19615` → `19,615`.
  static String count(int value) => _count.format(value);

  /// A 0–1 ratio: `0.11` → `11%`, `0.115` → `11.5%`.
  static String percent(double ratio) => _percent.format(ratio);

  /// `QAR 496,626.47`. The number of decimals follows the currency code
  /// (2 for QAR, 3 for KWD, 0 for JPY).
  static String currency(double amount, String currencyCode) =>
      NumberFormat.currency(
        name: currencyCode,
        symbol: '$currencyCode ',
      ).format(amount);
}

import 'package:intl/intl.dart';

abstract final class DateFormatters {
  static final _time = DateFormat.Hms();
  static final _hour = DateFormat.Hm();
  static final _day = DateFormat.MMMd();
  static final _dayTime = DateFormat.MMMd().add_Hm();

  static String time(DateTime value) => _time.format(value.toLocal());

  static String hour(DateTime value) => _hour.format(value.toLocal());

  static String day(DateTime value) => _day.format(value.toUtc());

  static String pickedDay(DateTime value) => _day.format(value);

  static String dayTime(DateTime value) => _dayTime.format(value.toLocal());
}

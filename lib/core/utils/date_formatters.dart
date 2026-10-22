import 'package:intl/intl.dart';

import '../constants/app_strings.dart';

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

  static String duration(Duration value) {
    final minutes = value.inMinutes;
    if (minutes < 1) return AppStrings.durationUnderMinute;
    if (minutes < 60) return AppStrings.durationMinutes(minutes);
    return AppStrings.durationHours(value.inHours, minutes % 60);
  }
}

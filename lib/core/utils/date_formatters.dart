import 'package:intl/intl.dart';

abstract final class DateFormatters {
  static final _time = DateFormat.Hms();
  static final _hour = DateFormat.Hm();
  static final _day = DateFormat.MMMd();
  static final _dayTime = DateFormat.MMMd().add_Hm();

  /// `14:05:09` in the browser's local time.
  static String time(DateTime value) => _time.format(value.toLocal());

  /// `14:00` in the browser's local time (hourly chart buckets).
  static String hour(DateTime value) => _hour.format(value.toLocal());

  /// `Oct 13`. Daily buckets start at 00:00 UTC, so the day is read in UTC;
  /// local time would shift it to the day before west of UTC.
  static String day(DateTime value) => _day.format(value.toUtc());

  /// `Oct 13` for a day the user picked; already local, so not converted.
  static String pickedDay(DateTime value) => _day.format(value);

  /// `Oct 13 14:05` in the browser's local time.
  static String dayTime(DateTime value) => _dayTime.format(value.toLocal());
}

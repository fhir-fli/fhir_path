abstract class Formats {
  static const n = "numeric", s = "short", l = "long";

  static const Map<String, dynamic> DATE_SHORT = {
    'year': n,
    'month': n,
    'day': n,
  };

  static const String DATE_SHORT_STRING = "M/d/yyyy";

  static const Map<String, dynamic> DATE_MED = {
    'year': n,
    'month': s,
    'day': n,
  };

  static const String DATE_MED_STRING = "LLL d, yyyy";

  static const Map<String, dynamic> DATE_MED_WITH_WEEKDAY = {
    'year': n,
    'month': s,
    'day': n,
    'weekday': s,
  };

  static const String DATE_MED_WITH_WEEKDAY_STRING = "EEE, LLL d, yyyy";

  static const Map<String, dynamic> DATE_FULL = {
    'year': n,
    'month': l,
    'day': n,
  };

  static const String DATE_FULL_STRING = "LLLL d, yyyy";

  static const Map<String, dynamic> DATE_HUGE = {
    'year': n,
    'month': l,
    'day': n,
    'weekday': l,
  };

  static const String DATE_HUGE_STRING = "EEEE, LLLL d, yyyy";

  static const Map<String, dynamic> TIME_SIMPLE = {
    'hour': n,
    'minute': n,
  };

  static const String TIME_SIMPLE_STRING = "h:mm a";

  static const Map<String, dynamic> TIME_WITH_SECONDS = {
    'hour': n,
    'minute': n,
    'second': n,
  };

  static const String TIME_WITH_SECONDS_STRING = "h:mm:ss a";

  static const Map<String, dynamic> TIME_WITH_SHORT_OFFSET = {
    'hour': n,
    'minute': n,
    'second': n,
    'timeZoneName': s,
  };

  static const String TIME_WITH_SHORT_OFFSET_STRING = "h:mm a";

  static const Map<String, dynamic> TIME_WITH_LONG_OFFSET = {
    'hour': n,
    'minute': n,
    'second': n,
    'timeZoneName': l,
  };

  static const String TIME_WITH_LONG_OFFSET_STRING = "h:mm a";

  static const Map<String, dynamic> TIME_24_SIMPLE = {
    'hour': n,
    'minute': n,
    'hourCycle': "h23",
  };

  static const String TIME_24_SIMPLE_STRING = "HH:mm";

  static const Map<String, dynamic> TIME_24_WITH_SECONDS = {
    'hour': n,
    'minute': n,
    'second': n,
    'hourCycle': "h23",
  };

  static const String TIME_24_WITH_SECONDS_STRING = "HH:mm:ss";

  static const Map<String, dynamic> TIME_24_WITH_SHORT_OFFSET = {
    'hour': n,
    'minute': n,
    'second': n,
    'hourCycle': "h23",
    'timeZoneName': s,
  };

  static const String TIME_24_WITH_SHORT_OFFSET_STRING = "HH:mm";

  static const Map<String, dynamic> TIME_24_WITH_LONG_OFFSET = {
    'hour': n,
    'minute': n,
    'second': n,
    'hourCycle': "h23",
    'timeZoneName': l,
  };

  static const String TIME_24_WITH_LONG_OFFSET_STRING = "HH:mm";

  static const Map<String, dynamic> DATETIME_SHORT = {
    'year': n,
    'month': n,
    'day': n,
    'hour': n,
    'minute': n,
  };

  static const String DATETIME_SHORT_STRING = "M/d/yyyy, h:mm a";

  static const Map<String, dynamic> DATETIME_SHORT_WITH_SECONDS = {
    'year': n,
    'month': n,
    'day': n,
    'hour': n,
    'minute': n,
    'second': n,
  };

  static const String DATETIME_SHORT_WITH_SECONDS_STRING =
      "M/d/yyyy, h:mm:ss a";

  static const Map<String, dynamic> DATETIME_MED = {
    'year': n,
    'month': s,
    'day': n,
    'hour': n,
    'minute': n,
  };

  static const String DATETIME_MED_STRING = "LLL d, yyyy, h:mm a";

  static const Map<String, dynamic> DATETIME_MED_WITH_SECONDS = {
    'year': n,
    'month': s,
    'day': n,
    'hour': n,
    'minute': n,
    'second': n,
  };

  static const String DATETIME_MED_WITH_SECONDS_STRING =
      "LLL d, yyyy, h:mm:ss a";

  static const Map<String, dynamic> DATETIME_MED_WITH_WEEKDAY = {
    'year': n,
    'month': s,
    'day': n,
    'weekday': s,
    'hour': n,
    'minute': n,
  };

  static const String DATETIME_MED_WITH_WEEKDAY_STRING =
      "EEE, d LLL yyyy, h:mm a";

  static const Map<String, dynamic> DATETIME_FULL = {
    'year': n,
    'month': l,
    'day': n,
    'hour': n,
    'minute': n,
    'timeZoneName': s,
  };

  static const String DATETIME_FULL_STRING = "LLLL d, yyyy, h:mm a";

  static const Map<String, dynamic> DATETIME_FULL_WITH_SECONDS = {
    'year': n,
    'month': l,
    'day': n,
    'hour': n,
    'minute': n,
    'second': n,
    'timeZoneName': s,
  };

  static const String DATETIME_FULL_WITH_SECONDS_STRING =
      "LLLL d, yyyy, h:mm:ss a";

  static const Map<String, dynamic> DATETIME_HUGE = {
    'year': n,
    'month': l,
    'day': n,
    'weekday': l,
    'hour': n,
    'minute': n,
    'timeZoneName': l,
  };

  static const String DATETIME_HUGE_STRING = "EEEE, LLLL d, yyyy, h:mm a";

  static const Map<String, dynamic> DATETIME_HUGE_WITH_SECONDS = {
    'year': n,
    'month': l,
    'day': n,
    'weekday': l,
    'hour': n,
    'minute': n,
    'second': n,
    'timeZoneName': l,
  };

  static const String DATETIME_HUGE_WITH_SECONDS_STRING =
      "EEEE, LLLL d, yyyy, h:mm:ss a";
}

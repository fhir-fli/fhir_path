import 'dart:convert';

import '../luxon.dart';

String stringify(Map<String, dynamic> obj) {
  var sortedKeys = obj.keys.toList()..sort();
  return jsonEncode(
      Map.fromIterable(sortedKeys, key: (k) => k, value: (k) => obj[k]));
}

final List<String> monthsLong = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];

final List<String> monthsShort = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];

final List<String> monthsNarrow = [
  "J",
  "F",
  "M",
  "A",
  "M",
  "J",
  "J",
  "A",
  "S",
  "O",
  "N",
  "D"
];

List<String>? months(String length) {
  switch (length) {
    case "narrow":
      return List.from(monthsNarrow);
    case "short":
      return List.from(monthsShort);
    case "long":
      return List.from(monthsLong);
    case "numeric":
      return List.generate(12, (index) => (index + 1).toString());
    case "2-digit":
      return List.generate(12, (index) {
        final month = index + 1;
        return month < 10 ? '0$month' : month.toString();
      });
    default:
      return null;
  }
}

final List<String> weekdaysLong = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
];

final List<String> weekdaysShort = [
  "Mon",
  "Tue",
  "Wed",
  "Thu",
  "Fri",
  "Sat",
  "Sun"
];

final List<String> weekdaysNarrow = ["M", "T", "W", "T", "F", "S", "S"];

List<String>? weekdays(String length) {
  switch (length) {
    case "narrow":
      return List.from(weekdaysNarrow);
    case "short":
      return List.from(weekdaysShort);
    case "long":
      return List.from(weekdaysLong);
    case "numeric":
      return List.generate(7, (index) => (index + 1).toString());
    default:
      return null;
  }
}

final List<String> meridiems = ["AM", "PM"];

final List<String> erasLong = ["Before Christ", "Anno Domini"];

final List<String> erasShort = ["BC", "AD"];

final List<String> erasNarrow = ["B", "A"];

List<String>? eras(String length) {
  switch (length) {
    case "narrow":
      return List.from(erasNarrow);
    case "short":
      return List.from(erasShort);
    case "long":
      return List.from(erasLong);
    default:
      return null;
  }
}

String meridiemForDateTime(LuxonDateTime dt) {
  return meridiems[dt.hour < 12 ? 0 : 1];
}

String? weekdayForDateTime(LuxonDateTime dt, String length) {
  return weekdays(length)?[dt.weekday - 1];
}

String? monthForDateTime(LuxonDateTime dt, String length) {
  return months(length)?[dt.month - 1];
}

String? eraForDateTime(LuxonDateTime dt, String length) {
  return eras(length)?[dt.year < 0 ? 0 : 1];
}

String formatRelativeTime(String unit, int count,
    {String numeric = "always", bool narrow = false}) {
  final units = {
    'years': ["year", "yr."],
    'quarters': ["quarter", "qtr."],
    'months': ["month", "mo."],
    'weeks': ["week", "wk."],
    'days': ["day", "day", "days"],
    'hours': ["hour", "hr."],
    'minutes': ["minute", "min."],
    'seconds': ["second", "sec."]
  };

  final lastable = ["hours", "minutes", "seconds"].indexOf(unit) == -1;

  if (numeric == "auto" && lastable) {
    final isDay = unit == "days";
    switch (count) {
      case 1:
        return isDay ? "tomorrow" : "next ${units[unit]?[0]}";
      case -1:
        return isDay ? "yesterday" : "last ${units[unit]?[0]}";
      case 0:
        return isDay ? "today" : "this ${units[unit]?[0]}";
      default: // fall through
    }
  }

  final isInPast = count.isNegative || count == 0;
  final fmtValue = count.abs();
  final singular = fmtValue == 1;
  final lilUnits = units[unit]!;
  final fmtUnit = narrow
      ? singular
          ? lilUnits[1]
          : lilUnits[2]
      : singular
          ? units[unit]![0]
          : unit;
  return isInPast ? "${fmtValue} ${fmtUnit} ago" : "in ${fmtValue} ${fmtUnit}";
}

String formatString(Map<String, dynamic> knownFormat) {
  final filtered = pick(knownFormat, [
    "weekday",
    "era",
    "year",
    "month",
    "day",
    "hour",
    "minute",
    "second",
    "timeZoneName",
    "hourCycle"
  ]);
  final key = filtered;
  final dateTimeHuge = "EEEE, LLLL d, yyyy, h:mm a";
  switch (key) {
    case Formats.DATE_SHORT:
      return Formats.DATE_SHORT_STRING;

    case Formats.DATE_MED:
      return Formats.DATE_MED_STRING;

    case Formats.DATE_MED_WITH_WEEKDAY:
      return Formats.DATE_MED_WITH_WEEKDAY_STRING;

    case Formats.DATE_FULL:
      return Formats.DATE_FULL_STRING;

    case Formats.DATE_HUGE:
      return Formats.DATE_HUGE_STRING;

    case Formats.TIME_SIMPLE:
      return Formats.TIME_SIMPLE_STRING;

    case Formats.TIME_WITH_SECONDS:
      return Formats.TIME_WITH_SECONDS_STRING;

    case Formats.TIME_WITH_SHORT_OFFSET:
      return Formats.TIME_WITH_SHORT_OFFSET_STRING;

    case Formats.TIME_WITH_LONG_OFFSET:
      return Formats.TIME_WITH_LONG_OFFSET_STRING;

    case Formats.TIME_24_SIMPLE:
      return Formats.TIME_24_SIMPLE_STRING;

    case Formats.TIME_24_WITH_SECONDS:
      return Formats.TIME_24_WITH_SECONDS_STRING;

    case Formats.TIME_24_WITH_SHORT_OFFSET:
      return Formats.TIME_24_WITH_SHORT_OFFSET_STRING;

    case Formats.TIME_24_WITH_LONG_OFFSET:
      return Formats.TIME_24_WITH_LONG_OFFSET_STRING;

    case Formats.DATETIME_SHORT:
      return Formats.DATETIME_SHORT_STRING;

    case Formats.DATETIME_MED:
      return Formats.DATETIME_MED_STRING;

    case Formats.DATETIME_FULL:
      return Formats.DATETIME_FULL_STRING;

    case Formats.DATETIME_HUGE:
      return Formats.DATETIME_HUGE_STRING;

    case Formats.DATETIME_SHORT_WITH_SECONDS:
      return Formats.DATETIME_SHORT_WITH_SECONDS_STRING;

    case Formats.DATETIME_MED_WITH_SECONDS:
      return Formats.DATETIME_MED_WITH_SECONDS_STRING;

    case Formats.DATETIME_MED_WITH_WEEKDAY:
      return Formats.DATETIME_MED_WITH_WEEKDAY_STRING;

    case Formats.DATETIME_FULL_WITH_SECONDS:
      return Formats.DATETIME_FULL_WITH_SECONDS_STRING;

    case Formats.DATETIME_HUGE_WITH_SECONDS:
      return Formats.DATETIME_HUGE_WITH_SECONDS_STRING;

    default:
      return dateTimeHuge;
  }
}

import 'dart:math' as math;

import '../luxon.dart';

bool isUndefined(dynamic o) {
  return o == null;
}

bool isNumber(dynamic o) {
  return o is num;
}

bool isInteger(dynamic o) {
  return o is int && o % 1 == 0;
}

bool isString(dynamic o) {
  return o is String;
}

bool isDate(dynamic o) {
  return o is LuxonDateTime;
}

bool hasRelative() {
  try {
    return LuxonDateTime.now().isBefore(
        LuxonDateTime.now().add(const LuxonDuration(values: {'days': 1})));
  } catch (e) {
    return false;
  }
}

bool hasLuxonLocaleWeekInfo() {
  try {
    // Add your logic for checking locale week info here
    return true; // Placeholder return; replace with actual logic
  } catch (e) {
    return false;
  }
}

List<dynamic> maybeArray(dynamic thing) {
  return thing is List ? thing : [thing];
}

dynamic bestBy(List<dynamic> arr, Function by, Function compare) {
  if (arr.isEmpty) {
    return null;
  }
  return arr.reduce((best, next) {
    final pair = [by(next), next];
    if (best == null) {
      return pair;
    } else if (compare(best[0], pair[0]) == best[0]) {
      return best;
    } else {
      return pair;
    }
  })[1];
}

Map<String, dynamic> pick(Map<String, dynamic> obj, List<String> keys) {
  return keys.fold({}, (a, k) {
    if (obj.containsKey(k)) {
      a[k] = obj[k];
    }
    return a;
  });
}

bool hasOwnProperty(Map<dynamic, dynamic> obj, dynamic prop) {
  return obj.containsKey(prop);
}

Map<String, dynamic>? validateWeekSettings(Map<String, dynamic>? settings) {
  if (settings == null) {
    return null;
  } else {
    // Add your validation logic here for week settings
    return {
      'firstDay': settings['firstDay'],
      'minimalDays': settings['minimalDays'],
      'weekend': List.from(settings['weekend']),
    };
  }
}

bool integerBetween(dynamic thing, int bottom, int top) {
  return thing is int && thing >= bottom && thing <= top;
}

int floorMod(int x, int n) {
  return x - n * (x ~/ n);
}

String padStart(int input, [int n = 2]) {
  final isNeg = input < 0;
  final padded = isNeg
      ? '-${input.abs().toString().padLeft(n, '0')}'
      : input.toString().padLeft(n, '0');
  return padded;
}

int? parseInteger(String? string) {
  return string == null || string.isEmpty ? null : int.tryParse(string);
}

double? parseFloating(String? string) {
  return string == null || string.isEmpty ? null : double.tryParse(string);
}

int? parseMillis(String? fraction) {
  if (fraction == null || fraction.isEmpty) {
    return null;
  } else {
    final f = double.parse('0.$fraction') * 1000;
    return f.floor();
  }
}

double roundTo(double number, int digits, [bool towardZero = false]) {
  double factor = math.pow(10, digits).toDouble();
  double Function(double) rounder = towardZero
      ? (num) => num.truncateToDouble()
      : (num) => num.roundToDouble();
  return rounder(number * factor) / factor;
}

bool isLeapYear(int year) {
  return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
}

int daysInYear(int year) {
  return isLeapYear(year) ? 366 : 365;
}

int daysInMonth(int year, int month) {
  final modMonth = floorMod(month - 1, 12) + 1;
  final modYear = year + (month - modMonth) / 12;

  if (modMonth == 2) {
    return isLeapYear(modYear.toInt()) ? 29 : 28;
  } else {
    return [31, null, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][modMonth - 1]!;
  }
}

int objToLocalTS(Map<String, int> obj) {
  final d = LuxonDateTime.utc(
    obj['year']!,
    obj['month']! - 1,
    obj['day']!,
    obj['hour']!,
    obj['minute']!,
    obj['second']!,
    obj['millisecond']!,
  );

  if (obj['year']! < 100 && obj['year']! >= 0) {
    return LuxonDateTime(
            d.year, d.month, d.day, d.hour, d.minute, d.second, d.millisecond)
        .millisecondsSinceEpoch;
  }
  return d.millisecondsSinceEpoch;
}

int firstWeekOffset(int year, int minDaysInFirstWeek, int startOfWeek) {
  int fwdlw =
      isoWeekdayToLocal(dayOfWeek(year, 1, minDaysInFirstWeek), startOfWeek);
  return -fwdlw + minDaysInFirstWeek - 1;
}

int weeksInWeekYear(int weekYear,
    [int minDaysInFirstWeek = 4, int startOfWeek = 1]) {
  int weekOffset = firstWeekOffset(weekYear, minDaysInFirstWeek, startOfWeek);
  int weekOffsetNext =
      firstWeekOffset(weekYear + 1, minDaysInFirstWeek, startOfWeek);
  // TODO(Dokotela): Check if I can round this off
  return (daysInYear(weekYear) - weekOffset + weekOffsetNext) ~/ 7;
}

int untruncateYear(int year) {
  if (year > 99) {
    return year;
  } else {
    return year > Settings.twoDigitCutoffYear ? 1900 + year : 2000 + year;
  }
}

String? parseZoneInfo(int ts, String offsetFormat, String locale,
    [String? timeZone]) {
  LuxonDateTime date =
      LuxonDateTime.fromMillisecondsSinceEpoch(ts, isUtc: true);
  Map<String, String> intlOpts = {
    'hourCycle': 'h23',
    'year': 'numeric',
    'month': '2-digit',
    'day': '2-digit',
    'hour': '2-digit',
    'minute': '2-digit',
  };

  if (timeZone != null) {
    intlOpts['timeZone'] = timeZone;
  }

  Map<String, dynamic> modified = {'timeZoneName': offsetFormat, ...intlOpts};

  String? parsed = LuxonDateTime.now()
      .add(LuxonDuration(milliseconds: ts))
      .toLocal()
      .toString();
  return parsed;
}

int signedOffset(String offHourStr, String offMinuteStr) {
  int offHour = int.tryParse(offHourStr) ?? 0;

  int offMin = int.tryParse(offMinuteStr) ?? 0;
  int offMinSigned = offHour < 0 || offHour.isNegative ? -offMin : offMin;
  return offHour * 60 + offMinSigned;
}

double asNumber(dynamic value) {
  double numericValue = value is num ? value.toDouble() : double.nan;
  if (value is bool || value == "" || numericValue.isNaN) {
    throw ArgumentError('Invalid unit value $value');
  }
  return numericValue;
}

Map<String, dynamic> normalizeObject(
    Map<String, dynamic> obj, String Function(String) normalizer) {
  Map<String, dynamic> normalized = {};
  obj.forEach((u, v) {
    if (v != null) {
      normalized[normalizer(u)] = asNumber(v);
    }
  });
  return normalized;
}

String formatOffset(int offset, String format) {
  int hours = (offset / 60).truncate();
  int minutes = (offset % 60).truncate();
  String sign = offset >= 0 ? "+" : "-";

  switch (format) {
    case "short":
      return '$sign${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    case "narrow":
      return '$sign$hours${minutes > 0 ? ':$minutes' : ""}';
    case "techie":
      return '$sign${hours.toString().padLeft(2, '0')}${minutes.toString().padLeft(2, '0')}';
    default:
      throw RangeError(
          'Value format $format is out of range for property format');
  }
}

Map<String, dynamic> timeObject(Map<String, dynamic> obj) {
  return pick(obj, ["hour", "minute", "second", "millisecond"]);
}

// Function dayOfWeek, isoWeekdayToLocal, daysInYear, padStart, pick needs to be defined separately according to their implementation in JavaScript


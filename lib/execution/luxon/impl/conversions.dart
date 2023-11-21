import '../luxon.dart';

final nonLeapLadder = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
final leapLadder = [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335];

Invalid unitOutOfRange(String unit, value) {
  return Invalid(
    "unit out of range",
    "you specified $value (of type ${value.runtimeType}) as a $unit, which is invalid",
  );
}

int dayOfWeek(int year, int month, int day) {
  // TODO(Dokotela): Should this be a Luxon DateTime or a Dart DateTime?
  DateTime d = DateTime(year, month, day);

  if (year < 100 && year >= 0) {
    d = DateTime.utc(1900, month, day);
  }

  int js = d.weekday;

  return js == 7 ? 1 : js + 1;
}

int computeOrdinal(int year, int month, int day) {
  List<int> table = isLeapYear(year) ? leapLadder : nonLeapLadder;
  return day + table[month - 1];
}

Map<String, int> uncomputeOrdinal(int year, int ordinal) {
  List<int> table = isLeapYear(year) ? leapLadder : nonLeapLadder;
  int month0 = table.indexWhere((i) => i < ordinal);
  int day = ordinal - table[month0];
  return {'month': month0 + 1, 'day': day};
}

int isoWeekdayToLocal(int isoWeekday, int startOfWeek) {
  return ((isoWeekday - startOfWeek + 7) % 7) + 1;
}

Map<String, dynamic> gregorianToWeek(Map<String, dynamic> gregObj,
    [int minDaysInFirstWeek = 4, int startOfWeek = 1]) {
  int year = gregObj['year'];
  int month = gregObj['month'];
  int day = gregObj['day'];

  int ordinal = computeOrdinal(year, month, day);
  int weekday = isoWeekdayToLocal(dayOfWeek(year, month, day), startOfWeek);

  int weekNumber = ((ordinal - weekday + 14 - minDaysInFirstWeek) / 7).floor();
  int weekYear;

  if (weekNumber < 1) {
    weekYear = year - 1;
    weekNumber = weeksInWeekYear(weekYear, minDaysInFirstWeek, startOfWeek);
  } else if (weekNumber >
      weeksInWeekYear(year, minDaysInFirstWeek, startOfWeek)) {
    weekYear = year + 1;
    weekNumber = 1;
  } else {
    weekYear = year;
  }

  return {
    'weekYear': weekYear,
    'weekNumber': weekNumber,
    'weekday': weekday,
    ...timeObject(gregObj),
  };
}

Map<String, dynamic> weekToGregorian(Map<String, dynamic> weekData,
    [int minDaysInFirstWeek = 4, int startOfWeek = 1]) {
  int weekYear = weekData['weekYear'];
  int weekNumber = weekData['weekNumber'];
  int weekday = weekData['weekday'];

  int weekdayOfJan4 = isoWeekdayToLocal(
      dayOfWeek(weekYear, 1, minDaysInFirstWeek), startOfWeek);
  int yearInDays = daysInYear(weekYear);

  int ordinal =
      weekNumber * 7 + weekday - weekdayOfJan4 - 7 + minDaysInFirstWeek;
  int year;

  if (ordinal < 1) {
    year = weekYear - 1;
    ordinal += daysInYear(year);
  } else if (ordinal > yearInDays) {
    year = weekYear + 1;
    ordinal -= daysInYear(weekYear);
  } else {
    year = weekYear;
  }

  Map<String, dynamic> uncomputed = uncomputeOrdinal(year, ordinal);
  return {
    'year': year,
    'month': uncomputed['month'],
    'day': uncomputed['day'],
    ...timeObject(weekData)
  };
}

Map<String, dynamic> gregorianToOrdinal(Map<String, dynamic> gregData) {
  int year = gregData['year'];
  int month = gregData['month'];
  int day = gregData['day'];

  int ordinal = computeOrdinal(year, month, day);
  return {'year': year, 'ordinal': ordinal, ...timeObject(gregData)};
}

Map<String, dynamic> ordinalToGregorian(Map<String, dynamic> ordinalData) {
  int year = ordinalData['year'];
  int ordinal = ordinalData['ordinal'];

  Map<String, dynamic> uncomputed = uncomputeOrdinal(year, ordinal);
  return {
    'year': year,
    'month': uncomputed['month'],
    'day': uncomputed['day'],
    ...timeObject(ordinalData)
  };
}

Map<String, int> usesLocalWeekValues(
    Map<String, dynamic> obj, LuxonLocale loc) {
  bool hasLuxonLocaleWeekData = obj.containsKey('localWeekday') ||
      obj.containsKey('localWeekNumber') ||
      obj.containsKey('localWeekYear');

  if (hasLuxonLocaleWeekData) {
    bool hasIsoWeekData = obj.containsKey('weekday') ||
        obj.containsKey('weekNumber') ||
        obj.containsKey('weekYear');

    if (hasIsoWeekData) {
      throw ConflictingSpecificationError(
          "Cannot mix locale-based week fields with ISO-based week fields");
    }

    if (obj.containsKey('localWeekday')) obj['weekday'] = obj['localWeekday'];
    if (obj.containsKey('localWeekNumber'))
      obj['weekNumber'] = obj['localWeekNumber'];
    if (obj.containsKey('localWeekYear'))
      obj['weekYear'] = obj['localWeekYear'];

    obj.remove('localWeekday');
    obj.remove('localWeekNumber');
    obj.remove('localWeekYear');

    return {
      'minDaysInFirstWeek': loc.getMinDaysInFirstWeek(),
      'startOfWeek': loc.getStartOfWeek(),
    };
  } else {
    return {'minDaysInFirstWeek': 4, 'startOfWeek': 1};
  }
}

dynamic hasInvalidWeekData(Map<String, dynamic> obj,
    [int minDaysInFirstWeek = 4, int startOfWeek = 1]) {
  bool validYear = isInteger(obj['weekYear']);
  bool validWeek = integerBetween(obj['weekNumber'], 1,
      weeksInWeekYear(obj['weekYear'], minDaysInFirstWeek, startOfWeek));
  bool validWeekday = integerBetween(obj['weekday'], 1, 7);

  if (!validYear) {
    return unitOutOfRange("weekYear", obj['weekYear']);
  } else if (!validWeek) {
    return unitOutOfRange("week", obj['weekNumber']);
  } else if (!validWeekday) {
    return unitOutOfRange("weekday", obj['weekday']);
  } else {
    return false;
  }
}

dynamic hasInvalidOrdinalData(Map<String, dynamic> obj) {
  bool validYear = isInteger(obj['year']);
  bool validOrdinal =
      integerBetween(obj['ordinal'], 1, daysInYear(obj['year']));

  if (!validYear) {
    return unitOutOfRange("year", obj['year']);
  } else if (!validOrdinal) {
    return unitOutOfRange("ordinal", obj['ordinal']);
  } else {
    return false;
  }
}

dynamic hasInvalidGregorianData(Map<String, dynamic> obj) {
  bool validYear = isInteger(obj['year']);
  bool validMonth = integerBetween(obj['month'], 1, 12);
  bool validDay =
      integerBetween(obj['day'], 1, daysInMonth(obj['year'], obj['month']));

  if (!validYear) {
    return unitOutOfRange("year", obj['year']);
  } else if (!validMonth) {
    return unitOutOfRange("month", obj['month']);
  } else if (!validDay) {
    return unitOutOfRange("day", obj['day']);
  } else {
    return false;
  }
}

dynamic hasInvalidTimeData(Map<String, dynamic> obj) {
  int hour = obj['hour'];
  int minute = obj['minute'];
  int second = obj['second'];
  int millisecond = obj['millisecond'];

  bool validHour = integerBetween(hour, 0, 23) ||
      (hour == 24 && minute == 0 && second == 0 && millisecond == 0);
  bool validMinute = integerBetween(minute, 0, 59);
  bool validSecond = integerBetween(second, 0, 59);
  bool validMillisecond = integerBetween(millisecond, 0, 999);

  if (!validHour) {
    return unitOutOfRange("hour", hour);
  } else if (!validMinute) {
    return unitOutOfRange("minute", minute);
  } else if (!validSecond) {
    return unitOutOfRange("second", second);
  } else if (!validMillisecond) {
    return unitOutOfRange("millisecond", millisecond);
  } else {
    return false;
  }
}

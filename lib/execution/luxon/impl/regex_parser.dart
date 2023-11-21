final RegExp isoTimeOnly = RegExp('^T?${isoTimeBaseRegex.source}\$');

final RegExp isoDuration = RegExp(
    r'^-?P(?:(-?\d{1,20}(?:\.\d{1,20})?)Y)?(?:(-?\d{1,20}(?:\.\d{1,20})?)M)?(?:(-?\d{1,20}(?:\.\d{1,20})?)W)?(?:(-?\d{1,20}(?:\.\d{1,20})?)D)?(?:T(?:(-?\d{1,20}(?:\.\d{1,20})?)H)?(?:(-?\d{1,20}(?:\.\d{1,20})?)M)?(?:(-?\d{1,20})(?:[.,](-?\d{1,20}))?S)?)?\$');

List<dynamic> extractISODuration(List<String> match) {
  var s = match[0];
  var yearStr = match[1];
  var monthStr = match[2];
  var weekStr = match[3];
  var dayStr = match[4];
  var hourStr = match[5];
  var minuteStr = match[6];
  var secondStr = match[7];
  var millisecondsStr = match[8];

  var hasNegativePrefix = s[0] == '-';
  var negativeSeconds = secondStr[0] == '-';

  dynamic maybeNegate(num, {bool force = false}) =>
      num != null && (force || (num != null && hasNegativePrefix)) ? -num : num;

  return [
    {
      'years': maybeNegate(parseFloating(yearStr)),
      'months': maybeNegate(parseFloating(monthStr)),
      'weeks': maybeNegate(parseFloating(weekStr)),
      'days': maybeNegate(parseFloating(dayStr)),
      'hours': maybeNegate(parseFloating(hourStr)),
      'minutes': maybeNegate(parseFloating(minuteStr)),
      'seconds':
          maybeNegate(parseFloating(secondStr), force: secondStr == '-0'),
      'milliseconds':
          maybeNegate(parseMillis(millisecondsStr), force: negativeSeconds),
    },
  ];
}

final Map<String, int> obsOffsets = {
  'GMT': 0,
  'EDT': -4 * 60,
  'EST': -5 * 60,
  'CDT': -5 * 60,
  'CST': -6 * 60,
  'MDT': -6 * 60,
  'MST': -7 * 60,
  'PDT': -7 * 60,
  'PST': -8 * 60,
};

Map<String, dynamic> fromStrings(
    String weekdayStr,
    String yearStr,
    String monthStr,
    String dayStr,
    String hourStr,
    String minuteStr,
    String secondStr) {
  var result = {
    'year': yearStr.length == 2
        ? untruncateYear(parseInteger(yearStr))
        : parseInteger(yearStr),
    'month': English.monthsShort.indexOf(monthStr) + 1,
    'day': parseInteger(dayStr),
    'hour': parseInteger(hourStr),
    'minute': parseInteger(minuteStr),
  };

  result['second'] = parseInteger(secondStr);
  result['weekday'] = weekdayStr.length > 3
      ? English.weekdaysLong.indexOf(weekdayStr) + 1
      : English.weekdaysShort.indexOf(weekdayStr) + 1;

  return result;
}

final RegExp rfc2822 = RegExp(
    r'^(?:(Mon|Tue|Wed|Thu|Fri|Sat|Sun),\s)?(\d{1,2})\s(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s(\d{2,4})\s(\d\d):(\d\d)(?::(\d\d))?\s(?:(UT|GMT|[ECMP][SD]T)|([Zz])|(?:([+-]\d\d)(\d\d)))\$');

List<dynamic> extractRFC2822(List<String> match) {
  var weekdayStr = match[1];
  var dayStr = match[2];
  var monthStr = match[3];
  var yearStr = match[4];
  var hourStr = match[5];
  var minuteStr = match[6];
  var secondStr = match[7];
  var obsOffset = match[8];
  var milOffset = match[9];
  var offHourStr = match[10];
  var offMinuteStr = match[11];

  var result = fromStrings(
      weekdayStr, yearStr, monthStr, dayStr, hourStr, minuteStr, secondStr);

  var offset;
  if (obsOffset != null) {
    offset = obsOffsets[obsOffset];
  } else if (milOffset != null) {
    offset = 0;
  } else {
    offset = signedOffset(offHourStr, offMinuteStr);
  }

  return [result, FixedOffsetZone(offset)];
}

String preprocessRFC2822(String s) {
  return s
      .replaceAll(RegExp(r'\([^()]*\)|[\n\t]'), ' ')
      .replaceAll(RegExp(r'(\s\s+)'), ' ')
      .trim();
}

final RegExp rfc1123 = RegExp(
    r'^(Mon|Tue|Wed|Thu|Fri|Sat|Sun), (\d\d) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) (\d{4}) (\d\d):(\d\d):(\d\d) GMT\$');
final RegExp rfc850 = RegExp(
    r'^(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday), (\d\d)-(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)-(\d\d) (\d\d):(\d\d):(\d\d) GMT\$');
final RegExp ascii = RegExp(
    r'^(Mon|Tue|Wed|Thu|Fri|Sat|Sun) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) ( \d|\d\d) (\d\d):(\d\d):(\d\d) (\d{4})\$');

List<dynamic> extractRFC1123Or850(List<String> match) {
  var weekdayStr = match[1];
  var dayStr = match[2];
  var monthStr = match[3];
  var yearStr = match[4];
  var hourStr = match[5];
  var minuteStr = match[6];
  var secondStr = match[7];

  var result = fromStrings(
      weekdayStr, yearStr, monthStr, dayStr, hourStr, minuteStr, secondStr);
  return [result, FixedOffsetZone.utcInstance];
}

List<dynamic> extractASCII(List<String> match) {
  var weekdayStr = match[1];
  var monthStr = match[2];
  var dayStr = match[3];
  var hourStr = match[4];
  var minuteStr = match[5];
  var secondStr = match[6];
  var yearStr = match[7];

  var result = fromStrings(
      weekdayStr, yearStr, monthStr, dayStr, hourStr, minuteStr, secondStr);
  return [result, FixedOffsetZone.utcInstance];
}

final RegExp isoYmdWithTimeExtensionRegex =
    combineRegexes([isoYmdRegex, isoTimeExtensionRegex]);
final RegExp isoWeekWithTimeExtensionRegex =
    combineRegexes([isoWeekRegex, isoTimeExtensionRegex]);
final RegExp isoOrdinalWithTimeExtensionRegex =
    combineRegexes([isoOrdinalRegex, isoTimeExtensionRegex]);
final RegExp isoTimeCombinedRegex = combineRegexes([isoTimeRegex]);

final extractISOYmdTimeAndOffset = combineExtractors(
    [extractISOYmd, extractISOTime, extractISOOffset, extractIANAZone]);
final extractISOWeekTimeAndOffset = combineExtractors(
    [extractISOWeekData, extractISOTime, extractISOOffset, extractIANAZone]);
final extractISOOrdinalDateAndTime = combineExtractors(
    [extractISOOrdinalData, extractISOTime, extractISOOffset, extractIANAZone]);
final extractISOTimeAndOffset =
    combineExtractors([extractISOTime, extractISOOffset, extractIANAZone]);

List<dynamic> parseISODate(String s) {
  return parse(s, [
    [isoYmdWithTimeExtensionRegex, extractISOYmdTimeAndOffset],
    [isoWeekWithTimeExtensionRegex, extractISOWeekTimeAndOffset],
    [isoOrdinalWithTimeExtensionRegex, extractISOOrdinalDateAndTime],
    [isoTimeCombinedRegex, extractISOTimeAndOffset]
  ]);
}

List<dynamic> parseRFC2822Date(String s) {
  return parse(preprocessRFC2822(s), [
    [rfc2822, extractRFC2822]
  ]);
}

List<dynamic> parseHTTPDate(String s) {
  return parse(s, [
    [rfc1123, extractRFC1123Or850],
    [rfc850, extractRFC1123Or850],
    [ascii, extractASCII]
  ]);
}

List<dynamic> parseISODuration(String s) {
  return parse(s, [
    [isoDuration, extractISODuration]
  ]);
}

final extractISOTimeOnly = combineExtractors([extractISOTime]);

List<dynamic> parseISOTimeOnly(String s) {
  return parse(s, [
    [isoTimeOnly, extractISOTimeOnly]
  ]);
}

final RegExp sqlYmdWithTimeExtensionRegex =
    combineRegexes([sqlYmdRegex, sqlTimeExtensionRegex]);
final RegExp sqlTimeCombinedRegex = combineRegexes([sqlTimeRegex]);

final extractISOTimeOffsetAndIANAZone =
    combineExtractors([extractISOTime, extractISOOffset, extractIANAZone]);

List<dynamic> parseSQL(String s) {
  return parse(s, [
    [sqlYmdWithTimeExtensionRegex, extractISOYmdTimeAndOffset],
    [sqlTimeCombinedRegex, extractISOTimeOffsetAndIANAZone]
  ]);
}

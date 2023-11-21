import 'luxon.dart';

const INVALID = "Invalid LuxonDateTime";
const MAX_DATE = 8.64e15;

Invalid unsupportedZone(Zone zone) {
  return Invalid(
      "unsupported zone", 'the zone "${zone.name}" is not supported');
}

LuxonDateTime possiblyCachedWeekData(LuxonDateTime dt) {
  if (dt.weekData == null) {
    dt.weekData = gregorianToWeek(dt.c);
  }
  return dt.weekData;
}

LuxonDateTime possiblyCachedLocalWeekData(LuxonDateTime dt) {
  if (dt.localWeekData == null) {
    dt.localWeekData = gregorianToWeek(
      dt.c,
      dt.loc.getMinDaysInFirstWeek(),
      dt.loc.getStartOfWeek(),
    );
  }
  return dt.localWeekData;
}

LuxonDateTime clone(LuxonDateTime inst, Map<String, dynamic> alts) {
  final current = {
    'ts': inst.ts,
    'zone': inst.zone,
    'c': inst.c,
    'o': inst.o,
    'loc': inst.loc,
    'invalid': inst.invalid,
  };
  return LuxonDateTime({...current, ...alts, 'old': current});
}

List<int> fixOffset(int localTS, int o, Zone tz) {
  int utcGuess = localTS - o * 60 * 1000;
  final o2 = tz.offset(utcGuess);

  if (o == o2) {
    return [utcGuess, o];
  }

  utcGuess -= (o2 - o) * 60 * 1000;

  final o3 = tz.offset(utcGuess);
  if (o2 == o3) {
    return [utcGuess, o2];
  }

  return [localTS - (o2 < o3 ? o2 : o3) * 60 * 1000, (o2 > o3 ? o2 : o3)];
}

Map<String, dynamic> tsToObj(int ts, int offset) {
  ts += offset * 60 * 1000;

  final d = DateTime.fromMillisecondsSinceEpoch(ts);

  return {
    'year': d.year,
    'month': d.month,
    'day': d.day,
    'hour': d.hour,
    'minute': d.minute,
    'second': d.second,
    'millisecond': d.millisecond,
  };
}

List<int> objToTS(Map<String, int> obj, int offset, Zone zone) {
  return fixOffset(objToLocalTS(obj), offset, zone);
}

Map<String, dynamic> adjustTime(LuxonDateTime inst, Duration dur) {
  final oPre = inst.o,
      year = inst.c.year + dur.inDays ~/ 365,
      month = inst.c.month + dur.inDays ~/ 30 + (dur.inDays ~/ 91) * 3,
      c = {
        ...inst.c,
        'year': year,
        'month': month,
        'day': inst.c.day +
            (dur.inDays % daysInMonth(year, month)) +
            (dur.inDays ~/ 7) * 7,
      },
      millisToAdd = dur.inMilliseconds,
      localTS = objToLocalTS(c);

  final result = fixOffset(localTS, oPre, inst.zone);
  int ts = result[0];
  int o = result[1];

  if (millisToAdd != 0) {
    ts += millisToAdd;
    o = inst.zone.offset(ts);
  }

  return {'ts': ts, 'o': o};
}

LuxonDateTime parseDataToLuxonDateTime(
    Map<String, dynamic> parsed,
    Zone parsedZone,
    Map<String, dynamic> opts,
    String format,
    String text,
    bool specificOffset) {
  final setZone = opts['setZone'] ?? false;
  final zone = opts['zone'];

  if ((parsed.isNotEmpty || parsedZone != null)) {
    final interpretationZone = parsedZone ?? zone;
    final inst = LuxonDateTime.fromMap(parsed, {
      ...opts,
      'zone': interpretationZone,
      'specificOffset': specificOffset,
    });
    return setZone ? inst : inst.setZone(zone);
  } else {
    return LuxonDateTime.invalid(
      Invalid("unparsable", 'the input "$text" can\'t be parsed as $format'),
    );
  }
}

String toTechFormat(LuxonDateTime dt, String format, [bool allowZ = true]) {
  return dt.isValid
      ? Formatter.create(LuxonLocale.create("en-US"), {
          'allowZ': allowZ,
          'forceSimple': true,
        }).formatLuxonDateTimeFromString(dt, format)
      : null;
}

String toISODate(Map<String, dynamic> o, bool extended) {
  final longFormat = o['year'] > 9999 || o['year'] < 0;
  String c = "";
  if (longFormat && o['year'] >= 0) c += "+";
  c += o['year'].toString().padLeft(longFormat ? 6 : 4, '0');

  if (extended) {
    c += "-";
    c += o['month'].toString().padLeft(2, '0');
    c += "-";
    c += o['day'].toString().padLeft(2, '0');
  } else {
    c += o['month'].toString().padLeft(2, '0');
    c += o['day'].toString().padLeft(2, '0');
  }
  return c;
}

String toISOTime(Map<String, dynamic> o, bool extended, bool suppressSeconds,
    bool suppressMilliseconds, bool includeOffset, bool extendedZone) {
  String c = o['hour'].toString().padLeft(2, '0');
  if (extended) {
    c += ":";
    c += o['minute'].toString().padLeft(2, '0');
    if (o['millisecond'] != 0 || o['second'] != 0 || !suppressSeconds) {
      c += ":";
    }
  } else {
    c += o['minute'].toString().padLeft(2, '0');
  }

  if (o['millisecond'] != 0 || o['second'] != 0 || !suppressSeconds) {
    c += o['second'].toString().padLeft(2, '0');

    if (o['millisecond'] != 0 || !suppressMilliseconds) {
      c += ".";
      c += o['millisecond'].toString().padLeft(3, '0');
    }
  }

  if (includeOffset) {
    if (o['isOffsetFixed'] && o['offset'] == 0 && !extendedZone) {
      c += "Z";
    } else if (o['o'] < 0) {
      c += "-";
      c += (o['o'] ~/ 60).toString().padLeft(2, '0');
      c += ":";
      c += (o['o'] % 60).toString().padLeft(2, '0');
    } else {
      c += "+";
      c += (o['o'] ~/ 60).toString().padLeft(2, '0');
      c += ":";
      c += (o['o'] % 60).toString().padLeft(2, '0');
    }
  }

  if (extendedZone) {
    c += "[${o['zone']['ianaName']}]";
  }
  return c;
}

const defaultUnitValues = {
  'month': 1,
  'day': 1,
  'hour': 0,
  'minute': 0,
  'second': 0,
  'millisecond': 0,
};
const defaultWeekUnitValues = {
  'weekNumber': 1,
  'weekday': 1,
  'hour': 0,
  'minute': 0,
  'second': 0,
  'millisecond': 0,
};
const defaultOrdinalUnitValues = {
  'ordinal': 1,
  'hour': 0,
  'minute': 0,
  'second': 0,
  'millisecond': 0,
};

const orderedUnits = [
  'year',
  'month',
  'day',
  'hour',
  'minute',
  'second',
  'millisecond'
];
const orderedWeekUnits = [
  'weekYear',
  'weekNumber',
  'weekday',
  'hour',
  'minute',
  'second',
  'millisecond'
];
const orderedOrdinalUnits = [
  'year',
  'ordinal',
  'hour',
  'minute',
  'second',
  'millisecond'
];

String normalizeUnit(String unit) {
  final normalized = {
    'year': 'year',
    'years': 'year',
    'month': 'month',
    'months': 'month',
    'day': 'day',
    'days': 'day',
    'hour': 'hour',
    'hours': 'hour',
    'minute': 'minute',
    'minutes': 'minute',
    'quarter': 'quarter',
    'quarters': 'quarter',
    'second': 'second',
    'seconds': 'second',
    'millisecond': 'millisecond',
    'milliseconds': 'millisecond',
    'weekday': 'weekday',
    'weekdays': 'weekday',
    'weeknumber': 'weekNumber',
    'weeksnumber': 'weekNumber',
    'weeknumbers': 'weekNumber',
    'weekyear': 'weekYear',
    'weekyears': 'weekYear',
    'ordinal': 'ordinal',
  }[unit.toLowerCase()];

  if (normalized == null) throw InvalidUnitError(unit);

  return normalized;
}

String normalizeUnitWithLocalWeeks(String unit) {
  switch (unit.toLowerCase()) {
    case 'localweekday':
    case 'localweekdays':
      return 'localWeekday';
    case 'localweeknumber':
    case 'localweeknumbers':
      return 'localWeekNumber';
    case 'localweekyear':
    case 'localweekyears':
      return 'localWeekYear';
    default:
      return normalizeUnit(unit);
  }
}

LuxonDateTime quickDT(Map<String, dynamic> obj, Map<String, dynamic> opts) {
  final zone = normalizeZone(opts['zone'], Settings.defaultZone);
  final loc = LuxonLocale.fromObject(opts);
  final tsNow = Settings.now();

  int ts, o;

  if (obj.containsKey('year')) {
    for (final u in orderedUnits) {
      if (!obj.containsKey(u)) {
        obj[u] = defaultUnitValues[u];
      }
    }

    final invalid = hasInvalidGregorianData(obj) || hasInvalidTimeData(obj);
    if (invalid) {
      return LuxonDateTime.invalid(invalid);
    }

    final offsetProvis = zone.offset(tsNow);
    final result = objToTS(obj, offsetProvis, zone);
    ts = result[0];
    o = result[1];
  } else {
    ts = tsNow;
  }

  return LuxonDateTime(ts: ts, zone: zone, loc: loc, o: o);
}

String diffRelative(LuxonDateTime start, LuxonDateTime end, Map<String, dynamic> opts) {
  final round = opts.containsKey('round') ? opts['round'] : true;
  final format = (c, unit) {
    c = roundTo(c, round || opts['calendary'] ? 0 : 2, true);
    final formatter = end.loc.clone(opts);
    return formatter.format(c, unit);
  };
  final differ = (unit) {
    if (opts['calendary']) {
      if (!end.hasSame(start, unit)) {
        return end.startOf(unit).diff(start.startOf(unit), unit).get(unit);
      } else {
        return 0;
      }
    } else {
      return end.diff(start, unit).get(unit);
    }
  };

  if (opts.containsKey('unit')) {
    return format(differ(opts['unit']), opts['unit']);
  }

  for (final unit in opts['units']) {
    final count = differ(unit);
    if (count.abs() >= 1) {
      return format(count, unit);
    }
  }
  return format(start > end ? -0 : 0, opts['units'][opts['units'].length - 1]);
}

List<dynamic> lastOpts(List<dynamic> argList) {
  var opts = {};
  List<dynamic> args;
  if (argList.isNotEmpty && argList.last is Map<String, dynamic>) {
    opts = argList.last;
    args = argList.sublist(0, argList.length - 1);
  } else {
    args = List.from(argList);
  }
  return [opts, args];
}


// **************************************************************************

class LuxonDateTime {
  int ts;
  Zone _zone;
  LuxonLocale loc;
  Invalid invalid;
  dynamic weekData;
  dynamic localWeekData;
  dynamic c;
  dynamic o;
  bool isLuxonLuxonDateTime;

  DateTime toDartDateTime() =>
    DateTime.fromMillisecondsSinceEpoch(this.ts);

  int get millisecondsSinceEpoch => this.ts;

  bool isBefore(LuxonDateTime other) => this.ts < other.ts;
  
  bool isAfter(LuxonDateTime other) => this.ts > other.ts;

  LuxonDateTime(
      {this.ts,
      this._zone,
      this.loc,
      this.invalid,
      this.weekData,
      this.localWeekData,
      this.c,
      this.o,
      this.isLuxonLuxonDateTime = false});

  LuxonDateTime.fromMap(Map<String, dynamic> config) {
    Zone zone = config['zone'] ?? Settings.defaultZone;
    invalid =
        config['invalid'] ??
            (config['ts'].isNaN
                ? Invalid('invalid input')
                : null) ??
            (!zone.isValid ? unsupportedZone(zone) : null);
    ts = config['ts'] ?? Settings.now();
    c = null;
    o = null;

    if (invalid == null) {
      final unchanged = config['old'] != null &&
          config['old']['ts'] == ts &&
          config['old']['zone'].equals(zone);

      if (unchanged) {
        c = config['old']['c'];
        o = config['old']['o'];
      } else {
        final ot = zone.offset(ts);
        c = tsToObj(ts, ot);
        invalid = c['year'].isNaN ? Invalid('invalid input') : null;
        c = invalid != null ? null : c;
        o = invalid != null ? null : ot;
      }
    }

    _zone = zone;
    loc = config['loc'] ?? LuxonLocale.create();
    invalid = invalid;
    weekData = null;
    localWeekData = null;
    this.c = c;
    this.o = o;
    isLuxonLuxonDateTime = true;
  }

  static LuxonDateTime now() {
    return LuxonDateTime({});
  }

  static LuxonDateTime local() {
    final opts = lastOpts(arguments);
    final args = opts[1];
    final year = args[0];
    final month = args[1] ?? 1;
    final day = args[2] ?? 1;
    final hour = args[3] ?? 0;
    final minute = args[4] ?? 0;
    final second = args[5] ?? 0;
    final millisecond = args[6] ?? 0;

    return quickDT(
        {
          'year': year,
          'month': month,
          'day': day,
          'hour': hour,
          'minute': minute,
          'second': second,
          'millisecond': millisecond
        },
        opts[0]);
  }

  // Other static methods...

  static LuxonDateTime fromJSDate(date, [options = const {}]) {
    final ts = date is LuxonDateTime ? date.millisecondsSinceEpoch : double.nan;
    if (ts.isNaN) {
      return LuxonDateTime.invalid('invalid input');
    }

    final zoneToUse = normalizeZone(options['zone'], Settings.defaultZone);
    if (!zoneToUse.isValid) {
      return LuxonDateTime.invalid(unsupportedZone(zoneToUse));
    }

    return LuxonDateTime({
      'ts': ts,
      'zone': zoneToUse,
      'loc': LuxonLocale.fromObject(options)
    });
  }

  // Other static methods...

  static LuxonDateTime fromObject(obj, [opts = const {}]) {
    obj = obj ?? {};
    final zoneToUse = normalizeZone(opts['zone'], Settings.defaultZone);
    if (!zoneToUse.isValid) {
      return LuxonDateTime.invalid(unsupportedZone(zoneToUse));
    }

    final loc = LuxonLocale.fromObject(opts);
    final normalized = normalizeObject(obj, normalizeUnitWithLocalWeeks);
    final minDaysInFirstWeek = usesLocalWeekValues(normalized, loc)['minDaysInFirstWeek'];
    final startOfWeek = usesLocalWeekValues(normalized, loc)['startOfWeek'];
    final tsNow = Settings.now();
    final offsetProvis = opts.containsKey('specificOffset')
        ? opts['specificOffset']
        : zoneToUse.offset(tsNow);
    final containsOrdinal = normalized.containsKey('ordinal');
    final containsGregorYear = normalized.containsKey('year');
    final containsGregorMD = normalized.containsKey('month') || normalized.containsKey('day');
    final containsGregor = containsGregorYear || containsGregorMD;
    final definiteWeekDef =
        normalized.containsKey('weekYear') || normalized.containsKey('weekNumber');

    if ((containsGregor || containsOrdinal) && definiteWeekDef) {
      throw ConflictingSpecificationError(
          "Can't mix weekYear/weekNumber units with year/month/day or ordinals");
    }

    if (containsGregorMD && containsOrdinal) {
      throw ConflictingSpecificationError("Can't mix ordinal dates with month/day");
    }

    final useWeekData = definiteWeekDef || (normalized.containsKey('weekday') && !containsGregor);

    final units = useWeekData
        ? orderedWeekUnits
        : containsOrdinal ? orderedOrdinalUnits : orderedUnits;
    final defaultValues = useWeekData
        ? defaultWeekUnitValues
        : containsOrdinal ? defaultOrdinalUnitValues : defaultUnitValues;

    var foundFirst = false;
    for (var u in units) {
      final v = normalized[u];
      if (v != null) {
        foundFirst = true;
      } else if (foundFirst) {
        normalized[u] = defaultValues[u];
      }
    }

    final valid = containsGregor
        ? gregorianToWeek(normalized['year'], normalized['month'], normalized['day'])
        : containsOrdinal
            ? ordinalToGregorian(normalized['ordinal'], normalized['year'])
            : weekToGregorian(normalized['weekYear'], normalized['weekNumber'], normalized['weekday']);

    if (valid == null) {
      return LuxonDateTime.invalid('unparsable string');
    }

    final { year, month, day } = valid;
    final objOut = {
      'year': year,
      'month': month,
      'day': day,
      'hour': normalized['hour'] ?? 0,
      'minute': normalized['minute'] ?? 0,
      'second': normalized['second'] ?? 0,
      'millisecond': normalized['millisecond'] ?? 0
    };

    final newObj = LuxonDateTime({
      'ts': objToTS(objOut, offsetProvis),
      'zone': zoneToUse,
      'loc': loc,
      'old': objOut
    });

    if (containsGregor) {
      newObj._loc = loc;
    }

    return newObj;
  }

  static normalizeZone(dynamic input, Zone fallback) {
    if (input == null) {
      return fallback;
    } else if (input is Zone) {
      return input;
    } else if (input is String) {
      return FixedOffsetZone.parseSpecifier(input) ?? fallback;
    } else if (input is int) {
      return FixedOffsetZone.instance(input);
    } else if (input is Map) {
      return FixedOffsetZone.instance(input['offset']) ?? fallback;
    } else {
      return fallback;
    }
  }

  int get(String unit) {
    return this[unit];
  }

  bool get isValid {
    return this.invalid == null;
  }

  String get invalidReason {
    return this.invalid != null ? this.invalid.reason : null;
  }

  String get invalidExplanation {
    return this.invalid != null ? this.invalid.explanation : null;
  }

  String get locale {
    return this.isValid ? this.loc.locale : null;
  }

  String get numberingSystem {
    return this.isValid ? this.loc.numberingSystem : null;
  }

  String get outputCalendar {
    return this.isValid ? this.loc.outputCalendar : null;
  }

  Zone get zone {
    return this._zone;
  }

  String get zoneName {
    return this.isValid ? this.zone.name : null;
  }

  int get year {
    return this.isValid ? this.c.year : double.nan.toInt();
  }

  int get quarter {
    return this.isValid ? ((this.c.month / 3).ceil()) : double.nan.toInt();
  }

  int get month {
    return this.isValid ? this.c.month : double.nan.toInt();
  }

  int get day {
    return this.isValid ? this.c.day : double.nan.toInt();
  }

  int get hour {
    return this.isValid ? this.c.hour : double.nan.toInt();
  }

  int get minute {
    return this.isValid ? this.c.minute : double.nan.toInt();
  }

  int get second {
    return this.isValid ? this.c.second : double.nan.toInt();
  }

  int get millisecond {
    return this.isValid ? this.c.millisecond : double.nan.toInt();
  }

  int get weekYear {
    return this.isValid ? possiblyCachedWeekData(this).weekYear : double.nan.toInt();
  }

  int get weekNumber {
    return this.isValid ? possiblyCachedWeekData(this).weekNumber : double.nan.toInt();
  }

  int get weekday {
    return this.isValid ? possiblyCachedWeekData(this).weekday : double.nan.toInt();
  }

  bool get isWeekend {
    return this.isValid && this.loc.getWeekendDays().contains(this.weekday);
  }

  int get localWeekday {
    return this.isValid ? possiblyCachedLocalWeekData(this).weekday : double.nan.toInt();
  }

  int get localWeekNumber {
    return this.isValid ? possiblyCachedLocalWeekData(this).weekNumber : double.nan.toInt();
  }

  int get localWeekYear {
    return this.isValid ? possiblyCachedLocalWeekData(this).weekYear : double.nan.toInt();
  }

  int get ordinal {
    return this.isValid ? gregorianToOrdinal(this.c).ordinal : double.nan.toInt();
  }

  String get monthShort {
    return this.isValid
        ? Info.months("short", {"locObj": this.loc})[this.month - 1]
        : null;
  }

  // ... (other getters)

  int get offset {
    return this.isValid ? +this.o : double.nan.toInt();
  }

  String get offsetNameShort {
    if (this.isValid) {
      return this.zone.offsetName(this.ts, {"format": "short", "locale": this.locale});
    } else {
      return null;
    }
  }

  String get offsetNameLong {
    if (this.isValid) {
      return this.zone.offsetName(this.ts, {"format": "long", "locale": this.locale});
    } else {
      return null;
    }
  }

  bool get isOffsetFixed {
    return this.isValid ? this.zone.isUniversal : null;
  }

  bool get isInDST {
    if (this.isOffsetFixed) {
      return false;
    } else {
      return (this.offset > this.set({"month": 1, "day": 1}).offset ||
          this.offset > this.set({"month": 5}).offset);
    }
  }

  List<LuxonDateTime> getPossibleOffsets() {
    if (!this.isValid || this.isOffsetFixed) {
      return [this];
    }
    // ... (rest of the method translation)
  }

  bool get isInLeapYear {
    return isLeapYear(this.year);
  }

  int get daysInMonth {
    return daysInMonth(this.year, this.month);
  }

  int get daysInYear {
    return this.isValid ? daysInYear(this.year) : double.nan.toInt();
  }

  int get weeksInWeekYear {
    return this.isValid ? weeksInWeekYear(this.weekYear) : double.nan.toInt();
  }

  int get weeksInLocalWeekYear {
    return this.isValid
        ? weeksInWeekYear(this.localWeekYear, this.loc.getMinDaysInFirstWeek(), this.loc.getStartOfWeek())
        : double.nan.toInt();
  }

  Map<String, dynamic> resolvedLuxonLocaleOptions({Map<String, dynamic> opts = const {}}) {
    final locale = this.loc.clone(opts).resolvedOptions(this);
    return {"locale": locale.locale, "numberingSystem": locale.numberingSystem, "outputCalendar": locale.calendar};
  }

  // TRANSFORM

  LuxonDateTime toUTC([int offset = 0, Map<String, dynamic> opts = const {}]) {
    return this.setZone(FixedOffsetZone.instance(offset), opts);
  }

  LuxonDateTime toLocal() {
    return this.setZone(Settings.defaultZone);
  }

  LuxonDateTime setZone(dynamic zone, {bool keepLocalTime = false, bool keepCalendarTime = false}) {
    // ... (rest of the method translation)
  }

  LuxonDateTime reconfigure({String locale, String numberingSystem, String outputCalendar}) {
    final loc = this.loc.clone({"locale": locale, "numberingSystem": numberingSystem, "outputCalendar": outputCalendar});
    return clone(this, {"loc": loc});
  }

  LuxonDateTime setLuxonLocale(String locale) {
    return this.reconfigure({"locale": locale});
  }

  LuxonDateTime set(Map<String, dynamic> values) {
    // ... (rest of the method translation)
  }

 LuxonDateTime startOfYear(){}
 LuxonDateTime startOfquarter(){}
 LuxonDateTime startOfMonth(){}
 LuxonDateTime startOfWeek(){}
 LuxonDateTime startOfIsoWeek(){}
 LuxonDateTime startOfDate(){}
 LuxonDateTime startOfDay(){}
 LuxonDateTime startOfHour(){}
 LuxonDateTime startOfMinute(){}
 LuxonDateTime startOfSecond(){}

  LuxonDateTime plus(dynamic duration) {
    if (!this.isValid) return this;
    Duration dur;
    if (duration is Duration || duration is DurationLike) {
      dur = duration;
    } else if (duration is Map<String, int>) {
      dur = Duration(
        days: duration['days'] ?? 0,
        hours: duration['hours'] ?? 0,
        minutes: duration['minutes'] ?? 0,
        seconds: duration['seconds'] ?? 0,
        milliseconds: duration['milliseconds'] ?? 0,
      );
    } else if (duration is int) {
      dur = Duration(milliseconds: duration);
    } else {
      // Handle other cases if needed
      return this;
    }
    return LuxonDateTime(isValid: true, ts: this.ts + dur.inMilliseconds);
  }

  LuxonDateTime minus(dynamic duration) {
    if (!this.isValid) return this;
    Duration dur;
    if (duration is Duration || duration is DurationLike) {
      dur = duration;
    } else if (duration is Map<String, int>) {
      dur = Duration(
        days: duration['days'] ?? 0,
        hours: duration['hours'] ?? 0,
        minutes: duration['minutes'] ?? 0,
        seconds: duration['seconds'] ?? 0,
        milliseconds: duration['milliseconds'] ?? 0,
      );
    } else if (duration is int) {
      dur = Duration(milliseconds: duration);
    } else {
      // Handle other cases if needed
      return this;
    }
    return LuxonDateTime(isValid: true, ts: this.ts - dur.inMilliseconds);
  }

  LuxonDateTime startOf(String unit, {bool useLuxonLocaleWeeks = false}) {
    if (!this.isValid) return this;
    Map<String, int> o = {};
    String normalizedUnit = unit.toLowerCase();
    switch (normalizedUnit) {
      // Handle different units and adjust the 'o' map accordingly
      // Cases are abbreviated for brevity
    }
    return LuxonDateTime(isValid: true, ts: adjustTime(this, dur));
  }

  LuxonDateTime endOf(String unit, {Map<String, dynamic> opts}) {
    return this.isValid
        ? this.plus({unit: 1})
            .startOf(unit, opts)
            .minus(1)
        : this;
  }

  // Other methods...

  LuxonDateTime clone(LuxonDateTime dt, int adjustTime) {
    // Implementation of the clone method if needed
  }

  int adjustTime(LuxonDateTime dt, Duration dur) {
    // Implementation of the adjustTime method if needed
  }

  // Helper methods...

String toISODate(LuxonDateTime dt, bool ext) {
  // Implementation of toISODate method
}

String toISOTime(
  LuxonDateTime dt,
  bool ext,
  bool suppressSeconds,
  bool suppressMilliseconds,
  bool includeOffset,
  bool extendedZone,
) {
  // Implementation of toISOTime method
}

String toTechFormat(LuxonDateTime dt, String format, bool ext) {
  // Implementation of toTechFormat method
}



  Duration diff(LuxonDateTime otherLuxonDateTime, [unit = 'milliseconds', opts = const {}]) {
    if (!isValid || !otherLuxonDateTime.isValid) {
      return Duration(milliseconds: -1); // Modify to represent an invalid Duration
    }

    var durOpts = {
      'locale': locale,
      'numberingSystem': numberingSystem,
      ...opts,
    };

    var units = maybeArray(unit).map(Duration.normalizeUnit);
    var otherIsLater = otherLuxonDateTime.valueOf() > valueOf();
    var earlier = otherIsLater ? this : otherLuxonDateTime;
    var later = otherIsLater ? otherLuxonDateTime : this;
    var diffed = diff(earlier, later, units, durOpts);

    return otherIsLater ? diffed.negate() : diffed;
  }

  Duration diffNow([unit = 'milliseconds', opts = const {}]) {
    return diff(LuxonDateTime.now(), unit, opts);
  }

  Interval until(LuxonDateTime otherLuxonDateTime) {
    return isValid ? Interval.fromLuxonDateTimes(this, otherLuxonDateTime) : this;
  }

  bool hasSame(LuxonDateTime otherLuxonDateTime, String unit, opts) {
    if (!isValid) return false;

    var inputMs = otherLuxonDateTime.valueOf();
    var adjustedToZone = setZone(otherLuxonDateTime.zone, {'keepLocalTime': true});
    return (adjustedToZone.startOf(unit, opts) <= inputMs &&
        inputMs <= adjustedToZone.endOf(unit, opts));
  }

  bool equals(LuxonDateTime other) {
    return (isValid &&
        other.isValid &&
        valueOf() == other.valueOf() &&
        zone.equals(other.zone) &&
        loc.equals(other.loc));
  }

  String toRelative([options = const {}]) {
    if (!isValid) return null;
    var base = options['base'] ?? LuxonDateTime.fromObject({}, zone: this.zone);
    var padding = options['padding'] ?? 0;

    var units = ['years', 'months', 'days', 'hours', 'minutes', 'seconds'];
    var unit = options['unit'];
    if (unit is List<String>) {
      units = unit;
      unit = null;
    }

    return diffRelative(base, plus(padding), {
      ...options,
      'numeric': 'always',
      'units': units,
      'unit': unit,
    });
  }

  String toRelativeCalendar([options = const {}]) {
    if (!isValid) return null;

    return diffRelative(options['base'] ?? LuxonDateTime.fromObject({}, zone: this.zone), this, {
      ...options,
      'numeric': 'auto',
      'units': ['years', 'months', 'days'],
      'calendary': true,
    });
  }

  static LuxonDateTime min(List<LuxonDateTime> dateTimes) {
    if (!dateTimes.every((dt) => isLuxonDateTime(dt))) {
      throw ArgumentError('min requires all arguments be LuxonDateTimes');
    }
    return bestBy<LuxonDateTime, int>(dateTimes, (i) => i.valueOf(), min);
  }

  static LuxonDateTime max(List<LuxonDateTime> dateTimes) {
    if (!dateTimes.every((dt) => isLuxonDateTime(dt))) {
      throw ArgumentError('max requires all arguments be LuxonDateTimes');
    }
    return bestBy<LuxonDateTime, int>(dateTimes, (i) => i.valueOf(), max);
  }

  static Map<String, dynamic> fromFormatExplain(String text, String fmt, [options = const {}]) {
    var locale = options['locale'] ?? null;
    var numberingSystem = options['numberingSystem'] ?? null;
    var localeToUse = LuxonLocale.fromOpts({
      'locale': locale,
      'numberingSystem': numberingSystem,
      'defaultToEN': true,
    });
    return explainFromTokens(localeToUse, text, fmt);
  }

  @deprecated
  static Map<String, dynamic> fromStringExplain(String text, String fmt, [options = const {}]) {
    return fromFormatExplain(text, fmt, options);
  }

  // FORMAT PRESETS: Implement the necessary Formats constants
}












// **************************************************************************

LuxonDateTime friendlyLuxonDateTime(dateTimeish) {
  if (dateTimeish is LuxonDateTime) {
    return dateTimeish;
  } else if (dateTimeish != null &&
      dateTimeish.value?.runtimeType == num &&
      dateTimeish is! bool) {
    return LuxonDateTime.fromMillisecondsSinceEpoch(dateTimeish.value.toInt());
  } else if (dateTimeish != null && dateTimeish is Map<String, dynamic>) {
    return LuxonDateTime.fromMap(dateTimeish.cast<String, dynamic>());
  } else {
    throw ArgumentError.value(
      dateTimeish,
      'Unknown datetime argument: $dateTimeish, of type ${dateTimeish.runtimeType}',
    );
  }
}

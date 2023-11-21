import 'dart:convert';

import '../luxon.dart'; // Add this import for jsonEncode

Map<String, dynamic> intlLFCache = {};
Intl.ListFormat getCachedLF(String locString,
    [Map<String, dynamic> opts = const {}]) {
  final key = jsonEncode([locString, opts]);
  var dtf = intlLFCache[key] as Intl.ListFormat?;
  if (dtf == null) {
    dtf = Intl.ListFormat(locString, opts);
    intlLFCache[key] = dtf;
  }
  return dtf;
}

Map<String, dynamic> intlDTCache = {};
Intl.DateTimeFormat getCachedDTF(String locString,
    [Map<String, dynamic> opts = const {}]) {
  final key = jsonEncode([locString, opts]);
  var dtf = intlDTCache[key] as Intl.DateTimeFormat?;
  if (dtf == null) {
    dtf = Intl.DateTimeFormat(locString, opts);
    intlDTCache[key] = dtf;
  }
  return dtf;
}

Map<String, dynamic> intlNumCache = {};
Intl.NumberFormat getCachedINF(String locString,
    [Map<String, dynamic> opts = const {}]) {
  final key = jsonEncode([locString, opts]);
  var inf = intlNumCache[key] as Intl.NumberFormat?;
  if (inf == null) {
    inf = Intl.NumberFormat(locString, opts);
    intlNumCache[key] = inf;
  }
  return inf;
}

Map<String, dynamic> intlRelCache = {};
Intl.RelativeTimeFormat getCachedRTF(String locString,
    [Map<String, dynamic> opts = const {}]) {
  final cacheKeyOpts = {...opts}..remove('base');
  final key = jsonEncode([locString, cacheKeyOpts]);
  var inf = intlRelCache[key] as Intl.RelativeTimeFormat?;
  if (inf == null) {
    inf = Intl.RelativeTimeFormat(locString, opts);
    intlRelCache[key] = inf;
  }
  return inf;
}

String? sysLuxonLocaleCache;
String systemLuxonLocale() {
  if (sysLuxonLocaleCache != null) {
    return sysLuxonLocaleCache!;
  } else {
    sysLuxonLocaleCache = Intl.DateTimeFormat().resolvedOptions().locale;
    return sysLuxonLocaleCache!;
  }
}

Map<String, dynamic> weekInfoCache = {};
dynamic getCachedWeekInfo(String locString) {
  var data = weekInfoCache[locString];
  if (data == null) {
    final locale = Intl.LuxonLocale(locString);
    // browsers currently implement this as a property, but spec says it should be a getter function
    data = locale.hasWeekInfo ? locale.weekInfo : locale.getWeekInfo();
    weekInfoCache[locString] = data;
  }
  return data;
}

List<dynamic> parseLuxonLocaleString(String localeStr) {
  // I really want to avoid writing a BCP 47 parser
  // see, e.g. https://github.com/wooorm/bcp-47
  // Instead, we'll do this:

  // a) if the string has no -u extensions, just leave it alone
  // b) if it does, use Intl to resolve everything
  // c) if Intl fails, try again without the -u

  // private subtags and unicode subtags have ordering requirements,
  // and we're not properly parsing this, so just strip out the
  // private ones if they exist.
  final xIndex = localeStr.indexOf("-x-");
  if (xIndex != -1) {
    localeStr = localeStr.substring(0, xIndex);
  }

  final uIndex = localeStr.indexOf("-u-");
  if (uIndex == -1) {
    return [localeStr];
  } else {
    dynamic options;
    String selectedStr;
    try {
      options = getCachedDTF(localeStr).resolvedOptions();
      selectedStr = localeStr;
    } catch (e) {
      final smaller = localeStr.substring(0, uIndex);
      options = getCachedDTF(smaller).resolvedOptions();
      selectedStr = smaller;
    }

    final numberingSystem = options['numberingSystem'];
    final calendar = options['calendar'];
    return [selectedStr, numberingSystem, calendar];
  }
}

String intlConfigString(
    String localeStr, String? numberingSystem, String? outputCalendar) {
  if (outputCalendar != null || numberingSystem != null) {
    if (!localeStr.contains("-u-")) {
      localeStr += "-u";
    }

    if (outputCalendar != null) {
      localeStr += "-ca-$outputCalendar";
    }

    if (numberingSystem != null) {
      localeStr += "-nu-$numberingSystem";
    }
    return localeStr;
  } else {
    return localeStr;
  }
}

List<dynamic> mapMonths(dynamic Function(LuxonDateTime) f) {
  final ms = <dynamic>[];
  for (var i = 1; i <= 12; i++) {
    final dt = LuxonDateTime.utc(2009, i, 1);
    ms.add(f(dt));
  }
  return ms;
}

List<dynamic> mapWeekdays(dynamic Function(LuxonDateTime) f) {
  final ms = <dynamic>[];
  for (var i = 1; i <= 7; i++) {
    final dt = LuxonDateTime.utc(2016, 11, 13 + i);
    ms.add(f(dt));
  }
  return ms;
}

dynamic listStuff(Intl.LuxonLocale loc, int length,
    dynamic Function(int) englishFn, dynamic Function(int) intlFn) {
  final mode = loc.listingMode();

  if (mode == "error") {
    return null;
  } else if (mode == "en") {
    return englishFn(length);
  } else {
    return intlFn(length);
  }
}

bool supportsFastNumbers(Intl.LuxonLocale loc) {
  if (loc.numberingSystem != null && loc.numberingSystem != "latn") {
    return false;
  } else {
    return (loc.numberingSystem == "latn" ||
        loc.locale == null ||
        loc.locale!.startsWith("en") ||
        Intl.DateTimeFormat(loc.intl).resolvedOptions().numberingSystem ==
            "latn");
  }
}

class PolyNumberFormatter {
  late int padTo;
  late bool floor;
  late dynamic inf;

  PolyNumberFormatter(
      String intl, bool forceSimple, Map<String, dynamic> opts) {
    padTo = opts['padTo'] ?? 0;
    floor = opts['floor'] ?? false;

    final otherOpts = Map<String, dynamic>.from(opts);
    otherOpts.remove('padTo');
    otherOpts.remove('floor');

    if (!forceSimple || otherOpts.isNotEmpty) {
      final intlOpts = {'useGrouping': false, ...opts};
      if (opts['padTo'] > 0) intlOpts['minimumIntegerDigits'] = opts['padTo'];
      inf = getCachedINF(intl, intlOpts);
    }
  }

  String format(num i) {
    if (inf != null) {
      final fixed = floor ? i.floor() : i;
      return inf.format(fixed);
    } else {
      final fixed = floor ? i.floor() : roundTo(i, 3);
      return padStart(fixed.toString(), padTo);
    }
  }
}

class PolyDateFormatter {
  late dynamic opts;
  dynamic originalZone;
  dynamic dt;
  dynamic dtf;

  PolyDateFormatter(dynamic dt, String intl, Map<String, dynamic> opts) {
    this.opts = opts;
    originalZone = null;

    var z;
    if (this.opts['timeZone'] != null) {
      dt = dt;
    } else if (dt['zone']['type'] == 'fixed') {
      final gmtOffset = -(dt['offset'] ~/ 60);
      final offsetZ =
          gmtOffset >= 0 ? 'Etc/GMT+$gmtOffset' : 'Etc/GMT$gmtOffset';
      if (dt['offset'] != 0 && IANAZone.create(offsetZ).valid) {
        z = offsetZ;
        this.dt = dt;
      } else {
        z = 'UTC';
        this.dt = dt['offset'] == 0
            ? dt
            : dt.setZone('UTC').plus({'minutes': dt['offset']});
        originalZone = dt['zone'];
      }
    } else if (dt['zone']['type'] == 'system') {
      this.dt = dt;
    } else if (dt['zone']['type'] == 'iana') {
      this.dt = dt;
      z = dt['zone']['name'];
    } else {
      z = 'UTC';
      this.dt = dt.setZone('UTC').plus({'minutes': dt['offset']});
      originalZone = dt['zone'];
    }

    final intlOpts = {...opts};
    intlOpts['timeZone'] = intlOpts['timeZone'] ?? z;
    dtf = getCachedDTF(intl, intlOpts);
  }

  String format() {
    if (originalZone != null) {
      return formatToParts().map((part) => part['value']).join('');
    }
    return dtf.format(dt.toJSDate());
  }

  List<dynamic> formatToParts() {
    final parts = dtf.formatToParts(dt.toJSDate());
    if (originalZone != null) {
      return parts.map((part) {
        if (part['type'] == 'timeZoneName') {
          final offsetName = originalZone.offsetName(dt['ts'],
              {'locale': dt['locale'], 'format': opts['timeZoneName']});
          return {...part, 'value': offsetName};
        } else {
          return part;
        }
      }).toList();
    }
    return parts.toList();
  }

  dynamic resolvedOptions() {
    return dtf.resolvedOptions();
  }
}

class PolyRelFormatter {
  late dynamic opts;
  dynamic rtf;

  PolyRelFormatter(String intl, bool isEnglish, Map<String, dynamic> opts) {
    opts = {'style': 'long', ...opts};
    if (!isEnglish && hasRelative()) {
      rtf = getCachedRTF(intl, opts);
    }
  }

  String format(int count, String unit) {
    if (rtf != null) {
      return rtf.format(count, unit);
    } else {
      return English.formatRelativeTime(
          unit, count, opts['numeric'], opts['style'] != 'long');
    }
  }

  List<dynamic> formatToParts(int count, String unit) {
    if (rtf != null) {
      return rtf.formatToParts(count, unit);
    } else {
      return [];
    }
  }
}

const fallbackWeekSettings = {
  'firstDay': 1,
  'minimalDays': 4,
  'weekend': [6, 7],
};

class LuxonLocale {
  late String locale;
  late String? numberingSystem;
  late String? outputCalendar;
  late dynamic weekSettings;
  late String intl;
  late Map<String, dynamic> weekdaysCache;
  late Map<String, dynamic> monthsCache;
  late dynamic meridiemCache;
  late Map<dynamic, dynamic> eraCache;
  late String? specifiedLuxonLocale;
  late bool? fastNumbersCached;

  LuxonLocale(
    this.locale,
    this.numberingSystem,
    this.outputCalendar,
    this.weekSettings,
    this.specifiedLuxonLocale,
  ) {
    final parsedLuxonLocaleInfo = parseLuxonLocaleString(locale);
    locale = parsedLuxonLocaleInfo[0];
    numberingSystem = numberingSystem ?? parsedLuxonLocaleInfo[1];
    outputCalendar = outputCalendar ?? parsedLuxonLocaleInfo[2];
    intl = intlConfigString(locale, numberingSystem, outputCalendar);

    weekdaysCache = {'format': {}, 'standalone': {}};
    monthsCache = {'format': {}, 'standalone': {}};
    meridiemCache = null;
    eraCache = {};

    specifiedLuxonLocale = specifiedLuxonLocale;
    fastNumbersCached = null;
  }

  bool get fastNumbers {
    fastNumbersCached ??= supportsFastNumbers(this);
    return fastNumbersCached!;
  }

  String listingMode() {
    final isActuallyEn = isEnglish();
    final hasNoWeirdness =
        (numberingSystem == null || numberingSystem == "latn") &&
            (outputCalendar == null || outputCalendar == "gregory");
    return isActuallyEn && hasNoWeirdness ? "en" : "intl";
  }

  LuxonLocale clone(Map<String, dynamic>? alts) {
    if (alts == null || alts.isEmpty) {
      return this;
    } else {
      return LuxonLocale.create(
        alts['locale'] ?? specifiedLuxonLocale,
        alts['numberingSystem'] ?? numberingSystem,
        alts['outputCalendar'] ?? outputCalendar,
        validateWeekSettings(alts['weekSettings']) ?? weekSettings,
        alts['defaultToEN'] ?? false,
      );
    }
  }

  LuxonLocale redefaultToEN(Map<String, dynamic> alts) {
    return clone({...alts, 'defaultToEN': true});
  }

  LuxonLocale redefaultToSystem(Map<String, dynamic> alts) {
    return clone({...alts, 'defaultToEN': false});
  }

  List<dynamic> months(int length, [bool format = false]) {
    return listStuff(this, length, English.months, () {
      final intlOpts =
          format ? {'month': length, 'day': 'numeric'} : {'month': length};
      final formatStr = format ? 'format' : 'standalone';
      if (monthsCache[formatStr]![length] == null) {
        monthsCache[formatStr]![length] =
            mapMonths((dt) => extract(dt, intlOpts, "month"));
      }
      return monthsCache[formatStr]![length];
    });
  }

  List<dynamic> weekdays(int length, [bool format = false]) {
    return listStuff(this, length, English.weekdays, () {
      final intlOpts = format
          ? {
              'weekday': length,
              'year': 'numeric',
              'month': 'long',
              'day': 'numeric'
            }
          : {'weekday': length};
      final formatStr = format ? 'format' : 'standalone';
      if (weekdaysCache[formatStr]![length] == null) {
        weekdaysCache[formatStr]![length] =
            mapWeekdays((dt) => extract(dt, intlOpts, "weekday"));
      }
      return weekdaysCache[formatStr]![length];
    });
  }

  List<dynamic> meridiems() {
    return listStuff(this, null, () => English.meridiems, () {
      if (meridiemCache == null) {
        final intlOpts = {'hour': 'numeric', 'hourCycle': 'h12'};
        meridiemCache = [
          LuxonDateTime.utc(2016, 11, 13, 9),
          LuxonDateTime.utc(2016, 11, 13, 19)
        ].map((dt) => extract(dt, intlOpts, "dayperiod")).toList();
      }
      return meridiemCache;
    });
  }

  List<dynamic> eras(int length) {
    return listStuff(this, length, English.eras, () {
      final intlOpts = {'era': length};

      if (eraCache[length] == null) {
        eraCache[length] = [
          LuxonDateTime.utc(-40, 1, 1),
          LuxonDateTime.utc(2017, 1, 1)
        ].map((dt) => extract(dt, intlOpts, "era")).toList();
      }

      return eraCache[length];
    });
  }

  dynamic extract(
      LuxonDateTime dt, Map<String, dynamic> intlOpts, String field) {
    final df = dtFormatter(dt, intlOpts);
    final results = df.formatToParts();
    final matching = results.firstWhere(
        (m) => m['type'].toLowerCase() == field.toLowerCase(),
        orElse: () => Map());
    return matching['value'];
  }

  PolyNumberFormatter numberFormatter([Map<String, dynamic>? opts]) {
    return PolyNumberFormatter(
        intl, opts?['forceSimple'] ?? fastNumbers, opts ?? {});
  }

  PolyDateFormatter dtFormatter(LuxonDateTime dt,
      [Map<String, dynamic>? intlOpts]) {
    return PolyDateFormatter(dt, intl, intlOpts ?? {});
  }

  PolyRelFormatter relFormatter([Map<String, dynamic>? opts]) {
    return PolyRelFormatter(intl, isEnglish(), opts ?? {});
  }

  dynamic listFormatter([Map<String, dynamic>? opts]) {
    return getCachedLF(intl, opts ?? {});
  }

  bool isEnglish() {
    return locale == "en" ||
        locale.toLowerCase() == "en-us" ||
        Intl.DateTimeFormat(intl).resolvedOptions().locale.startsWith("en-us");
  }

  dynamic getWeekSettings() {
    if (weekSettings != null) {
      return weekSettings;
    } else if (!hasLuxonLocaleWeekInfo()) {
      return fallbackWeekSettings;
    } else {
      return getCachedWeekInfo(locale);
    }
  }

  int getStartOfWeek() {
    return getWeekSettings()['firstDay'];
  }

  int getMinDaysInFirstWeek() {
    return getWeekSettings()['minimalDays'];
  }

  List<int> getWeekendDays() {
    return List<int>.from(getWeekSettings()['weekend']);
  }

  bool equals(LuxonLocale other) {
    return locale == other.locale &&
        numberingSystem == other.numberingSystem &&
        outputCalendar == other.outputCalendar;
  }

  static LuxonLocale fromOpts(Map<String, dynamic> opts) {
    return LuxonLocale.create(
      opts['locale'],
      opts['numberingSystem'],
      opts['outputCalendar'],
      opts['weekSettings'],
      opts['defaultToEN'] ?? false,
    );
  }

  static LuxonLocale create(String? locale, String? numberingSystem,
      String? outputCalendar, dynamic weekSettings,
      [bool defaultToEN = false]) {
    final specifiedLuxonLocale = locale ?? Settings.defaultLuxonLocale;
    final localeR =
        specifiedLuxonLocale ?? (defaultToEN ? "en-US" : systemLuxonLocale());
    final numberingSystemR = numberingSystem ?? Settings.defaultNumberingSystem;
    final outputCalendarR = outputCalendar ?? Settings.defaultOutputCalendar;
    final weekSettingsR =
        validateWeekSettings(weekSettings) ?? Settings.defaultWeekSettings;
    return LuxonLocale(specifiedLuxonLocale, numberingSystemR, outputCalendarR,
        weekSettingsR, specifiedLuxonLocale);
  }

  static void resetCache() {
    sysLuxonLocaleCache = null;
    intlDTCache = {};
    intlNumCache = {};
    intlRelCache = {};
  }

  static LuxonLocale fromObject(Map<String, dynamic>? opts) {
    return LuxonLocale.create(
      opts?['locale'],
      opts?['numberingSystem'],
      opts?['outputCalendar'],
      opts?['weekSettings'],
    );
  }
}

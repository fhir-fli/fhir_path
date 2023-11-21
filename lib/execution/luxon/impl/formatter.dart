import '../luxon.dart';

class Formatter {
  static final Map<String, dynamic> macroTokenToFormatOpts = {
    'D': Formats.DATE_SHORT,
    'DD': Formats.DATE_MED,
    'DDD': Formats.DATE_FULL,
    'DDDD': Formats.DATE_HUGE,
    't': Formats.TIME_SIMPLE,
    'tt': Formats.TIME_WITH_SECONDS,
    'ttt': Formats.TIME_WITH_SHORT_OFFSET,
    'tttt': Formats.TIME_WITH_LONG_OFFSET,
    'T': Formats.TIME_24_SIMPLE,
    'TT': Formats.TIME_24_WITH_SECONDS,
    'TTT': Formats.TIME_24_WITH_SHORT_OFFSET,
    'TTTT': Formats.TIME_24_WITH_LONG_OFFSET,
    'f': Formats.DATETIME_SHORT,
    'ff': Formats.DATETIME_MED,
    'fff': Formats.DATETIME_FULL,
    'ffff': Formats.DATETIME_HUGE,
    'F': Formats.DATETIME_SHORT_WITH_SECONDS,
    'FF': Formats.DATETIME_MED_WITH_SECONDS,
    'FFF': Formats.DATETIME_FULL_WITH_SECONDS,
    'FFFF': Formats.DATETIME_HUGE_WITH_SECONDS,
  };

  dynamic opts;
  dynamic loc;
  dynamic systemLoc;

  Formatter(this.loc, this.opts);

  static List<Map<String, dynamic>> parseFormat(String fmt) {
    let current;
    var currentFull = '';
    var bracketed = false;
    var splits = [];
    for (var i = 0; i < fmt.length; i++) {
      var c = fmt[i];
      if (c == "'") {
        if (currentFull.isNotEmpty) {
          splits.add({'literal': bracketed || RegExp(r'^\s+$').hasMatch(currentFull), 'val': currentFull});
        }
        current = null;
        currentFull = '';
        bracketed = !bracketed;
      } else if (bracketed) {
        currentFull += c;
      } else if (c == current) {
        currentFull += c;
      } else {
        if (currentFull.isNotEmpty) {
          splits.add({'literal': RegExp(r'^\s+$').hasMatch(currentFull), 'val': currentFull});
        }
        currentFull = c;
        current = c;
      }
    }

    if (currentFull.isNotEmpty) {
      splits.add({'literal': bracketed || RegExp(r'^\s+$').hasMatch(currentFull), 'val': currentFull});
    }

    return splits;
  }

  static dynamic macroTokenToFormatOpts(String token) {
    return macroTokenToFormatOpts[token];
  }

  String formatWithSystemDefault(dt, [opts]) {
    if (systemLoc == null) {
      systemLoc = loc.redefaultToSystem();
    }
    var df = systemLoc.dtFormatter(dt, {...opts, ...this.opts});
    return df.format();
  }

  dynamic dtFormatter(dt, [opts]) {
    return loc.dtFormatter(dt, {...opts, ...this.opts});
  }

  String formatDateTime(dt, [opts]) {
    return dtFormatter(dt, opts).format();
  }

  dynamic formatDateTimeParts(dt, [opts]) {
    return dtFormatter(dt, opts).formatToParts();
  }

  String formatInterval(interval, [opts]) {
    var df = dtFormatter(interval.start, opts);
    return df.dtf.formatRange(interval.start.toJSDate(), interval.end.toJSDate());
  }

  dynamic resolvedOptions(dt, [opts]) {
    return dtFormatter(dt, opts).resolvedOptions();
  }

  String num(n, [p = 0]) {
    if (opts['forceSimple'] != null && opts['forceSimple']) {
      return padStart(n, p);
    }

    var numOpts = {...opts};
    if (p > 0) {
      numOpts['padTo'] = p;
    }

    return loc.numberFormatter(numOpts).format(n);
  }

  String formatDateTimeFromString(dt, fmt) {
    var knownEnglish = loc.listingMode() == 'en';
    var useDateTimeFormatter = loc.outputCalendar != null && loc.outputCalendar != 'gregory';
    String Function(opts, extract) string = (opts, extract) => loc.extract(dt, opts, extract);
    String Function(opts) formatOffset = (opts) {
      if (dt.isOffsetFixed && dt.offset == 0 && opts['allowZ'] != null && opts['allowZ']) {
        return 'Z';
      }
      return dt.isValid ? dt.zone.formatOffset(dt.ts, opts['format']) : '';
    };
    String Function() meridiem = () => knownEnglish ? English.meridiemForDateTime(dt) : string({'hour': 'numeric', 'hourCycle': 'h12'}, 'dayperiod');
    String Function(length, standalone) month = (length, standalone) => knownEnglish ? English.monthForDateTime(dt, length) : string(standalone ? {'month': length} : {'month': length, 'day': 'numeric'}, 'month');
    String Function(length, standalone) weekday = (length, standalone) => knownEnglish ? English.weekdayForDateTime(dt, length) : string(standalone ? {'weekday': length} : {'weekday': length, 'month': 'long', 'day': 'numeric'}, 'weekday');
    String Function(token) maybeMacro = (token) {
      var formatOpts = macroTokenToFormatOpts[token];
      if (formatOpts != null) {
        return formatWithSystemDefault(dt, formatOpts);
      } else {
        return token;
      }
    };
    String Function(token) tokenToString = (token) {
      // Mapping tokens to their corresponding formats...
      // Switch case with token handling...
      // Implement according to token mapping logic...
    };

    return stringifyTokens(parseFormat(fmt), tokenToString);
  }

  String formatDurationFromString(dur, fmt) {
    String Function(token) tokenToField = (token) {
      switch (token[0]) {
        case 'S':
          return 'millisecond';
        case 's':
          return 'second';
        case 'm':
          return 'minute';
        case 'h':
          return 'hour';
        case 'd':
          return 'day';
        case 'w':
          return 'week';
        case 'M':
          return 'month';
        case 'y':
          return 'year';
        default:
          return null;
      }
    };
    String Function(lildur) tokenToString = (lildur) => (token) {
      var mapped = tokenToField(token);
      if (mapped != null) {
        return num(lildur.get(mapped), token.length);
      } else {
        return token;
      }
    };
    var tokens = parseFormat(fmt);
    var realTokens = tokens.fold([], (found, element) => (element['literal']) ? found : found..add(element['val']));
    var collapsed = dur.shiftTo(...realTokens.where((t) => tokenToField(t) != null).map((t) => tokenToField(t)).toList());
    return stringifyTokens(tokens, tokenToString(collapsed));
  }
}

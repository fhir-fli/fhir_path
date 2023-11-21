import 'luxon.dart';

const String INVALID = "Invalid Duration";

final Map<String, Map<String, num>> lowOrderMatrix = {
  'weeks': {
    'days': 7,
    'hours': 7 * 24,
    'minutes': 7 * 24 * 60,
    'seconds': 7 * 24 * 60 * 60,
    'milliseconds': 7 * 24 * 60 * 60 * 1000,
  },
  'days': {
    'hours': 24,
    'minutes': 24 * 60,
    'seconds': 24 * 60 * 60,
    'milliseconds': 24 * 60 * 60 * 1000,
  },
  'hours': {
    'minutes': 60,
    'seconds': 60 * 60,
    'milliseconds': 60 * 60 * 1000,
  },
  'minutes': {
    'seconds': 60,
    'milliseconds': 60 * 1000,
  },
  'seconds': {
    'milliseconds': 1000,
  },
};

final Map<String, Map<String, num>> casualMatrix = {
  'years': {
    'quarters': 4,
    'months': 12,
    'weeks': 52,
    'days': 365,
    'hours': 365 * 24,
    'minutes': 365 * 24 * 60,
    'seconds': 365 * 24 * 60 * 60,
    'milliseconds': 365 * 24 * 60 * 60 * 1000,
  },
  'quarters': {
    'months': 3,
    'weeks': 13,
    'days': 91,
    'hours': 91 * 24,
    'minutes': 91 * 24 * 60,
    'seconds': 91 * 24 * 60 * 60,
    'milliseconds': 91 * 24 * 60 * 60 * 1000,
  },
  'months': {
    'weeks': 4,
    'days': 30,
    'hours': 30 * 24,
    'minutes': 30 * 24 * 60,
    'seconds': 30 * 24 * 60 * 60,
    'milliseconds': 30 * 24 * 60 * 60 * 1000,
  },
  ...lowOrderMatrix,
};

const daysInYearAccurate = 146097.0 / 400;
const daysInMonthAccurate = 146097.0 / 4800;

final Map<String, Map<String, num>> accurateMatrix = {
  'years': {
    'quarters': 4,
    'months': 12,
    'weeks': daysInYearAccurate / 7,
    'days': daysInYearAccurate,
    'hours': daysInYearAccurate * 24,
    'minutes': daysInYearAccurate * 24 * 60,
    'seconds': daysInYearAccurate * 24 * 60 * 60,
    'milliseconds': daysInYearAccurate * 24 * 60 * 60 * 1000,
  },
  'quarters': {
    'months': 3,
    'weeks': daysInYearAccurate / 28,
    'days': daysInYearAccurate / 4,
    'hours': (daysInYearAccurate * 24) / 4,
    'minutes': (daysInYearAccurate * 24 * 60) / 4,
    'seconds': (daysInYearAccurate * 24 * 60 * 60) / 4,
    'milliseconds': (daysInYearAccurate * 24 * 60 * 60 * 1000) / 4,
  },
  'months': {
    'weeks': daysInMonthAccurate / 7,
    'days': daysInMonthAccurate,
    'hours': daysInMonthAccurate * 24,
    'minutes': daysInMonthAccurate * 24 * 60,
    'seconds': daysInMonthAccurate * 24 * 60 * 60,
    'milliseconds': daysInMonthAccurate * 24 * 60 * 60 * 1000,
  },
  ...lowOrderMatrix,
};

final List<String> orderedUnits = [
  'years',
  'quarters',
  'months',
  'weeks',
  'days',
  'hours',
  'minutes',
  'seconds',
  'milliseconds',
];

final List<String> reverseUnits = List.from(orderedUnits.reversed);

LuxonDuration clone(LuxonDuration dur, Map<String, dynamic> alts,
    [bool clear = false]) {
  final conf = LuxonDuration(
    values: clear ? alts['values'] : {...dur.values, ...alts['values']},
    loc: dur.loc.clone(alts['loc']),
    conversionAccuracy: alts['conversionAccuracy'] ?? dur.conversionAccuracy,
    matrix: alts['matrix'] ?? dur.matrix,
  );
  return conf;
}

num durationToMillis(
    Map<String, Map<String, num>> matrix, Map<String, num> vals) {
  num sum = vals['milliseconds'] ?? 0;
  for (final unit in reverseUnits.skip(1)) {
    if (vals[unit] != null &&
        matrix[unit] != null &&
        matrix[unit]!['milliseconds'] != null) {
      sum += vals[unit]! * (matrix[unit]!['milliseconds'] ?? 0);
    }
  }
  return sum;
}

void normalizeValues(
    Map<String, Map<String, num>> matrix, Map<String, num> vals) {
  final factor = durationToMillis(matrix, vals) < 0 ? -1 : 1;

  var previous;
  for (var i = orderedUnits.length - 1; i >= 0; i--) {
    final current = orderedUnits[i];
    if (vals[current] != null &&
        vals[previous] != null &&
        matrix[previous] != null &&
        matrix[previous]![current] != null) {
      final previousVal = vals[previous]! * factor;
      final conv = matrix[current]![previous]!;
      final rollUp = (previousVal / conv).floor();

      vals[current] = (vals[current] ?? 0) + rollUp * factor;
      vals[previous] = (vals[previous] ?? 0) - rollUp * conv * factor;
    }
    previous = current;
  }

  previous = null;
  for (final current in orderedUnits) {
    if (vals[current] != null &&
        vals[previous] != null &&
        matrix[previous] != null &&
        matrix[previous]![current] != null) {
      final fraction = vals[previous]! % 1;
      vals[previous] = (vals[previous] ?? 0) - fraction;
      vals[current] =
          (vals[current] ?? 0) + fraction * (matrix[previous]![current] ?? 0);
    }
    previous = current;
  }
}

Map<String, num> removeZeroes(Map<String, num> vals) {
  final newVals = <String, num>{};
  vals.forEach((key, value) {
    if (value != 0) {
      newVals[key] = value;
    }
  });
  return newVals;
}

class LuxonDuration {
  final Map<String, int> values;
  final LuxonLocale loc;
  final String conversionAccuracy;
  final Invalid? invalid;
  final Map<String, Map<String, num>>? matrix;
  final bool isLuxonDuration;

  const LuxonDuration({
    required this.values,
    this.loc = LuxonLocale(),
    this.conversionAccuracy = 'casual',
    this.invalid,
    this.matrix,
    this.isLuxonDuration = true,
  });

  static LuxonDuration fromMillis(int count, [Map<String, dynamic>? opts]) {
    return LuxonDuration.fromObject({'milliseconds': count}, opts);
  }

  static LuxonDuration fromObject(Map<String, dynamic> obj,
      [Map<String, dynamic>? opts]) {
    return LuxonDuration(
      values:
          normalizeObject(obj, LuxonDuration.normalizeUnit) as Map<String, int>,
      loc: opts == null
          ? LuxonLocale(values: {}, matrix: {})
          : LuxonLocale.fromObject(opts),
      conversionAccuracy: opts?['conversionAccuracy'] ?? 'casual',
      matrix: opts?['matrix'] ?? {},
    );
  }

  static LuxonDuration fromDurationLike(dynamic durationLike) {
    if (isNumber(durationLike)) {
      return LuxonDuration.fromMillis(durationLike);
    } else if (durationLike is LuxonDuration) {
      return durationLike;
    } else if (durationLike is Map<String, dynamic>) {
      return LuxonDuration.fromObject(durationLike);
    } else {
      throw InvalidArgumentError(
          'Unknown duration argument $durationLike of type ${durationLike.runtimeType}');
    }
  }

  static LuxonDuration fromISO(String text, [Map<String, dynamic>? opts]) {
    final parsed = parseISODuration(text).first;
    if (parsed != null) {
      return LuxonDuration.fromObject(parsed, opts);
    } else {
      return invalidDuration(
          'unparsable', 'the input "$text" can\'t be parsed as ISO 8601');
    }
  }

  static LuxonDuration fromISOTime(String text, [Map<String, dynamic>? opts]) {
    final parsed = parseISOTimeOnly(text).first;
    if (parsed != null) {
      return LuxonDuration.fromObject(parsed, opts);
    } else {
      return invalidDuration(
          'unparsable', 'the input "$text" can\'t be parsed as ISO 8601');
    }
  }

  static LuxonDuration invalidDuration(String reason, [String? explanation]) {
    if (reason.isEmpty) {
      throw InvalidArgumentError(
          'need to specify a reason the Duration is invalid');
    }

    final Invalid invalid =
        reason is Invalid ? reason as Invalid : Invalid(reason, explanation);

    if (Settings.throwOnInvalid ?? false) {
      throw InvalidDurationError(invalid);
    } else {
      return LuxonDuration(values: {}, matrix: {}, invalid: invalid);
    }
  }

  static String normalizeUnit(String? unit) {
    final normalized = {
      'year': 'years',
      'years': 'years',
      'quarter': 'quarters',
      'quarters': 'quarters',
      'month': 'months',
      'months': 'months',
      'week': 'weeks',
      'weeks': 'weeks',
      'day': 'days',
      'days': 'days',
      'hour': 'hours',
      'hours': 'hours',
      'minute': 'minutes',
      'minutes': 'minutes',
      'second': 'seconds',
      'seconds': 'seconds',
      'millisecond': 'milliseconds',
      'milliseconds': 'milliseconds',
    }[unit?.toLowerCase() ?? ''];

    if (normalized == null) {
      throw InvalidUnitError(unit);
    }

    return normalized;
  }

  static bool isDuration(dynamic o) {
    return (o != null && o.isLuxonDuration);
  }

  String? get locale => isValid ? loc.locale : null;

  String? get numberingSystem => isValid ? loc.numberingSystem : null;

  String toFormat(String fmt, [Map<String, dynamic>? opts]) {
    final fmtOpts = {
      ...(opts ?? {}),
      'floor': opts?['round'] != false && opts?['floor'] != false,
    };
    return isValid
        ? Formatter(loc, fmtOpts).formatDurationFromString(this, fmt)
        : INVALID;
  }

  String toHuman([Map<String, dynamic>? opts]) {
    if (!isValid) return INVALID;

    final l = orderedUnits.map((unit) {
      final val = values[unit];
      if (val == null) {
        return null;
      }
      return loc.numberFormatter(
        {
          'style': 'unit',
          'unitDisplay': 'long',
          ...(opts ?? {}),
          'unit': unit.substring(0, unit.length - 1)
        },
      ).format(val);
    }).where((n) => n != null);

    return loc.listFormatter({
      'type': 'conjunction',
      'style': opts?['listStyle'] ?? 'narrow',
      ...(opts ?? {})
    }).format(l);
  }

  Map<String, int> toObject() {
    if (!isValid) return {};
    return {...values};
  }

  String toISO() {
    if (!isValid) return INVALID;

    return 'P${listUnits().map((unit) {
      return '${values[unit] ?? 0}${unit.substring(0, unit.length - 1)}';
    }).join('T')}';
  }

  String toString() => toISO();

  bool get isValid => invalid == null;

  List<String> listUnits() {
    return orderedUnits;
  }

  List<String> listFields() {
    return orderedUnits
        .map((unit) => unit.substring(0, unit.length - 1))
        .toList();
  }

  LuxonDuration normalize() {
    if (!isValid) return this;
    final vals = {...values};

    final conversionValues = {
      'milliseconds': 1000,
      'seconds': 60,
      'minutes': 60,
      'hours': 24,
      'days': 30, // Example values for conversion, adjust as needed
      'months': 12,
    };

    while (true) {
      var found = false;
      for (final k in [
        'milliseconds',
        'seconds',
        'minutes',
        'hours',
        'days',
        'months'
      ]) {
        final prev = vals[k] ?? 0;
        if (prev != 0) {
          final unit = k; // No need to normalize the unit name
          final scalar = conversionValues[k]!;
          final durationToShift = (prev / scalar).floor();
          vals[unit] = (vals[unit] ?? 0) + durationToShift;
          vals[k] = prev - (durationToShift * scalar);
          found = true;
        }
      }
      if (!found) {
        break;
      }
    }

    return LuxonDuration(
      values: vals,
      loc: loc,
      conversionAccuracy: conversionAccuracy,
      matrix: matrix,
    );
  }
}

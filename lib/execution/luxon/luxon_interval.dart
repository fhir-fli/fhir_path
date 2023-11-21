import 'luxon.dart';

class Interval {
  static const INVALID = "Invalid Interval";

  final DateTime s;
  final DateTime e;
  final Invalid? invalid;
  final bool isLuxonInterval = true;

  Interval({required this.s, required this.e, this.invalid});

  static Interval invalid(String reason, [String? explanation]) {
    if (reason.isEmpty) {
      throw ArgumentError("need to specify a reason the Interval is invalid");
    }

    final invalid = reason is Invalid ? reason : Invalid(reason, explanation);
    
    if (Settings.throwOnInvalid) {
      throw Exception("InvalidIntervalError: $invalid");
    } else {
      return Interval(invalid: invalid);
    }
  }

  static Interval fromDateTimes(start, end) {
    final builtStart = friendlyDateTime(start);
    final builtEnd = friendlyDateTime(end);

    final validateError = validateStartEnd(builtStart, builtEnd);

    if (validateError == null) {
      return Interval(s: builtStart, e: builtEnd);
    } else {
      return validateError as Interval;
    }
  }

  static Interval after(start, duration) {
    final dur = Duration.fromDurationLike(duration);
    final dt = friendlyDateTime(start);
    return Interval.fromDateTimes(dt, dt.add(dur));
  }

  static Interval before(end, duration) {
    final dur = Duration.fromDurationLike(duration);
    final dt = friendlyDateTime(end);
    return Interval.fromDateTimes(dt.subtract(dur), dt);
  }

  static Interval fromISO(String text, [opts]) {
    final List<String> parts = (text ?? "").split("/", 2);
    if (parts.length == 2) {
      DateTime? start, end;
      try {
        start = DateTime.fromISO(parts[0], opts);
      } catch (e) {}

      try {
        end = DateTime.fromISO(parts[1], opts);
      } catch (e) {}

      if (start != null && end != null) {
        return Interval.fromDateTimes(start, end);
      }

      if (start != null) {
        final dur = Duration.fromISO(parts[1], opts);
        if (dur.isValid) {
          return Interval.after(start, dur);
        }
      } else if (end != null) {
        final dur = Duration.fromISO(parts[0], opts);
        if (dur.isValid) {
          return Interval.before(end, dur);
        }
      }
    }
    return Interval.invalid("unparsable", 'the input "$text" can\'t be parsed as ISO 8601');
  }

  static bool isInterval(o) {
    return (o != null && o.isLuxonInterval) ?? false;
  }

  bool get isValid {
    return invalidReason == null;
  }

  String? get invalidReason {
    return invalid?.reason;
  }

  String? get invalidExplanation {
    return invalid?.explanation;
  }

  double length([String unit = "milliseconds"]) {
    return isValid ? toDuration(unit).get(unit) : double.nan;
  }

  double count(String unit, [opts]) {
    if (!isValid) return double.nan;
    final start = this.start.startOf(unit, opts);
    var end = opts?.useLocaleWeeks ?? false ? this.end.reconfigure(locale: start.locale) : this.end;
    end = end.startOf(unit, opts);
    return (end.diff(start, unit).get(unit) + ((end != this.end) ? 1 : 0)).toDouble();
  }

  bool hasSame(unit) {
    return isValid ? (isEmpty() || (e.subtract(Duration(milliseconds: 1)).hasSame(s, unit))) : false;
  }

  bool isEmpty() {
    return s == e;
  }

  bool isAfter(dateTime) {
    return isValid ? s.isAfter(dateTime) : false;
  }

  bool isBefore(dateTime) {
    return isValid ? e.isBefore(dateTime) : false;
  }

  bool contains(dateTime) {
    return isValid ? (s.isBefore(dateTime) && e.isAfter(dateTime)) : false;
  }

  Interval set({start, end}) {
    return !isValid ? this : Interval.fromDateTimes(start ?? s, end ?? e);
  }


  List<Interval> splitBy(Duration duration) {
    final dur = Duration.fromDurationLike(duration);

    if (!isValid || !dur.isValid || dur.inMilliseconds == 0) {
      return [];
    }

    var s = this.s;
    var idx = 1;
    DateTime next;
    final results = [];

    while (s.isBefore(this.e)) {
      final added = this.start.add(Duration(milliseconds: dur.inMilliseconds * idx));
      next = added.isAfter(this.e) ? this.e : added;
      results.add(Interval.fromDateTimes(s, next));
      s = next;
      idx += 1;
    }

    return results;
  }

  List<Interval> divideEqually(int numberOfParts) {
    if (!isValid) return [];
    return splitBy(Duration(milliseconds: (length() / numberOfParts).floor()));
  }

  bool overlaps(Interval other) {
    return this.e.isAfter(other.s) && this.s.isBefore(other.e);
  }

  bool abutsStart(Interval other) {
    if (!isValid) return false;
    return this.e.isAtSameMomentAs(other.s);
  }

  bool abutsEnd(Interval other) {
    if (!isValid) return false;
    return other.e.isAtSameMomentAs(this.s);
  }

  bool engulfs(Interval other) {
    if (!isValid) return false;
    return this.s.isBeforeOrAtSameMomentAs(other.s) && this.e.isAfterOrAtSameMomentAs(other.e);
  }

  bool equals(Interval other) {
    if (!isValid || !other.isValid) {
      return false;
    }
    return this.s.isAtSameMomentAs(other.s) && this.e.isAtSameMomentAs(other.e);
  }

  Interval? intersection(Interval other) {
    if (!isValid) return this;
    final s = this.s.isAfter(other.s) ? this.s : other.s;
    final e = this.e.isBefore(other.e) ? this.e : other.e;

    if (s.isAtSameMomentAs(e) || s.isAfter(e)) {
      return null;
    } else {
      return Interval.fromDateTimes(s, e);
    }
  }

  Interval union(Interval other) {
    if (!isValid) return this;
    final s = this.s.isBefore(other.s) ? this.s : other.s;
    final e = this.e.isAfter(other.e) ? this.e : other.e;
    return Interval.fromDateTimes(s, e);
  }

  static List<Interval> merge(List<Interval> intervals) {
    final found = <Interval>[];
    Interval? finalInterval;
    intervals.sort((a, b) => a.s.compareTo(b.s)).forEach((item) {
      if (finalInterval == null) {
        finalInterval = item;
      } else if (finalInterval!.overlaps(item) || finalInterval!.abutsStart(item)) {
        finalInterval = finalInterval!.union(item);
      } else {
        found.add(finalInterval!);
        finalInterval = item;
      }
    });
    if (finalInterval != null) {
      found.add(finalInterval!);
    }
    return found;
  }

  static List<Interval> xor(List<Interval> intervals) {
    DateTime? start;
    var currentCount = 0;
    final results = <Interval>[];
    final ends = intervals.map((i) => [
          {'time': i.s, 'type': 's'},
          {'time': i.e, 'type': 'e'}
        ]).expand((i) => i).toList();
    final arr = ends..sort((a, b) => a['time'].compareTo(b['time']));

    for (final i in arr) {
      currentCount += i['type'] == 's' ? 1 : -1;

      if (currentCount == 1) {
        start = i['time'];
      } else {
        if (start != null && start != i['time']) {
          results.add(Interval.fromDateTimes(start, i['time']));
        }

        start = null;
      }
    }

    return merge(results);
  }

  List<Interval?> difference(List<Interval> intervals) {
    return xor([this].followedBy(intervals))
        .map((i) => this.intersection(i))
        .where((i) => i != null && !i.isEmpty)
        .toList();
  }

  String toString() {
    if (!isValid) return INVALID;
    return '[${this.s.toISO()} – ${this.e.toISO()})';
  }

  String toStringRepresentation() {
    if (this.isValid) {
      return 'Interval { start: ${this.s.toISO()}, end: ${this.e.toISO()} }';
    } else {
      return 'Interval { Invalid, reason: ${this.invalidReason} }';
    }
  }

  String toLocaleString([Object formatOpts = Formats.DATE_SHORT, Object opts = const {}]) {
    return this.isValid
        ? Formatter.create(this.s.loc.clone(opts), formatOpts).formatInterval(this)
        : INVALID;
  }

  String toISO([Object opts]) {
    if (!this.isValid) return INVALID;
    return '${this.s.toISO(opts)}/${this.e.toISO(opts)}';
  }

  String toISODate() {
    if (!this.isValid) return INVALID;
    return '${this.s.toISODate()}/${this.e.toISODate()}';
  }

  String toISOTime([Object opts]) {
    if (!this.isValid) return INVALID;
    return '${this.s.toISOTime(opts)}/${this.e.toISOTime(opts)}';
  }

  String toFormattedString(String dateFormat, [Object opts = const {'separator': ' – '}]) {
    if (!this.isValid) return INVALID;
    return '${this.s.toFormattedString(dateFormat)}${opts['separator']}${this.e.toFormattedString(dateFormat)}';
  }

  Duration toDuration([dynamic unit = 'milliseconds', Object opts = const {}]) {
    if (!this.isValid) {
      return Duration.invalid(this.invalidReason);
    }
    return this.e.difference(this.s, unit, opts);
  }

  Interval mapEndpoints(DateTime Function(DateTime) mapFn) {
    return Interval.fromDateTimes(mapFn(this.s), mapFn(this.e));
  }
}

}

validateStartEnd(start, end) {
  if (start == null || !(start is DateTime) || !start.isValid) {
    return Interval.invalid("missing or invalid start");
  } else if (end == null || !(end is DateTime) || !end.isValid) {
    return Interval.invalid("missing or invalid end");
  } else if (end.isBefore(start)) {
    return Interval.invalid(
        "end before start",
        'The end of an interval must be after its start, but you had start=${start.toISO()} and end=${end.toISO()}');
  } else {
    return null;
  }
}

friendlyDateTime(dt) {
  // Implement the logic for parsing DateTime from various types (like String or DateTime)
  // Return a DateTime instance
}


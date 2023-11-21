int dayDiff(DateTime earlier, DateTime later) {
  int utcDayStart(DateTime dt) {
    return DateTime.utc(dt.year, dt.month, dt.day).millisecondsSinceEpoch;
  }

  int ms = utcDayStart(later) - utcDayStart(earlier);
  return (ms / (1000 * 60 * 60 * 24)).floor();
}

List<dynamic> highOrderDiffs(
    DateTime cursor, DateTime later, List<String> units) {
  int dayDiff(DateTime earlier, DateTime later) {
    int utcDayStart(DateTime dt) {
      return DateTime.utc(dt.year, dt.month, dt.day).millisecondsSinceEpoch;
    }

    int ms = utcDayStart(later) - utcDayStart(earlier);
    return (ms / (1000 * 60 * 60 * 24)).floor();
  }

  final differs = [
    ["years", (DateTime a, DateTime b) => b.year - a.year],
    [
      "quarters",
      (DateTime a, DateTime b) =>
          b.month ~/ 3 - a.month ~/ 3 + (b.year - a.year) * 4
    ],
    [
      "months",
      (DateTime a, DateTime b) => b.month - a.month + (b.year - a.year) * 12
    ],
    [
      "weeks",
      (DateTime a, DateTime b) {
        final days = dayDiff(a, b);
        return (days - (days % 7)) ~/ 7;
      },
    ],
    ["days", dayDiff],
  ];

  final results = {};
  final earlier = cursor;
  String? lowestOrder;
  DateTime? highWater;

  for (final pair in differs) {
    final unit = pair[0];
    final differ = pair[1];

    if (units.contains(unit)) {
      lowestOrder = unit;
      results[unit] = differ(cursor, later);
      highWater = earlier.add(Duration(days: results[unit]));

      if (highWater.isAfter(later)) {
        results[unit]--;
        cursor = earlier.add(Duration(days: results[unit]));

        if (cursor.isAfter(later)) {
          highWater = cursor;
          results[unit]--;
          cursor = earlier.add(Duration(days: results[unit]));
        }
      } else {
        cursor = highWater;
      }
    }
  }

  return [cursor, results, highWater, lowestOrder];
}

Duration diff(earlier, later, List<String> units,
    [Map<String, dynamic>? opts]) {
  final data = highOrderDiffs(earlier, later, units);
  DateTime cursor = data[0];
  Map<String, dynamic> results = data[1];
  DateTime? highWater = data[2];
  String? lowestOrder = data[3];

  final remainingMillis =
      later.millisecondsSinceEpoch - cursor.millisecondsSinceEpoch;

  final lowerOrderUnits = units
      .where((u) => ["hours", "minutes", "seconds", "milliseconds"].contains(u))
      .toList();

  if (lowerOrderUnits.isEmpty) {
    if (highWater != null && highWater.isBefore(later)) {
      highWater = cursor.add(const Duration(days: 1));
    }

    if (highWater != cursor) {
      results[lowestOrder!] = (results[lowestOrder] ?? 0) +
          remainingMillis / (highWater.difference(cursor).inMilliseconds);
    }
  }

  final duration = Duration(
      milliseconds: Duration.millisecondsPerDay * (results["days"] ?? 0));

  if (lowerOrderUnits.isNotEmpty) {
    return Duration(milliseconds: remainingMillis)
        .shiftTo(units: lowerOrderUnits)
        .add(duration);
  } else {
    return duration;
  }
}

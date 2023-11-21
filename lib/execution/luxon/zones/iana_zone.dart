import 'package:intl/intl.dart';

import '../luxon.dart';

Map<String, DateFormat> dtfCache = {};

DateFormat makeDTF(String zone) {
  if (dtfCache[zone] == null) {
    dtfCache[zone] = DateFormat('y-MM-dd HH:mm:ss', 'en_US');
  }
  return dtfCache[zone]!;
}

const typeToPos = {
  'year': 0,
  'month': 1,
  'day': 2,
  'era': 3,
  'hour': 4,
  'minute': 5,
  'second': 6,
};

List<int?> hackyOffset(DateFormat dtf, DateTime date) {
  String formatted = dtf.format(date).replaceAll('\u200E', "");

  RegExp regex = RegExp(
    r'(\d+)\/(\d+)\/(\d+) (AD|BC),? (\d+):(\d+):(\d+)',
    caseSensitive: false,
  );
  RegExpMatch? parsed = regex.firstMatch(formatted);

  if (parsed != null && parsed.groupCount == 7) {
    List<String?> matches = List.generate(parsed.groupCount, (index) {
      return parsed.group(index);
    });

    List<int?> parsedIntegers = matches.map((match) {
      if (match != null && int.tryParse(match) != null) {
        return int.parse(match);
      }
      return null;
    }).toList();

    return parsedIntegers;
  }

  // If parsing fails or the match count is incorrect, return a default list with null values
  return List.generate(7, (_) => null);
}

List<int?> partsOffset(DateFormat dtf, DateTime date) {
  final formatted = dtf.format(date);
  final filled = List<int?>.filled(7, null);
  final parts = formatted.split(RegExp(r'[^\d]+'));
  if (parts.length == 7) {
    for (var i = 0; i < parts.length; i++) {
      filled[i] = int.tryParse(parts[i]);
    }
  }
  return filled;
}

class IANAZone implements Zone {
  late String zoneName;
  bool valid = false;

  IANAZone(this.zoneName) {
    valid = IANAZone.isValidZone(zoneName);
  }

  static void resetCache() {
    dtfCache = {};
  }

  static bool isValidSpecifier(String s) {
    return isValidZone(s);
  }

  static bool isValidZone(String zone) {
    if (zone.isEmpty) {
      return false;
    }
    try {
      DateTime.now().toLocal().timeZoneOffset;
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  String get type => 'iana';

  @override
  String get name => zoneName;

  @override
  bool get isUniversal => false;

  @override
  String? offsetName(int ts,
      [Map<String, dynamic>? opts, String format = '', String locale = '']) {
    return parseZoneInfo(ts, format, locale, zoneName);
  }

  @override
  String formatOffset(int ts, String format) {
    return formatOffset(offset(ts), format);
  }

// These methods have already been defined earlier in the conversation
// You can find the updated implementation in the previous responses

  int offset(int ts) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(ts);

    if (date.isBefore(DateTime.fromMillisecondsSinceEpoch(0)) ||
        date.isAfter(DateTime.fromMillisecondsSinceEpoch(8640000000000000))) {
      return double.nan.toInt();
    }

    DateFormat dtf = makeDTF(name);
    List<int?> parts = dtf.format(date).contains(',')
        ? partsOffset(dtf, date)
        : hackyOffset(dtf, date);

    int year = parts[0]!;
    int month = parts[1]!;
    int day = parts[2]!;
    String adOrBc = parts[3] == 'AD' ? 'AD' : 'BC';
    int hour = parts[4]!;
    int minute = parts[5]!;
    int second = parts[6]!;

    if (adOrBc == 'BC') {
      year = -year.abs() + 1;
    }

    int adjustedHour = hour == 24 ? 0 : hour;

    DateTime asUTC = DateTime.utc(
      year,
      month,
      day,
      adjustedHour,
      minute,
      second,
    );

    int asTS = date.millisecondsSinceEpoch;
    int over = asTS % 1000;
    asTS -= over >= 0 ? over : 1000 + over;

    return (asUTC.millisecondsSinceEpoch - asTS) ~/ (60 * 1000);
  }

  @override
  bool equals(otherZone) {
    return otherZone.type == 'iana' && otherZone.name == zoneName;
  }

  @override
  bool get isValid => valid;

  @override
  // TODO: implement ianaName
  String get ianaName => throw UnimplementedError();
}

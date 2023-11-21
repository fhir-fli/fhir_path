import 'luxon.dart';

abstract class Zone {
  String get type {
    throw ZoneIsAbstractError();
  }

  String get name {
    throw ZoneIsAbstractError();
  }

  String get ianaName => name;

  bool get isUniversal {
    throw ZoneIsAbstractError();
  }

  String? offsetName(int ts, Map<String, dynamic> opts) {
    throw ZoneIsAbstractError();
  }

  String formatOffset(int ts, String format) {
    throw ZoneIsAbstractError();
  }

  int? offset(int ts) {
    throw ZoneIsAbstractError();
  }

  bool equals(Zone otherZone) {
    throw ZoneIsAbstractError();
  }

  bool get isValid {
    throw ZoneIsAbstractError();
  }
}

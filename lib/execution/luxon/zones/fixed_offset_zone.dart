import '../luxon.dart';

class FixedOffsetZone implements Zone {
  late int fixed;

  FixedOffsetZone(this.fixed);

  static FixedOffsetZone? singleton;

  static FixedOffsetZone get utcInstance {
    if (singleton == null) {
      singleton = FixedOffsetZone(0);
    }
    return singleton!;
  }

  static FixedOffsetZone instance(int offset) {
    return offset == 0 ? utcInstance : FixedOffsetZone(offset);
  }

  static FixedOffsetZone? parseSpecifier(String s) {
    if (s.isNotEmpty) {
      final RegExp regex =
          RegExp(r'^utc(?:([+-]\d{1,2})(?::(\d{2}))?)?$', caseSensitive: false);
      final RegExpMatch? r = regex.firstMatch(s);
      if (r != null) {
        final String? firstGroup = r.group(1);
        final String? secondGroup = r.group(2);

        if (firstGroup != null && secondGroup != null) {
          return FixedOffsetZone(signedOffset(firstGroup, secondGroup));
        } else if (firstGroup != null) {
          return FixedOffsetZone(signedOffset(firstGroup, ''));
        }
      }
    }
    return null;
  }

  @override
  String get type => 'fixed';

  @override
  String get name => fixed == 0 ? 'UTC' : 'UTC${formatOffset(fixed, "narrow")}';

  String get ianaName {
    if (fixed == 0) {
      return 'Etc/UTC';
    } else {
      return 'Etc/GMT${formatOffset(-fixed, "narrow")}';
    }
  }

  @override
  String offsetName([int? ts, Map<String, dynamic>? opts]) => name;

  @override
  String formatOffset(int ts, String format) => formatOffset(fixed, format);

  @override
  bool get isUniversal => true;

  @override
  int offset([int? ts]) => fixed;

  @override
  bool equals(otherZone) =>
      otherZone is FixedOffsetZone && otherZone.fixed == fixed;

  @override
  bool get isValid => true;
}

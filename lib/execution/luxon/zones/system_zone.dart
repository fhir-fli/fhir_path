import '../luxon.dart';

class SystemZone implements Zone {
  static SystemZone? _instance;

  static SystemZone get instance {
    _instance ??= SystemZone._();
    return _instance!;
  }

  SystemZone._();

  @override
  String get type => "system";

  @override
  String get name {
    return DateTime.now().timeZoneName;
  }

  @override
  bool get isUniversal => false;

  @override
  String? offsetName(int ts, Map<String, dynamic> opts) {
    return parseZoneInfo(ts, opts['format'], opts['locale']);
  }

  @override
  String formatOffset(int ts, String format) {
    return formatOffset(offset(ts) ?? 0, format);
  }

  @override
  int? offset(int ts) {
    return -DateTime.fromMillisecondsSinceEpoch(ts).timeZoneOffset.inMinutes;
  }

  @override
  bool equals(Zone otherZone) {
    return otherZone.type == "system";
  }

  @override
  bool get isValid => true;

  @override
  // TODO: implement ianaName
  String get ianaName => throw UnimplementedError();
}

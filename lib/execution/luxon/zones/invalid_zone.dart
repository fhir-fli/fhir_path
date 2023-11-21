import '../luxon.dart';

class InvalidZone implements Zone {
  final String zoneName;

  InvalidZone(this.zoneName);

  @override
  String get type => "invalid";

  @override
  String get name => zoneName;

  @override
  bool get isUniversal => false;

  @override
  String? offsetName(int ts, Map<String, dynamic> opts) {
    return null;
  }

  @override
  String formatOffset(int ts, String format) {
    return "";
  }

  @override
  int? offset(int ts) {
    return null;
  }

  @override
  bool equals(Zone otherZone) {
    return false;
  }

  @override
  bool get isValid => false;

  @override
  // TODO: implement ianaName
  String get ianaName => throw UnimplementedError();
}

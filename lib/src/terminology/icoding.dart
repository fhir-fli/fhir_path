import 'package:fhir_node/fhir_node.dart';

/// The coding-shaped fields of a value, when it has them: a Coding's four,
/// or a Quantity's system and code.
class ICoding {
  /// A coding view.
  ICoding({this.system, this.version, this.code, this.display});

  /// The system.
  String? system;

  /// The version.
  String? version;

  /// The code.
  String? code;

  /// The display.
  String? display;

  /// [b] as a coding view, or null when it is not a Coding or a Quantity.
  static ICoding? getAsICoding(FhirNode? b) {
    if (b == null) return null;
    if (b.hasType(['Coding'])) {
      return ICoding(
        system: b.getChildByName('system')?.primitiveValue,
        version: b.getChildByName('version')?.primitiveValue,
        code: b.getChildByName('code')?.primitiveValue,
        display: b.getChildByName('display')?.primitiveValue,
      );
    }
    if (b.hasType(['Quantity'])) {
      return ICoding(
        system: b.getChildByName('system')?.primitiveValue,
        code: b.getChildByName('code')?.primitiveValue,
      );
    }
    return null;
  }

  /// Whether a system is set.
  bool get hasSystem => system != null;

  /// Whether a version is set.
  bool get hasVersion => version != null;

  /// Whether a code is set.
  bool get hasCode => code != null;

  /// Whether a display is set.
  bool get hasDisplay => display != null;
}

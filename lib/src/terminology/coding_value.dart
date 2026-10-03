import 'package:fhir_node/fhir_node.dart';

/// A Coding's four fields, read out of any model's node or JSON. The
/// terminology layer passes these around instead of a version's Coding
/// class.
class CodingValue {
  /// A coding.
  const CodingValue({this.system, this.version, this.code, this.display});

  /// From a Coding node of any model.
  factory CodingValue.fromNode(FhirNode node) => CodingValue(
        system: node.getChildByName('system')?.primitiveValue,
        version: node.getChildByName('version')?.primitiveValue,
        code: node.getChildByName('code')?.primitiveValue,
        display: node.getChildByName('display')?.primitiveValue,
      );

  /// From Coding JSON.
  factory CodingValue.fromJson(Map<String, dynamic> json) => CodingValue(
        system: json['system'] as String?,
        version: json['version'] as String?,
        code: json['code'] as String?,
        display: json['display'] as String?,
      );

  /// Coding.system.
  final String? system;

  /// Coding.version.
  final String? version;

  /// Coding.code.
  final String? code;

  /// Coding.display.
  final String? display;

  /// Coding JSON, without null fields.
  Map<String, dynamic> toJson() => {
        if (system != null) 'system': system,
        if (version != null) 'version': version,
        if (code != null) 'code': code,
        if (display != null) 'display': display,
      };

  @override
  String toString() => '$system#$code';
}

/// A CodeableConcept's codings and text, read out of any model's node.
class ConceptValue {
  /// A concept.
  const ConceptValue({this.coding = const [], this.text});

  /// From a CodeableConcept node of any model.
  factory ConceptValue.fromNode(FhirNode node) => ConceptValue(
        coding:
            node.getChildrenByName('coding').map(CodingValue.fromNode).toList(),
        text: node.getChildByName('text')?.primitiveValue,
      );

  /// From CodeableConcept JSON.
  factory ConceptValue.fromJson(Map<String, dynamic> json) => ConceptValue(
        coding: [
          for (final c in (json['coding'] as List<dynamic>?) ?? const [])
            CodingValue.fromJson(c as Map<String, dynamic>),
        ],
        text: json['text'] as String?,
      );

  /// CodeableConcept.coding.
  final List<CodingValue> coding;

  /// CodeableConcept.text.
  final String? text;

  /// CodeableConcept JSON.
  Map<String, dynamic> toJson() => {
        if (coding.isNotEmpty) 'coding': [for (final c in coding) c.toJson()],
        if (text != null) 'text': text,
      };
}

/// A code system concept's definition, as a validation answers it: the
/// code, its display and its definition text.
class ConceptDefinition {
  /// A concept definition.
  const ConceptDefinition({required this.code, this.display, this.definition});

  /// From a CodeSystem.concept node of any model.
  factory ConceptDefinition.fromNode(FhirNode node) => ConceptDefinition(
        code: node.getChildByName('code')?.primitiveValue ?? '',
        display: node.getChildByName('display')?.primitiveValue,
        definition: node.getChildByName('definition')?.primitiveValue,
      );

  /// CodeSystem.concept.code.
  final String code;

  /// CodeSystem.concept.display.
  final String? display;

  /// CodeSystem.concept.definition.
  final String? definition;
}

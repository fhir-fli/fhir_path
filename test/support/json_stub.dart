import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/fhir_path.dart';

import 'stub_model.dart';

/// A [StubNode] tree built from FHIR JSON, for tests of the terminology and
/// context layer that need real resource shapes without a model: a map is
/// an element whose type is its `resourceType` or the key it hangs under, a
/// list is a repeat, a primitive is its string. Enough to walk a ValueSet,
/// a CodeSystem or a StructureDefinition by element name.
StubNode nodeFromJson(Map<String, dynamic> json, [String? type]) {
  final children = <String, List<StubNode>>{};
  for (final entry in json.entries) {
    if (entry.key == 'resourceType') continue;
    final value = entry.value;
    final items = value is List ? value : [value];
    children[entry.key] = [
      for (final item in items)
        if (item is Map<String, dynamic>)
          nodeFromJson(item, entry.key)
        else
          StubNode(_primitiveType(item), value: item.toString()),
    ];
  }
  return StubNode(
    json['resourceType'] as String? ?? type ?? 'Element',
    children: children,
  );
}

String _primitiveType(Object? v) => switch (v) {
      bool _ => 'boolean',
      int _ => 'integer',
      num _ => 'decimal',
      _ => 'string',
    };

/// A binding over the stub model, for the worker context's tests.
class StubBinding extends FhirModelBinding {
  const StubBinding();

  @override
  String get fhirVersion => '0.0.0';

  @override
  Map<String, TypeHierarchyEntry> get typeHierarchy => const {
        'Element': TypeHierarchyEntry(
          name: 'Element',
          type: 'Element',
          kind: 'complex-type',
          url: 'http://hl7.org/fhir/StructureDefinition/Element',
          derivation: 'specialization',
          isAbstract: true,
        ),
        'Quantity': TypeHierarchyEntry(
          name: 'Quantity',
          type: 'Quantity',
          kind: 'complex-type',
          url: 'http://hl7.org/fhir/StructureDefinition/Quantity',
          base: 'Element',
          derivation: 'specialization',
        ),
        'Age': TypeHierarchyEntry(
          name: 'Age',
          type: 'Quantity',
          kind: 'complex-type',
          url: 'http://hl7.org/fhir/StructureDefinition/Age',
          base: 'Quantity',
          derivation: 'constraint',
        ),
        'string': TypeHierarchyEntry(
          name: 'string',
          type: 'string',
          kind: 'primitive-type',
          url: 'http://hl7.org/fhir/StructureDefinition/string',
          base: 'Element',
          derivation: 'specialization',
        ),
        'code': TypeHierarchyEntry(
          name: 'code',
          type: 'code',
          kind: 'primitive-type',
          url: 'http://hl7.org/fhir/StructureDefinition/code',
          base: 'string',
          derivation: 'specialization',
        ),
        'Resource': TypeHierarchyEntry(
          name: 'Resource',
          type: 'Resource',
          kind: 'resource',
          url: 'http://hl7.org/fhir/StructureDefinition/Resource',
          derivation: 'specialization',
          isAbstract: true,
        ),
        'Patient': TypeHierarchyEntry(
          name: 'Patient',
          type: 'Patient',
          kind: 'resource',
          url: 'http://hl7.org/fhir/StructureDefinition/Patient',
          base: 'Resource',
          derivation: 'specialization',
        ),
      };

  @override
  IFhirValueFactory get valueFactory => StubValueFactory();

  @override
  FhirNode fromJson(Map<String, dynamic> json) => nodeFromJson(json);

  @override
  Map<String, dynamic> toJson(FhirNode node) => _toJson(node as StubNode);

  Map<String, dynamic> _toJson(StubNode node) => {
        if (node.isResource) 'resourceType': node.type,
        for (final e in node.children.entries)
          e.key: e.value.length == 1 &&
                  e.key != 'coding' &&
                  e.key != 'concept' &&
                  e.key != 'contains' &&
                  e.key != 'include' &&
                  e.key != 'exclude'
              ? _value(e.value.single)
              : [for (final c in e.value) _value(c)],
      };

  Object? _value(StubNode n) => n.isPrimitive ? n.value : _toJson(n);

  @override
  bool isModelType(String typeName) => typeHierarchy.containsKey(typeName);

  @override
  bool isSystemValue(FhirNode node) => !node.isResource && node.isPrimitive;

  @override
  bool isSystemPrimitive(FhirNode node) => node.isPrimitive;

  @override
  CodingValue? asCoding(FhirNode node) =>
      node.hasType(['Coding']) ? CodingValue.fromNode(node) : null;

  @override
  ConceptValue? asCodeableConcept(FhirNode node) =>
      node.hasType(['CodeableConcept']) ? ConceptValue.fromNode(node) : null;
}

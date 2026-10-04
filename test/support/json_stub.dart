import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/fhir_path.dart';

import 'stub_model.dart';

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
  FhirNode fromJson(Map<String, dynamic> json) => JsonNode.resource(json);

  @override
  Map<String, dynamic> toJson(FhirNode node) => (node as JsonNode).json;

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

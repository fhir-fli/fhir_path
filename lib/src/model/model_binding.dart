import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/fhir_path.dart';

/// One core FHIR type's place in the type hierarchy, as its
/// StructureDefinition states it: the per-version bindings generate a table
/// of these from profiles-types.json and profiles-resources.json, so the
/// engine can walk `is`, `ofType` and the subtype chain with no definitions
/// loaded (the approach fhirpath.js takes with its generated type2Parent).
class TypeHierarchyEntry {
  /// Describes one type.
  const TypeHierarchyEntry({
    required this.name,
    required this.type,
    required this.kind,
    required this.url,
    this.base,
    this.derivation,
    this.isAbstract = false,
  });

  /// StructureDefinition.name, the table key.
  final String name;

  /// StructureDefinition.type (differs from [name] for a constraint, e.g.
  /// SimpleQuantity's type is Quantity).
  final String type;

  /// StructureDefinition.kind: 'primitive-type', 'complex-type', 'resource'
  /// or 'logical'.
  final String kind;

  /// StructureDefinition.url.
  final String url;

  /// The [name] of the base type, or null for Base itself.
  final String? base;

  /// StructureDefinition.derivation: 'specialization' or 'constraint'.
  final String? derivation;

  /// StructureDefinition.abstract.
  final bool isAbstract;
}

/// What one FHIR version supplies so the engine's worker context, caches
/// and terminology layer can run over any model: everything else in those
/// classes reads a resource by element name through [FhirNode].
///
/// A binding package (fhir_r4_path, fhir_r5_path, fhir_r6_path) implements
/// this once, over its own generated model, and hands it to
/// [FhirWorkerContext].
abstract class FhirModelBinding extends ResourceModel<FhirNode> {
  /// Makes the binding.
  const FhirModelBinding();

  /// The FHIR version the model implements, e.g. '4.3.0'.
  @override
  String get fhirVersion;

  /// The resource type names of this version: the [typeHierarchy] entries
  /// of kind `resource` and derivation `specialization` (the filter the
  /// Java reference's TypeManager applies), abstract ones included.
  @override
  Set<String> get resourceTypeNames => {
        for (final info in typeHierarchy.values)
          if (info.kind == 'resource' && info.derivation == 'specialization')
            info.name,
      };

  /// Every core type, keyed by StructureDefinition.name.
  Map<String, TypeHierarchyEntry> get typeHierarchy;

  /// The factory that builds this model's values for the engine's results.
  IFhirValueFactory get valueFactory;

  /// A resource of this model from its JSON.
  @override
  FhirNode fromJson(Map<String, dynamic> json);

  /// The JSON of a node of this model.
  @override
  Map<String, dynamic> toJson(FhirNode node);

  /// Whether [typeName] names a type of this model (primitive, data type,
  /// backbone, quantity or resource), so a type check needs no definition
  /// loaded.
  bool isModelType(String typeName);

  /// Whether [node] is a System value rather than a FHIR element: a value
  /// outside the model's element tree, or a bare primitive the engine made
  /// (the model marks those; in fhir_r4 it is `disallowExtensions`).
  bool isSystemValue(FhirNode node);

  /// Whether [node] is a bare primitive the engine made (a System value
  /// that `ofType(System.X)` may match): in fhir_r4, an Element with
  /// `disallowExtensions`.
  bool isSystemPrimitive(FhirNode node);

  /// [node] read as a Coding, or null when it is not one and cannot stand
  /// for one. The model decides what stands for a Coding (fhir_r4's
  /// TypeConvertor.castToCoding: a Coding, or a code primitive).
  CodingValue? asCoding(FhirNode node);

  /// [node] read as a CodeableConcept, or null. The model decides what
  /// stands for one (a CodeableConcept, a code; R5 adds a string).
  ConceptValue? asCodeableConcept(FhirNode node);
}

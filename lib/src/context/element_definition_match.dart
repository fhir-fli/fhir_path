import 'package:fhir_node/fhir_node.dart';

/// One ElementDefinition found by path, with the concrete type a typed
/// choice name (`valueString`) fixed, if it did.
class ElementDefinitionMatch {
  /// A match.
  ElementDefinitionMatch(this.definition, this.fixedType);

  /// The ElementDefinition node.
  FhirNode? definition;

  /// The type the path's choice suffix fixed, or null.
  String? fixedType;
}

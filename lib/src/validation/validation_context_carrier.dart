import 'package:fhir_node/fhir_node.dart';

/// Resources the caller has in hand that a value set may refer to by
/// contained reference (`#id`): the checker looks for a contained CodeSystem
/// in each of them. Held as nodes of any model.
class ValidationContextCarrier {
  /// The resources, in the order given.
  final List<FhirNode> resources = [];

  /// The resources.
  List<FhirNode> getResources() => resources;
}

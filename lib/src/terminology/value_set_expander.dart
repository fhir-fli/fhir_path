// ignore_for_file: one_member_abstracts

import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/fhir_path.dart';

/// Expands a ValueSet.
abstract class ValueSetExpander {
  /// Expands [source] (a ValueSet node) with [parameters] (a Parameters
  /// resource as JSON, or null).
  Future<ValueSetExpansionOutcome> expand(
    FhirNode source,
    Map<String, dynamic>? parameters,
  );
}

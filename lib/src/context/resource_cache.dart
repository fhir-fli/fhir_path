import 'package:fhir_node/fhir_node.dart';
import 'package:http/http.dart';

/// Where the worker context finds canonical resources (StructureDefinition,
/// ValueSet, CodeSystem, ...). Every resource is a node of whatever model
/// the binding uses; a caller that wants its typed class casts, because the
/// binding's nodes ARE its typed objects.
abstract class ResourceCache {
  /// A cache.
  ResourceCache({this.client});

  /// The HTTP client used to fetch resources, when one is used.
  final Client? client;

  /// The canonical resource at [url] (and [version], when given), or null.
  Future<FhirNode?> getCanonicalResource(String url, [String? version]);

  /// Keeps [resource], a canonical resource node.
  Future<void> saveCanonicalResource(FhirNode resource);

  /// The StructureDefinition at [url], or null.
  Future<FhirNode?> getStructureDefinition(String url);

  /// Every StructureDefinition held.
  Future<List<FhirNode>> getStructureDefinitions();

  /// The CodeSystem at [url] (and [version]), or null.
  Future<FhirNode?> getCodeSystem(String url, [String? version]);

  /// The names of the resources held (CanonicalResource.name).
  Future<List<String>> getResourceNames();
}

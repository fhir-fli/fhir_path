import 'dart:convert';

import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/fhir_path.dart';
import 'package:http/http.dart';

/// A [CanonicalResourceCache] that fetches by HTTP GET what it does not
/// hold, parses it with the model's [parse], and keeps it.
class OnlineResourceCache extends CanonicalResourceCache {
  /// A cache that fetches. [parse] is the model's resource-from-JSON.
  OnlineResourceCache({
    required this.parse,
    super.enforceUniqueId = false,
    Client? client,
  }) : super(client: client ?? Client());

  /// The model's resource from JSON.
  final FhirNode Function(Map<String, dynamic> json) parse;

  /// The canonical resource types a fetch is accepted for.
  static const supportedTypes = {
    'StructureDefinition',
    'CodeSystem',
    'ValueSet',
    'ConceptMap',
    'SearchParameter',
    'OperationDefinition',
    'ImplementationGuide',
  };

  @override
  Future<FhirNode?> getCanonicalResource(String url, [String? version]) async {
    final local = await super.getCanonicalResource(url, version);
    if (local != null) return local;
    return _fetchAndCache(url, version);
  }

  Future<FhirNode?> _fetchAndCache(String url, String? version) async {
    try {
      var uri = Uri.parse(url.replaceAll('http://', 'https://'));
      if (version != null) {
        uri = uri.replace(
          queryParameters: {...uri.queryParameters, 'version': version},
        );
      }
      final headers = <String, String>{
        'Accept': 'application/fhir+json',
        'Content-Type': 'application/json',
      };
      var response = await client!.get(uri, headers: headers);
      if (response.statusCode != 200) {
        headers['Accept'] = 'application/json';
        response = await client!.get(uri, headers: headers);
        if (response.statusCode != 200) return null;
      }
      final json = jsonDecode(response.body);
      if (json is! Map<String, dynamic> ||
          !supportedTypes.contains(json['resourceType'])) {
        return null;
      }
      final resource = parse(json);
      see(resource);
      return resource;
    } on Exception catch (_) {
      // A fetch or parse that fails means the resource is not available.
      return null;
    }
  }
}

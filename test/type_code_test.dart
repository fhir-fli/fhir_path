import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/fhir_path.dart';
import 'package:test/test.dart';

import 'support/json_stub.dart';

/// A type code names its StructureDefinition by one address.
/// ElementDefinition.type.code (packaged profiles-types.ndjson, 4.3.0,
/// verbatim): "References are URLs that are relative to
/// http://hl7.org/fhir/StructureDefinition e.g. "string" is a reference to
/// http://hl7.org/fhir/StructureDefinition/string. Absolute URLs are only
/// allowed in logical models."
void main() {
  const binding = StubBinding();

  JsonNode definition(String url, String type) => JsonNode.resource({
        'resourceType': 'StructureDefinition',
        'id': url.split('/').last,
        'url': url,
        'type': type,
        'kind': 'complex-type',
        'derivation': 'specialization',
      });

  group('typeCodeCanonical', () {
    test('a relative code is resolved against the core base', () {
      expect(
        typeCodeCanonical('HumanName'),
        'http://hl7.org/fhir/StructureDefinition/HumanName',
      );
      expect(
        typeCodeCanonical('string'),
        'http://hl7.org/fhir/StructureDefinition/string',
      );
    });

    test('an absolute code is kept as written', () {
      for (final code in [
        'http://hl7.org/fhirpath/System.String',
        'http://hl7.org/fhir/tools/StructureDefinition/CDSHookContext',
        'urn:example:logical-model',
      ]) {
        expect(typeCodeCanonical(code), code);
      }
    });
  });

  group('FhirWorkerContext.fetchTypeDefinition', () {
    test('finds a core type by its code', () async {
      const url = 'http://hl7.org/fhir/StructureDefinition/HumanName';
      final cache = CanonicalResourceCache()..see(definition(url, 'HumanName'));
      final worker = FhirWorkerContext(binding: binding, resourceCache: cache);

      final sd = await worker.fetchTypeDefinition('HumanName');

      expect(sd?.getChildByName('url')?.primitiveValue, url);
    });

    test('finds a logical model by its absolute code', () async {
      const url =
          'http://hl7.org/fhir/tools/StructureDefinition/CDSHookContext';
      final cache = CanonicalResourceCache()..see(definition(url, url));
      final worker = FhirWorkerContext(binding: binding, resourceCache: cache);

      final sd = await worker.fetchTypeDefinition(url);

      expect(sd?.getChildByName('url')?.primitiveValue, url);
    });

    test('a relative code does not resolve against any other base', () async {
      // terminology.hl7.org publishes StructureDefinitions, all of them
      // extensions (hl7.terminology 7.4.0: 9, every one kind complex-type,
      // type Extension). A relative code names none of them.
      const url =
          'http://terminology.hl7.org/StructureDefinition/ext-namingsystem-title';
      final cache = CanonicalResourceCache()..see(definition(url, 'Extension'));
      final worker = FhirWorkerContext(binding: binding, resourceCache: cache);

      expect(
        await worker.fetchTypeDefinition('ext-namingsystem-title'),
        isNull,
      );
    });
  });
}

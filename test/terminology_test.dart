import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/fhir_path.dart';
import 'package:test/test.dart';

import 'support/json_stub.dart';

/// The terminology layer and the worker context over a model-free stub:
/// every read is by element name, so what passes here passes for any
/// binding. The per-version bindings' suites cover their own models.
void main() {
  const binding = StubBinding();

  final codeSystem = JsonNode.resource({
    'resourceType': 'CodeSystem',
    'id': 'cs1',
    'url': 'http://example.org/cs',
    'content': 'complete',
    'concept': [
      {
        'code': 'a',
        'display': 'Alpha',
        'concept': [
          {'code': 'a1', 'display': 'Alpha one'},
        ],
      },
      {'code': 'b', 'display': 'Beta'},
    ],
  });
  final composed = JsonNode.resource({
    'resourceType': 'ValueSet',
    'id': 'vs1',
    'url': 'http://example.org/vs',
    'version': '2',
    'status': 'active',
    'compose': {
      'include': [
        {
          'system': 'http://example.org/cs',
          'concept': [
            {'code': 'a', 'display': 'Alpha'},
          ],
        },
      ],
    },
  });
  final wholeSystem = JsonNode.resource({
    'resourceType': 'ValueSet',
    'id': 'vs2',
    'url': 'http://example.org/vs-all',
    'status': 'active',
    'compose': {
      'include': [
        {'system': 'http://example.org/cs'},
      ],
      'exclude': [
        {
          'system': 'http://example.org/cs',
          'concept': [
            {'code': 'b'},
          ],
        },
      ],
    },
  });
  final expanded = JsonNode.resource({
    'resourceType': 'ValueSet',
    'id': 'vs3',
    'url': 'http://example.org/vs-expanded',
    'status': 'active',
    'expansion': {
      'contains': [
        {
          'system': 'http://example.org/cs',
          'code': 'x',
          'contains': [
            {'system': 'http://example.org/cs', 'code': 'y'},
          ],
        },
      ],
    },
  });

  FhirWorkerContext worker() {
    final cache = CanonicalResourceCache()
      ..see(codeSystem)
      ..see(composed)
      ..see(wholeSystem)
      ..see(expanded);
    return FhirWorkerContext(binding: binding, resourceCache: cache);
  }

  group('CanonicalResourceCache', () {
    test('finds by url, by url|version, and the latest version', () async {
      final cache = CanonicalResourceCache()..see(composed);
      expect(
        await cache.getCanonicalResource('http://example.org/vs'),
        composed,
      );
      expect(
        await cache.getCanonicalResource('http://example.org/vs', '2'),
        composed,
      );
      expect(
        await cache.getCanonicalResource('http://example.org/vs', '1'),
        isNull,
      );
      expect(await cache.getCodeSystem('http://example.org/vs'), isNull);
      expect(await cache.getResourceNames(), isEmpty);
    });

    test('a resource with no id is still filed', () async {
      final cache = CanonicalResourceCache()
        ..see(JsonNode.resource({'resourceType': 'ValueSet', 'url': 'u:noid'}));
      expect(await cache.getCanonicalResource('u:noid'), isNotNull);
    });
  });

  group('ValueSetChecker', () {
    test('a listed concept is a member; another code of the system is not',
        () async {
      final checker = ValueSetChecker(
        context: worker(),
        options: ValidationOptions(),
        valueSet: composed,
      );
      expect(
        await checker.codeInValueSet('http://example.org/cs', 'a', null),
        isTrue,
      );
      expect(
        await checker.codeInValueSet('http://example.org/cs', 'b', null),
        isNull,
      );
      expect(await checker.codeInValueSet('http://other', 'a', null), isFalse);
    });

    test('a whole-system include reaches the code system, exclude wins',
        () async {
      final checker = ValueSetChecker(
        context: worker(),
        options: ValidationOptions(),
        valueSet: wholeSystem,
      );
      expect(
        await checker.codeInValueSet('http://example.org/cs', 'a1', null),
        isTrue,
      );
      expect(
        await checker.codeInValueSet('http://example.org/cs', 'b', null),
        isFalse,
      );
      expect(
        await checker.codeInValueSet('http://example.org/cs', 'zz', null),
        isFalse,
      );
    });

    test('an expansion is searched, nested contains included', () async {
      final checker = ValueSetChecker(
        context: worker(),
        options: ValidationOptions(),
        valueSet: expanded,
      );
      expect(
        await checker.codeInValueSet('http://example.org/cs', 'y', null),
        isTrue,
      );
      expect(
        await checker.codeInValueSet('http://example.org/cs', 'a', null),
        isFalse,
      );
    });

    test('validateCode answers with the code system display', () async {
      final checker = ValueSetChecker(
        context: worker(),
        options: ValidationOptions(),
        valueSet: composed,
      );
      final ok = await checker.validateCode(
        const ConceptValue(
          coding: [CodingValue(system: 'http://example.org/cs', code: 'a')],
        ),
      );
      expect(ok.isOk, isTrue);
      expect(ok.display, 'Alpha');
      final bad = await checker.validateCode(
        const ConceptValue(
          coding: [CodingValue(system: 'http://example.org/cs', code: 'nope')],
        ),
      );
      expect(bad.isOk, isFalse);
      expect(bad.message, contains('not found in code system'));
    });
  });

  group('ValueSetExpanderSimple', () {
    test('expands a compose over a complete code system', () async {
      final outcome =
          await ValueSetExpanderSimple(worker()).expand(composed, null);
      expect(outcome.isOk, isTrue, reason: outcome.allErrors.join('; '));
      final contains = outcome.valueSet!
          .getChildByName('expansion')!
          .getChildrenByName('contains')
          .map((c) => c.getChildByName('code')?.primitiveValue)
          .toList();
      expect(contains, ['a']);
      // A bare system include (no concept, filter or value set) adds
      // nothing: the typed port never expanded a whole code system, and
      // this move keeps that as it was.
      final bare =
          await ValueSetExpanderSimple(worker()).expand(wholeSystem, null);
      expect(
        bare.valueSet!
            .getChildByName('expansion')!
            .getChildrenByName('contains'),
        isEmpty,
      );
    });

    test('a value set with no compose cannot be expanded', () async {
      final outcome = await ValueSetExpanderSimple(worker()).expand(
        JsonNode.resource({'resourceType': 'ValueSet', 'url': 'u:empty'}),
        null,
      );
      expect(outcome.isOk, isFalse);
      expect(
        outcome.errorClass,
        TerminologyServiceErrorClass.valueSetUnsupported,
      );
    });
  });

  group('FhirWorkerContext', () {
    test('type queries come from the binding table with an empty cache',
        () async {
      final w = FhirWorkerContext(binding: binding);
      expect(await w.isSubtypeOf('Age', 'Quantity'), isTrue);
      expect(await w.isSubtypeOf('code', 'string'), isTrue);
      expect(await w.isSubtypeOf('Patient', 'Quantity'), isFalse);
      expect(await w.isKnownType('Patient'), isTrue);
      expect(await w.isKnownType('Nope'), isFalse);
      expect(await w.primitiveTypeNames(), {'string', 'code'});
      expect(await w.getResourceNames(), containsAll(['Patient']));
      expect(
        await w.typeAncestry('http://hl7.org/fhir/StructureDefinition/Age'),
        [
          ('http://hl7.org/fhir/StructureDefinition/Age', 'Quantity'),
          ('http://hl7.org/fhir/StructureDefinition/Quantity', 'Quantity'),
          ('http://hl7.org/fhir/StructureDefinition/Element', 'Element'),
        ],
      );
    });

    test('a loaded StructureDefinition joins the walk', () async {
      final w = FhirWorkerContext(binding: binding);
      await w.loadStructureDefinition(
        JsonNode.resource({
          'resourceType': 'StructureDefinition',
          'name': 'MyAge',
          'url': 'http://hl7.org/fhir/StructureDefinition/MyAge',
          'type': 'MyAge',
          'kind': 'complex-type',
          'derivation': 'specialization',
          'baseDefinition': 'http://hl7.org/fhir/StructureDefinition/Age',
        }),
      );
      expect(await w.isSubtypeOf('MyAge', 'Quantity'), isTrue);
      expect(await w.getResourceNames(), containsAll(['Patient', 'MyAge']));
    });

    test('fetchValueSet and validation through the binding', () async {
      final w = worker();
      expect(await w.fetchValueSet('http://example.org/vs'), composed);
      const coding = JsonNode(
        {'system': 'http://example.org/cs', 'code': 'a'},
        'Coding',
      );
      final r = await w.validateCodeForCodingValue(
        ValidationOptions(),
        coding,
        composed,
      );
      expect(r.isOk, isTrue);
      const notCoding = JsonNode({'value': '1'}, 'Quantity');
      final bad = await w.validateCodeForCodingValue(
        ValidationOptions(),
        notCoding,
        composed,
      );
      expect(bad.isOk, isFalse);
      expect(bad.message, contains('as a Coding'));
    });
  });

  test('CodingValue and ConceptValue read any model by name', () {
    const cc = JsonNode(
      {
        'coding': [
          {'system': 's', 'code': 'c', 'display': 'd'},
        ],
        'text': 't',
      },
      'CodeableConcept',
    );
    final v = ConceptValue.fromNode(cc);
    expect(v.coding.single.toString(), 's#c');
    expect(v.text, 't');
    expect(v.toJson(), {
      'coding': [
        {'system': 's', 'code': 'c', 'display': 'd'},
      ],
      'text': 't',
    });
  });
}

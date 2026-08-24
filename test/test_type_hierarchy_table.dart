import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_r4_path/fhir_r4_path.dart';
import 'package:test/test.dart';

import 'test_data.dart';

/// Type-hierarchy queries against a bare `WorkerContext()` whose
/// `CanonicalResourceCache` is EMPTY — the default production state.
///
/// Before the generated `fhirTypeHierarchy` table existed, the subtype walks
/// (`isSubtypeOf`/`matchesOfType`) silently returned false for every
/// non-exact match unless core StructureDefinitions had been loaded into the
/// cache, so e.g. `someAge is Quantity` failed for real users. The table
/// (the analogue of fhirpath.js's generated `type2Parent` model data /
/// Firely's `ModelInspector`) makes core-type hierarchy knowledge intrinsic
/// to the binding. These tests mirror the official `testFHIRPathIsFunction`
/// group plus `ofType`/resource-hierarchy checks, WITHOUT priming the cache.
Future<void> testTypeHierarchyTable() async {
  // NO StructureDefinitions loaded — this is the point of the test.
  final testEngine = await FHIRPathEngine.create(WorkerContext());

  final questionnaire = Questionnaire.fromJson(<String, dynamic>{
    'resourceType': 'Questionnaire',
    'url': 'http://hl7.org/fhir/Questionnaire/3141',
    'status': 'draft',
  });

  final valueSet = ValueSet.fromJson(<String, dynamic>{
    'resourceType': 'ValueSet',
    'version': '20150622',
    'status': 'draft',
  });

  final observation = Observation.fromJson(<String, dynamic>{
    'resourceType': 'Observation',
    'status': 'final',
    'code': <String, dynamic>{
      'coding': <dynamic>[
        <String, dynamic>{'system': 'http://loinc.org', 'code': '29463-7'},
      ],
    },
    'extension': <dynamic>[
      <String, dynamic>{
        'url': 'http://example.com/fhir/StructureDefinition/patient-age',
        'valueAge': <String, dynamic>{
          'value': 54,
          'unit': 'years',
          'system': 'http://unitsofmeasure.org',
          'code': 'a',
        },
      },
    ],
  });

  const ageExtension =
      "Observation.extension('http://example.com/fhir/StructureDefinition/patient-age').value";

  group('type hierarchy table (empty cache)', () {
    Future<void> check(
      Resource context,
      String expression,
      bool expected,
    ) async {
      final node = testEngine.parse(expression);
      expect(
        await testEngine.evaluate(context, node),
        [expected.toFhirBoolean],
        reason: expression,
      );
    }

    Future<void> checkEmpty(Resource context, String expression) async {
      final node = testEngine.parse(expression);
      expect(
        await testEngine.evaluate(context, node),
        isEmpty,
        reason: expression,
      );
    }

    // The official testFHIRPathIsFunction group, unprimed.
    test('code is its own type', () async {
      await check(patient1, 'Patient.gender.is(code)', true);
    });

    test('code derives from string', () async {
      await check(patient1, 'Patient.gender.is(string)', true);
    });

    test('code is not id (sibling)', () async {
      await check(patient1, 'Patient.gender.is(id)', false);
    });

    test('url field is uri', () async {
      await check(questionnaire, 'Questionnaire.url.is(uri)', true);
    });

    test('uri is not url (wrong direction)', () async {
      await check(questionnaire, 'Questionnaire.url.is(url)', false);
    });

    test('version field is string', () async {
      await check(valueSet, 'ValueSet.version.is(string)', true);
    });

    test('string is not code (wrong direction)', () async {
      await check(valueSet, 'ValueSet.version.is(code)', false);
    });

    test('Age value is Age (operator form)', () async {
      await check(observation, '$ageExtension is Age', true);
    });

    test('Age is Quantity (subtype, operator form)', () async {
      await check(observation, '$ageExtension is Quantity', true);
    });

    test('Age is not Duration (sibling)', () async {
      await check(observation, '$ageExtension is Duration', false);
    });

    // Resource hierarchy.
    test('Patient is DomainResource (function form)', () async {
      await check(patient1, 'Patient.is(DomainResource)', true);
    });

    test('Patient is Resource (two-level walk)', () async {
      await check(patient1, 'Patient.is(FHIR.Resource)', true);
    });

    test('Patient is not Observation', () async {
      await check(patient1, 'Patient.is(Observation)', false);
    });

    // ofType: subtype-aware but stops at primitive-type definitions.
    test('ofType(Quantity) keeps an Age (subtype walk)', () async {
      await check(
        observation,
        '$ageExtension.ofType(Quantity).exists()',
        true,
      );
    });

    test('ofType(string) drops a code (primitive stop)', () async {
      await checkEmpty(patient1, 'Patient.gender.ofType(string)');
    });

    test('ofType(code) keeps a code (exact match)', () async {
      await check(patient1, 'Patient.gender.ofType(code).exists()', true);
    });
  });
}

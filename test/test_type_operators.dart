import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_r4_path/fhir_r4_path.dart';
import 'package:test/test.dart';

import 'test_data.dart';

/// Ports of the official `testFHIRPathIsFunction` group
/// (fhir-test-cases r4/fhirpath/tests-fhir-r4.xml). These pin down the
/// subtype-aware semantics of `is` — both directions of the hierarchy walk
/// (`code is string` is true because code derives from string, but
/// `string is code` / `uri is url` are false) and the operator form's
/// equivalence with the `is()` function (per FHIRPath spec §6.3), including
/// complex-type subtypes (`Age is Quantity`).
/// Minimal StructureDefinitions for the R4 types the subtype walks traverse.
/// kind/type/baseDefinition/derivation are copied verbatim from the official
/// R4 profiles-types.json (only the fields the walk reads are included).
StructureDefinition _typeSd({
  required String name,
  required String kind,
  String? baseDefinition,
}) {
  return StructureDefinition.fromJson(<String, dynamic>{
    'resourceType': 'StructureDefinition',
    'id': name,
    'url': 'http://hl7.org/fhir/StructureDefinition/$name',
    'name': name,
    'status': 'active',
    'kind': kind,
    'abstract': false,
    'type': name,
    if (baseDefinition != null) 'baseDefinition': baseDefinition,
    if (baseDefinition != null) 'derivation': 'specialization',
  });
}

const _fhirSd = 'http://hl7.org/fhir/StructureDefinition';

final _r4TypeDefinitions = <StructureDefinition>[
  _typeSd(name: 'Element', kind: 'complex-type'),
  _typeSd(
    name: 'string',
    kind: 'primitive-type',
    baseDefinition: '$_fhirSd/Element',
  ),
  _typeSd(
    name: 'code',
    kind: 'primitive-type',
    baseDefinition: '$_fhirSd/string',
  ),
  _typeSd(
    name: 'id',
    kind: 'primitive-type',
    baseDefinition: '$_fhirSd/string',
  ),
  _typeSd(
    name: 'uri',
    kind: 'primitive-type',
    baseDefinition: '$_fhirSd/Element',
  ),
  _typeSd(name: 'url', kind: 'primitive-type', baseDefinition: '$_fhirSd/uri'),
  _typeSd(
    name: 'Quantity',
    kind: 'complex-type',
    baseDefinition: '$_fhirSd/Element',
  ),
  _typeSd(
    name: 'Age',
    kind: 'complex-type',
    baseDefinition: '$_fhirSd/Quantity',
  ),
  _typeSd(
    name: 'Duration',
    kind: 'complex-type',
    baseDefinition: '$_fhirSd/Quantity',
  ),
];

Future<void> testTypeOperators() async {
  final resourceCache = CanonicalResourceCache();
  _r4TypeDefinitions.forEach(resourceCache.see);
  final testEngine =
      await FHIRPathEngine.create(WorkerContext(resourceCache: resourceCache));

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

  // observation-example.xml in fhir-test-cases carries an Age-valued
  // extension specifically for the `is Age`/`is Quantity`/`is Duration`
  // subtype tests.
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

  group('testFHIRPathIsFunction (official)', () {
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

    test('testFHIRPathIsFunction1: code is its own type', () async {
      await check(patient1, 'Patient.gender.is(code)', true);
    });

    test('testFHIRPathIsFunction2: code derives from string', () async {
      await check(patient1, 'Patient.gender.is(string)', true);
    });

    test('testFHIRPathIsFunction3: code is not id (sibling)', () async {
      await check(patient1, 'Patient.gender.is(id)', false);
    });

    test('testFHIRPathIsFunction4: url field is uri', () async {
      await check(questionnaire, 'Questionnaire.url.is(uri)', true);
    });

    test('testFHIRPathIsFunction5: uri is not url (wrong direction)', () async {
      await check(questionnaire, 'Questionnaire.url.is(url)', false);
    });

    test('testFHIRPathIsFunction6: version field is string', () async {
      await check(valueSet, 'ValueSet.version.is(string)', true);
    });

    test('testFHIRPathIsFunction7: string is not code (wrong direction)',
        () async {
      await check(valueSet, 'ValueSet.version.is(code)', false);
    });

    test('testFHIRPathIsFunction8: Age value is Age (operator form)', () async {
      await check(
        observation,
        "Observation.extension('http://example.com/fhir/StructureDefinition/patient-age').value is Age",
        true,
      );
    });

    test('testFHIRPathIsFunction9: Age is Quantity (subtype, operator form)',
        () async {
      await check(
        observation,
        "Observation.extension('http://example.com/fhir/StructureDefinition/patient-age').value is Quantity",
        true,
      );
    });

    test('testFHIRPathIsFunction10: Age is not Duration (sibling)', () async {
      await check(
        observation,
        "Observation.extension('http://example.com/fhir/StructureDefinition/patient-age').value is Duration",
        false,
      );
    });
  });
}

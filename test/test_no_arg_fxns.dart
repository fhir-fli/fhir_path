import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_r4_path/fhir_r4_path.dart';
import 'package:test/test.dart';
import 'test_data.dart';

Future<void> testNoArgFxns() async {
  final testEngine = await FHIRPathEngine.create(WorkerContext());
  group('Functions w/o Arguments: ', () {
    test('empty', () async {
      var node = testEngine.parse('name.family.empty()');
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse('name.given.empty()');
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse('Patient.language.empty()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('Patient.name.period.empty()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('{}.empty()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
    });
    test('allTrue', () async {
      var node = testEngine.parse('Patient.active.allTrue()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('Patient.deceasedBoolean.allTrue()');
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
    });
    test('anyTrue', () async {
      var node = testEngine.parse('Patient.active.anyTrue()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('Patient.deceasedBoolean.anyTrue()');
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
    });
    test('allFalse', () async {
      var node = testEngine.parse('Patient.active.allFalse()');
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse('Patient.deceasedBoolean.allFalse()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
    });
    test('anyFalse', () async {
      var node = testEngine.parse('Patient.active.anyFalse()');
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse('Patient.deceasedBoolean.anyFalse()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
    });
    test('count', () async {
      var node = testEngine.parse('Patient.name.count()');
      expect(
        await testEngine.evaluate(patient3, node),
        [4.toFhirInteger],
      );
      node = testEngine.parse('Patient.name.given.count()');
      expect(
        await testEngine.evaluate(patient3, node),
        [8.toFhirInteger],
      );
    });
    test('distinct', () async {
      var node = testEngine.parse('Patient.name.distinct()');
      expect(
          (await testEngine.evaluate(patient3, node)).map(
            (e) => (e as FhirBase).toJson(),
          ),
          [
            {
              'use': 'official',
              'family': 'Faulkenberry',
              'given': ['Jason', 'Grey'],
            },
            {
              'family': 'Niel',
              'given': ['Kristin'],
            },
            {
              'family': 'Smith',
              'given': ['John', 'Jacob', 'Jingleheimer'],
            },
          ]);
      node = testEngine.parse('Patient.name.given.distinct()');
      expect(
        (await testEngine.evaluate(patient3, node)).map(
          (e) =>
              e is PrimitiveType ? e.primitiveValue : (e as FhirBase).toJson(),
        ),
        ['Jason', 'Grey', 'Kristin', 'John', 'Jacob', 'Jingleheimer'],
      );
    });
    test('isDistinct', () async {
      var node = testEngine.parse('Patient.name.distinct().isDistinct()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('Patient.name.given.distinct().isDistinct()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('Patient.address.period.isDistinct()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('Patient.name.isDistinct()');
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
    });
    test('Single', () async {
      var node = testEngine.parse('Patient.telecom.single()');
      expect(
        (await testEngine.evaluate(patient3, node)).first.toR4Json(),
        {
          'system': 'email',
          'use': 'mobile',
          'rank': 3,
        },
      );
      node = testEngine.parse('Patient.name.id.single()');
      expect(
        await testEngine.evaluate(patient3, node),
        <FhirBase>[],
      );
    });
    test('First', () async {
      var node = testEngine.parse('Patient.name.id.first()');
      expect(
        await testEngine.evaluate(patient3, node),
        <FhirBase>[],
      );
      node = testEngine.parse('Patient.name.given.first()');
      expect(
        await testEngine.evaluate(patient3, node),
        ['Jason'.toFhirString],
      );
    });
    test('Last', () async {
      var node = testEngine.parse('Patient.name.id.last()');
      expect(
        await testEngine.evaluate(patient3, node),
        <FhirBase>[],
      );
      node = testEngine.parse('Patient.name.given.last()');
      expect(
        await testEngine.evaluate(patient3, node),
        ['Jingleheimer'.toFhirString],
      );
    });
    test('Tail', () async {
      var node = testEngine.parse('Patient.name.id.tail()');
      expect(
        await testEngine.evaluate(patient3, node),
        <FhirBase>[],
      );
      node = testEngine.parse('Patient.name.given.tail()');
      expect(await testEngine.evaluate(patient3, node), [
        'Grey'.toFhirString,
        'Jason'.toFhirString,
        'Grey'.toFhirString,
        'Kristin'.toFhirString,
        'John'.toFhirString,
        'Jacob'.toFhirString,
        'Jingleheimer'.toFhirString,
      ]);
    });
    test('toBoolean', () async {
      var node = testEngine.parse("'1'.toBoolean()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'true'.toBoolean()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'t'.toBoolean()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'yes'.toBoolean()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'y'.toBoolean()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'1.0'.toBoolean()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'0'.toBoolean()");
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse("'false'.toBoolean()");
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse("'f'.toBoolean()");
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse("'no'.toBoolean()");
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse("'n'.toBoolean()");
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse("'0.0'.toBoolean()");
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse('1.toBoolean()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('0.toBoolean()');
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse('1.0.toBoolean()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('0.0.toBoolean()');
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
    });
    test('convertsToBoolean', () async {
      var node = testEngine.parse("'1'.toBoolean().convertsToBoolean()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'true'.toBoolean().convertsToBoolean()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'t'.toBoolean().convertsToBoolean()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'yes'.toBoolean().convertsToBoolean()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'y'.toBoolean().convertsToBoolean()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'1.0'.toBoolean().convertsToBoolean()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'0'.toBoolean().convertsToBoolean()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'false'.toBoolean().convertsToBoolean()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'f'.toBoolean().convertsToBoolean()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'no'.toBoolean().convertsToBoolean()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'n'.toBoolean().convertsToBoolean()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'0.0'.toBoolean().convertsToBoolean()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('1.toBoolean().convertsToBoolean()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('0.toBoolean().convertsToBoolean()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('1.0.toBoolean().convertsToBoolean()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('0.0.toBoolean().convertsToBoolean()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('name.first().convertsToBoolean()');
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse('name.given.first().convertsToBoolean()');
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
    });
    test('toInteger', () async {
      var node = testEngine.parse("'1'.toInteger()");
      expect(
        await testEngine.evaluate(patient3, node),
        [1.toFhirInteger],
      );
      node = testEngine.parse("'true'.toInteger()");
      expect(
        await testEngine.evaluate(patient3, node),
        <FhirBase>[1.toFhirInteger],
      );
      node = testEngine.parse("'t'.toInteger()");
      expect(
        await testEngine.evaluate(patient3, node),
        <FhirBase>[],
      );
      node = testEngine.parse("'yes'.toInteger()");
      expect(
        await testEngine.evaluate(patient3, node),
        <FhirBase>[],
      );
      node = testEngine.parse("'y'.toInteger()");
      expect(
        await testEngine.evaluate(patient3, node),
        <FhirBase>[],
      );
      node = testEngine.parse("'1.0'.toInteger()");
      expect(
        await testEngine.evaluate(patient3, node),
        <FhirBase>[],
      );
      node = testEngine.parse("'0'.toInteger()");
      expect(
        await testEngine.evaluate(patient3, node),
        [0.toFhirInteger],
      );
      node = testEngine.parse("'false'.toInteger()");
      expect(
        await testEngine.evaluate(patient3, node),
        <FhirBase>[0.toFhirInteger],
      );
      node = testEngine.parse("'f'.toInteger()");
      expect(
        await testEngine.evaluate(patient3, node),
        <FhirBase>[],
      );
      node = testEngine.parse("'no'.toInteger()");
      expect(
        await testEngine.evaluate(patient3, node),
        <FhirBase>[],
      );
      node = testEngine.parse("'n'.toInteger()");
      expect(
        await testEngine.evaluate(patient3, node),
        <FhirBase>[],
      );
      node = testEngine.parse("'0.0'.toInteger()");
      expect(
        await testEngine.evaluate(patient3, node),
        <FhirBase>[],
      );
      node = testEngine.parse('1.toInteger()');
      expect(
        await testEngine.evaluate(patient3, node),
        [1.toFhirInteger],
      );
      node = testEngine.parse('0.toInteger()');
      expect(
        await testEngine.evaluate(patient3, node),
        [0.toFhirInteger],
      );
      node = testEngine.parse('1.0.toInteger()');
      expect(
        await testEngine.evaluate(patient3, node),
        <FhirBase>[],
      );
      node = testEngine.parse('0.0.toInteger()');
      expect(
        await testEngine.evaluate(patient3, node),
        <FhirBase>[],
      );
      node = testEngine.parse('true.toInteger()');
      expect(
        await testEngine.evaluate(patient3, node),
        [1.toFhirInteger],
      );
      node = testEngine.parse('false.toInteger()');
      expect(
        await testEngine.evaluate(patient3, node),
        [0.toFhirInteger],
      );
    });
    test('convertsToInteger', () async {
      var node = testEngine.parse("'1'.convertsToInteger()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'true'.convertsToInteger()");
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse("'t'.convertsToInteger()");
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse("'yes'.convertsToInteger()");
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse("'y'.convertsToInteger()");
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse("'1.0'.convertsToInteger()");
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse("'0'.convertsToInteger()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'false'.convertsToInteger()");
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse("'f'.convertsToInteger()");
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse("'no'.convertsToInteger()");
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse("'n'.convertsToInteger()");
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse("'0.0'.convertsToInteger()");
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse('1.convertsToInteger()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('0.convertsToInteger()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('1.0.convertsToInteger()');
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse('0.0.convertsToInteger()');
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse('true.convertsToInteger()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('false.convertsToInteger()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
    });
    test('toDate', () async {
      var node = testEngine.parse('@2021-01-01.toDate()');
      expect(
        await testEngine.evaluate(patient3, node),
        ['2021-01-01'.toFhirDate],
      );
      node = testEngine.parse("'2021-01-01'.toDate()");
      expect(
        await testEngine.evaluate(patient3, node),
        ['2021-01-01'.toFhirDate],
      );
    });
    test('convertsToDate', () async {
      var node = testEngine.parse('@2021-01-01.convertsToDate()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'2021-01-01'.convertsToDate()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
    });
    test('toDateTime', () async {
      var node = testEngine.parse('@2021-01-01.toDateTime()');
      expect(
        await testEngine.evaluate(patient3, node),
        ['2021-01-01'.toFhirDateTime],
      );
      node = testEngine.parse("'2021-01-01'.toDateTime()");
      expect(
        await testEngine.evaluate(patient3, node),
        ['2021-01-01'.toFhirDateTime],
      );
      node = testEngine.parse('@2021-01-01T12:12.toDateTime()');
      expect(
        await testEngine.evaluate(patient3, node),
        ['2021-01-01T12:12'.toFhirDateTime],
      );
      node = testEngine.parse("'2021-01-01T12:12'.toDateTime()");
      expect(
        await testEngine.evaluate(patient3, node),
        ['2021-01-01T12:12'.toFhirDateTime],
      );
    });
    test('convertsToDateTime', () async {
      var node = testEngine.parse('@2021-01-01.convertsToDateTime()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'2021-01-01'.convertsToDateTime()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('@2021-01-01T12:12.convertsToDateTime()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'2021-01-01T12:12'.convertsToDateTime()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
    });
    test('toDecimal', () async {
      var node = testEngine.parse("'1'.toDecimal()");
      expect(
        await testEngine.evaluate(patient3, node),
        [1.0.toFhirDecimal],
      );
      node = testEngine.parse("'true'.toDecimal()");
      expect(
        await testEngine.evaluate(patient3, node),
        <FhirBase>[1.toFhirDecimal],
      );
      node = testEngine.parse("'t'.toDecimal()");
      expect(
        await testEngine.evaluate(patient3, node),
        <FhirBase>[],
      );
      node = testEngine.parse("'yes'.toDecimal()");
      expect(
        await testEngine.evaluate(patient3, node),
        <FhirBase>[],
      );
      node = testEngine.parse("'y'.toDecimal()");
      expect(
        await testEngine.evaluate(patient3, node),
        <FhirBase>[],
      );
      node = testEngine.parse("'1.0'.toDecimal()");
      expect(
        await testEngine.evaluate(patient3, node),
        [1.0.toFhirDecimal],
      );
      node = testEngine.parse("'0'.toDecimal()");
      expect(
        await testEngine.evaluate(patient3, node),
        [0.0.toFhirDecimal],
      );
      node = testEngine.parse("'false'.toDecimal()");
      expect(
        await testEngine.evaluate(patient3, node),
        <FhirBase>[0.toFhirDecimal],
      );
      node = testEngine.parse("'f'.toDecimal()");
      expect(
        await testEngine.evaluate(patient3, node),
        <FhirBase>[],
      );
      node = testEngine.parse("'no'.toDecimal()");
      expect(
        await testEngine.evaluate(patient3, node),
        <FhirBase>[],
      );
      node = testEngine.parse("'n'.toDecimal()");
      expect(
        await testEngine.evaluate(patient3, node),
        <FhirBase>[],
      );
      node = testEngine.parse("'0.0'.toDecimal()");
      expect(
        await testEngine.evaluate(patient3, node),
        [0.0.toFhirDecimal],
      );
      node = testEngine.parse('1.toDecimal()');
      expect(
        await testEngine.evaluate(patient3, node),
        [1.0.toFhirDecimal],
      );
      node = testEngine.parse('0.toDecimal()');
      expect(
        await testEngine.evaluate(patient3, node),
        [0.0.toFhirDecimal],
      );
      node = testEngine.parse('1.0.toDecimal()');
      expect(
        await testEngine.evaluate(patient3, node),
        [1.0.toFhirDecimal],
      );
      node = testEngine.parse('0.0.toDecimal()');
      expect(
        await testEngine.evaluate(patient3, node),
        [0.0.toFhirDecimal],
      );
      node = testEngine.parse('true.toDecimal()');
      expect(
        await testEngine.evaluate(patient3, node),
        [1.0.toFhirDecimal],
      );
      node = testEngine.parse('false.toDecimal()');
      expect(
        await testEngine.evaluate(patient3, node),
        [0.0.toFhirDecimal],
      );
    });
    test('convertsToDecimal', () async {
      var node = testEngine.parse("'1'.convertsToDecimal()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'true'.convertsToDecimal()");
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse("'t'.convertsToDecimal()");
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse("'yes'.convertsToDecimal()");
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse("'y'.convertsToDecimal()");
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse("'1.0'.convertsToDecimal()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'0'.convertsToDecimal()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'false'.convertsToDecimal()");
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse("'f'.convertsToDecimal()");
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse("'no'.convertsToDecimal()");
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse("'n'.convertsToDecimal()");
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );
      node = testEngine.parse("'0.0'.convertsToDecimal()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('1.convertsToDecimal()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('0.convertsToDecimal()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('1.0.convertsToDecimal()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('0.0.convertsToDecimal()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('true.convertsToDecimal()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('false.convertsToDecimal()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
    });

    test('toQuantity', () async {
      var node = testEngine.parse("'4 days'.toQuantity()");
      expect(
        (await testEngine.evaluate(patient3, node)).first.toR4Json(),
        Quantity(
          value: 4.0.toFhirDecimal,
          system: 'http://unitsofmeasure.org'.toFhirUri,
          code: 'd'.toFhirCode,
        ).toJson(),
      );

      node = testEngine.parse(r"'10 \'mm[Hg]\''.toQuantity()");
      expect(
        (await testEngine.evaluate(patient3, node)).first.toR4Json(),
        Quantity(
          value: 10.0.toFhirDecimal,
          system: 'http://unitsofmeasure.org'.toFhirUri,
          code: 'mm[Hg]'.toFhirCode,
        ).toJson(),
      );
    });

    test('ConvertsToQuantity', () async {
      var node = testEngine.parse("'4 days'.convertsToQuantity()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );

      node = testEngine.parse(r"'10 \'mm[Hg]\''.convertsToQuantity()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
    });

    test('toString', () async {
      var node = testEngine.parse('true.toString()');
      expect(
        await testEngine.evaluate(patient3, node),
        ['true'.toFhirString],
      );
      node = testEngine.parse('false.toString()');
      expect(
        await testEngine.evaluate(patient3, node),
        ['false'.toFhirString],
      );
      node = testEngine.parse('1.toString()');
      expect(
        await testEngine.evaluate(patient3, node),
        ['1'.toFhirString],
      );
      node = testEngine.parse('111.toString()');
      expect(
        await testEngine.evaluate(patient3, node),
        ['111'.toFhirString],
      );
      node = testEngine.parse('1.1.toString()');
      expect(
        await testEngine.evaluate(patient3, node),
        ['1.1'.toFhirString],
      );
      node = testEngine.parse('111.1.toString()');
      expect(
        await testEngine.evaluate(patient3, node),
        ['111.1'.toFhirString],
      );
      node = testEngine.parse("1.1 'mg'.toString()");
      expect(
        await testEngine.evaluate(patient3, node),
        ["1.1 'mg'".toFhirString],
      );
      node = testEngine.parse("111.1 'mL'.toString()");
      expect(
        await testEngine.evaluate(patient3, node),
        ["111.1 'mL'".toFhirString],
      );
      node = testEngine.parse('@2019-08-01.toString()');
      expect(
        await testEngine.evaluate(patient3, node),
        ['2019-08-01'.toFhirString],
      );
      node = testEngine.parse('@2021-01-01T12:12.toString()');
      expect(
        await testEngine.evaluate(patient3, node),
        ['2021-01-01T12:12'.toFhirString],
      );
      node = testEngine.parse('@T12:12.toString()');
      expect(
        await testEngine.evaluate(patient3, node),
        ['12:12'.toFhirString],
      );
    });
    test('convertsToString', () async {
      var node = testEngine.parse('true.convertsToString()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('false.convertsToString()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('1.convertsToString()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('111.convertsToString()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('1.1.convertsToString()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('111.1.convertsToString()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("1.1 'mg'.convertsToString()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("111.1 'mL'.convertsToString()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('@2019-08-01.convertsToString()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('@2021-01-01T12:12.convertsToString()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('@T12:12.convertsToString()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
    });
    test('toTime', () async {
      var node = testEngine.parse('@T12:22.toTime()');
      expect(
        await testEngine.evaluate(patient3, node),
        [FhirTime('12:22')],
      );
      node = testEngine.parse('@T12:22:33.toTime()');
      expect(
        await testEngine.evaluate(patient3, node),
        [FhirTime('12:22:33')],
      );
      node = testEngine.parse("'12:22'.toTime()");
      expect(
        await testEngine.evaluate(patient3, node),
        [FhirTime('12:22')],
      );
      node = testEngine.parse("'12:22:33.321'.toTime()");
      expect(
        await testEngine.evaluate(patient3, node),
        [FhirTime('12:22:33.321')],
      );
    });
    test('convertsToTime', () async {
      var node = testEngine.parse('@T12:22.convertsToTime()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse('@T12:22:33.convertsToTime()');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'T12:22'.convertsToTime()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      node = testEngine.parse("'12:22:33.321'.convertsToTime()");
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
    });
    test('upper', () async {
      var node = testEngine.parse("'abcdefg'.upper() // 'ABCDEFG'");
      expect(
        await testEngine.evaluate(patient3, node),
        ['ABCDEFG'.toFhirString],
      );
      node = testEngine.parse("'AbCdefg'.upper() // 'ABCDEFG'");
      expect(
        await testEngine.evaluate(patient3, node),
        ['ABCDEFG'.toFhirString],
      );
    });
    test('lower', () async {
      var node = testEngine.parse("'ABCDEFG'.lower() // 'abcdefg'");
      expect(
        await testEngine.evaluate(patient3, node),
        ['abcdefg'.toFhirString],
      );
      node = testEngine.parse("'aBcDEFG'.lower() // 'abcdefg'");
      expect(
        await testEngine.evaluate(patient3, node),
        ['abcdefg'.toFhirString],
      );
    });
    test('Length', () async {
      var node = testEngine.parse('true.toString().length()');
      expect(
        await testEngine.evaluate(patient3, node),
        [4.toFhirInteger],
      );
      node = testEngine.parse('false.toString().length()');
      expect(
        await testEngine.evaluate(patient3, node),
        [5.toFhirInteger],
      );
      node = testEngine.parse('1.toString().length()');
      expect(
        await testEngine.evaluate(patient3, node),
        [1.toFhirInteger],
      );
      node = testEngine.parse('111.toString().length()');
      expect(
        await testEngine.evaluate(patient3, node),
        [3.toFhirInteger],
      );
      node = testEngine.parse('1.1.toString().length()');
      expect(
        await testEngine.evaluate(patient3, node),
        [3.toFhirInteger],
      );
      node = testEngine.parse('111.1.toString().length()');
      expect(
        await testEngine.evaluate(patient3, node),
        [5.toFhirInteger],
      );
      node = testEngine.parse("1.1 'mg'.toString().length()");
      expect(
        await testEngine.evaluate(patient3, node),
        [8.toFhirInteger],
      );
      node = testEngine.parse("111.1 'mL'.toString().length()");
      expect(
        await testEngine.evaluate(patient3, node),
        [10.toFhirInteger],
      );
      node = testEngine.parse('@2019-08-01.toString().length()');
      expect(
        await testEngine.evaluate(patient3, node),
        [10.toFhirInteger],
      );
      node = testEngine.parse('@2021-01-01T12:12.toString().length()');
      expect(
        await testEngine.evaluate(patient3, node),
        [16.toFhirInteger],
      );
      node = testEngine.parse('@T12:12.toString().length()');
      expect(
        await testEngine.evaluate(patient3, node),
        [5.toFhirInteger],
      );
    });
    test('toChars', () async {
      final node = testEngine.parse("'true'.toChars()");
      expect(
        await testEngine.evaluate(patient3, node),
        [
          't'.toFhirString,
          'r'.toFhirString,
          'u'.toFhirString,
          'e'.toFhirString,
        ],
      );
    });
    test('abs', () async {
      var node = testEngine.parse('(-5) // -5');
      expect(
        await testEngine.evaluate(patient3, node),
        [-5.toFhirInteger],
      );
      node = testEngine.parse('(-5).abs() // 5');
      expect(
        await testEngine.evaluate(patient3, node),
        [5.toFhirInteger],
      );
      node = testEngine.parse('(-5.5).abs() // 5.5');
      expect(
        await testEngine.evaluate(patient3, node),
        [5.5.toFhirDecimal],
      );
      node = testEngine.parse("today() + 5.5 'mg'");
      expect(
        () => testEngine.evaluate(patient3, node),
        throwsA(const TypeMatcher<PathEngineException>()),
      );

      node = testEngine.parse("(-5.5 'mg').abs() // 5.5 'mg'");
      expect(
        (await testEngine.evaluate(patient3, node)).first.toR4Json(),
        {'value': 5.5, 'system': 'http://unitsofmeasure.org', 'code': 'mg'},
      );
    });
    test('ceiling', () async {
      var node = testEngine.parse('1.ceiling() // 1');
      expect(
        await testEngine.evaluate(patient3, node),
        [1.toFhirInteger],
      );
      node = testEngine.parse('1.1.ceiling() // 2');
      expect(
        await testEngine.evaluate(patient3, node),
        [2.toFhirInteger],
      );
      node = testEngine.parse('(-1.1).ceiling() // -1');
      expect(
        await testEngine.evaluate(patient3, node),
        [-1.toFhirInteger],
      );
    });
    test('exp', () async {
      var node = testEngine.parse('0.exp() // 1.0');
      expect(
        await testEngine.evaluate(patient3, node),
        [1.0.toFhirDecimal],
      );
      node = testEngine.parse('(-0.0).exp() // 1.0');
      expect(
        await testEngine.evaluate(patient3, node),
        [1.0.toFhirDecimal],
      );
    });
    test('floor', () async {
      var node = testEngine.parse('1.floor() // 1');
      expect(
        await testEngine.evaluate(patient3, node),
        [1.toFhirInteger],
      );
      node = testEngine.parse('2.1.floor() // 2');
      expect(
        await testEngine.evaluate(patient3, node),
        [2.toFhirInteger],
      );
      node = testEngine.parse('(-2.1).floor() // -3');
      expect(
        await testEngine.evaluate(patient3, node),
        [-3.toFhirInteger],
      );
    });
    test('ln', () async {
      var node = testEngine.parse('1.ln() // 0.0');
      expect(
        await testEngine.evaluate(patient3, node),
        [0.0.toFhirDecimal],
      );
      node = testEngine.parse('1.0.ln() // 0.0');
      expect(
        await testEngine.evaluate(patient3, node),
        [0.0.toFhirDecimal],
      );
    });
    test('log', () async {
      var node = testEngine.parse('16.log(2) // 4.0');
      expect(
        await testEngine.evaluate(patient3, node),
        [4.0.toFhirDecimal],
      );
      node = testEngine.parse('100.0.log(10.0) // 2.0');
      expect(
        await testEngine.evaluate(patient3, node),
        [2.0.toFhirDecimal],
      );
    });
    test('sqrt', () async {
      var node = testEngine.parse('81.sqrt() // 9.0');
      expect(
        await testEngine.evaluate(patient3, node),
        [9.0.toFhirDecimal],
      );
      node = testEngine.parse('(-1).sqrt() // empty');
      expect(
        await testEngine.evaluate(patient3, node),
        <FhirBase>[],
      );
    });
    test('truncate', () async {
      var node = testEngine.parse('101.truncate() // 101');
      expect(
        await testEngine.evaluate(patient3, node),
        [101.toFhirInteger],
      );
      node = testEngine.parse('1.00000001.truncate() // 1');
      expect(
        await testEngine.evaluate(patient3, node),
        [1.toFhirInteger],
      );
      node = testEngine.parse('(-1.56).truncate() // -1');
      expect(
        await testEngine.evaluate(patient3, node),
        [-1.toFhirInteger],
      );
    });
    test('children', () async {
      var node = testEngine.parse('Patient.name.children()');
      expect(await testEngine.evaluate(patient3, node), [
        NameUse.official,
        'Faulkenberry'.toFhirString,
        'Jason'.toFhirString,
        'Grey'.toFhirString,
        NameUse.official,
        'Faulkenberry'.toFhirString,
        'Jason'.toFhirString,
        'Grey'.toFhirString,
        'Niel'.toFhirString,
        'Kristin'.toFhirString,
        'Smith'.toFhirString,
        'John'.toFhirString,
        'Jacob'.toFhirString,
        'Jingleheimer'.toFhirString,
      ]);
      node = testEngine.parse('Patient.address.children()');
      expect(
          (await testEngine.evaluate(patient3, node))
              .map((e) => (e as FhirBase).toJson())
              .toList(),
          [
            {
              'extension': [
                {
                  'url': 'www.mayjuun.com',
                  'valueCount': {'unit': 'Mg'},
                },
                {
                  'url': 'www.mayjuun.com',
                  'valueCount': {'unit': 'mL'},
                }
              ],
            },
            {
              'extension': [
                {
                  'extension': [
                    {
                      'extension': [
                        {
                          'extension': [
                            {
                              'url': 'www.mayjuun.com',
                              'valueCount': {'unit': 'Kg'},
                            },
                            {
                              'url': 'www.mayjuun.com',
                              'valueCount': {'unit': 'Km'},
                            }
                          ],
                          'url': 'www.mayjuun.com',
                          'valueCount': {'unit': 'Kg'},
                        },
                        {
                          'url': 'www.mayjuun.com',
                          'valueCount': {'unit': 'Km'},
                        }
                      ],
                      'url': 'www.mayjuun.com',
                      'valueCount': {'unit': 'Kg'},
                    },
                    {
                      'url': 'www.mayjuun.com',
                      'valueCount': {'unit': 'Km'},
                    }
                  ],
                  'url': 'www.mayjuun.com',
                  'valueCount': {'unit': 'Kg'},
                },
                {
                  'url': 'www.mayjuun.com',
                  'valueCount': {'unit': 'Km'},
                }
              ],
            },
            {
              'extension': [
                {
                  'url': 'www.mayjuun.com',
                  'valueCount': {'unit': 'Feet'},
                },
                {
                  'url': 'www.mayjuun.com',
                  'valueCount': {'unit': 'inches'},
                }
              ],
            }
          ]);
    });
    test('Descendants', () async {
      var node = testEngine.parse('Patient.name.descendants()');
      expect(await testEngine.evaluate(patient3, node), [
        NameUse.official,
        'Faulkenberry'.toFhirString,
        'Jason'.toFhirString,
        'Grey'.toFhirString,
        NameUse.official,
        'Faulkenberry'.toFhirString,
        'Jason'.toFhirString,
        'Grey'.toFhirString,
        'Niel'.toFhirString,
        'Kristin'.toFhirString,
        'Smith'.toFhirString,
        'John'.toFhirString,
        'Jacob'.toFhirString,
        'Jingleheimer'.toFhirString,
      ]);
      node =
          testEngine.parse('Patient.address[1].period.extension.descendants()');
      expect(
          (await testEngine.evaluate(patient3, node))
              .map(
                (e) => e is PrimitiveType
                    ? e.primitiveValue
                    : (e as FhirBase).toJson(),
              )
              .toList(),
          [
            {
              'extension': [
                {
                  'extension': [
                    {
                      'url': 'www.mayjuun.com',
                      'valueCount': {'unit': 'Kg'},
                    },
                    {
                      'url': 'www.mayjuun.com',
                      'valueCount': {'unit': 'Km'},
                    }
                  ],
                  'url': 'www.mayjuun.com',
                  'valueCount': {'unit': 'Kg'},
                },
                {
                  'url': 'www.mayjuun.com',
                  'valueCount': {'unit': 'Km'},
                }
              ],
              'url': 'www.mayjuun.com',
              'valueCount': {'unit': 'Kg'},
            },
            {
              'url': 'www.mayjuun.com',
              'valueCount': {'unit': 'Km'},
            },
            'www.mayjuun.com',
            {'unit': 'Kg'},
            'www.mayjuun.com',
            {'unit': 'Km'},
            {
              'extension': [
                {
                  'url': 'www.mayjuun.com',
                  'valueCount': {'unit': 'Kg'},
                },
                {
                  'url': 'www.mayjuun.com',
                  'valueCount': {'unit': 'Km'},
                }
              ],
              'url': 'www.mayjuun.com',
              'valueCount': {'unit': 'Kg'},
            },
            {
              'url': 'www.mayjuun.com',
              'valueCount': {'unit': 'Km'},
            },
            'www.mayjuun.com',
            {'unit': 'Kg'},
            'www.mayjuun.com',
            {'unit': 'Km'},
            'Kg',
            'Km',
            {
              'url': 'www.mayjuun.com',
              'valueCount': {'unit': 'Kg'},
            },
            {
              'url': 'www.mayjuun.com',
              'valueCount': {'unit': 'Km'},
            },
            'www.mayjuun.com',
            {'unit': 'Kg'},
            'www.mayjuun.com',
            {'unit': 'Km'},
            'Kg',
            'Km',
            'www.mayjuun.com',
            {'unit': 'Kg'},
            'www.mayjuun.com',
            {'unit': 'Km'},
            'Kg',
            'Km',
            'Kg',
            'Km',
          ]);
    });

    test('DateTimeFunctions', () async {
      final startNow = DateTime.now();
      var node = testEngine.parse('now()');
      final resultNow = (await testEngine.evaluate(patient3, node)).first;
      final endNow = DateTime.now();
      expect(
        (startNow.isBefore(toDateTime(resultNow)) ||
                startNow.isAtSameMomentAs(toDateTime(resultNow))) &&
            (endNow.isAfter(toDateTime(resultNow)) ||
                endNow.isAtSameMomentAs(toDateTime(resultNow))),
        true,
      );

      final startTimeOfDay = FhirTime(
        DateTime.now().toIso8601String().split('T').last,
      );
      node = testEngine.parse('timeOfDay()');
      final resultTimeOfDay = (await testEngine.evaluate(patient3, node)).first;
      final endTimeOfDay = FhirTime(
        DateTime.now().toIso8601String().split('T').last,
      );

      expect(
        (startTimeOfDay <= (resultTimeOfDay as FhirTime) ?? false) &&
            (endTimeOfDay >= resultTimeOfDay ?? false),
        true,
      );

      node = testEngine.parse('today()');
      expect(
        (await testEngine.evaluate(patient3, node)).first,
        FhirDate.fromString(DateTime.now().toIso8601String().split('T').first),
      );
    });
  });
}

DateTime toDateTime(dynamic dateTime) => dateTime is DateTime
    ? dateTime
    : dateTime is FhirDateTimeBase
        ? dateTime.valueDateTime!
        : DateTime.now();

import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_r4_path/fhir_r4_path.dart';

import 'package:test/test.dart';

import 'test_data.dart';

Future<void> testBasicTypes() async {
  final testEngine = await FHIRPathEngine.create(WorkerContext());
  group('FHIRPathEngine Basic Types Tests', () {
    test('Boolean', () async {
      expect(testEngine.parse('true').constant, true.toFhirBoolean);
      expect(testEngine.parse('false').constant, false.toFhirBoolean);
    });

    test('String', () async {
      expect(
        testEngine.parse("'test string'").constant,
        'test string'.toFhirString,
      );
      expect(
        testEngine.parse("'urn:oid:3.4.5.6.7.8'").constant,
        'urn:oid:3.4.5.6.7.8'.toFhirString,
      );
    });

    test('Delimited Identifier', () async {
      expect(testEngine.parse('`test string`').name, 'test string');
      expect(
        testEngine.parse('`urn:oid:3.4.5.6.7.8`').name,
        'urn:oid:3.4.5.6.7.8',
      );
    });

    test('Integer', () async {
      expect(testEngine.parse('0').constant, 0.toFhirInteger);
      expect(testEngine.parse('45').constant, 45.toFhirInteger);
      // Uncomment if negative integers are supported
      final node = testEngine.parse('-5');
      expect(node.operation, FpOperation.Minus);
      expect(node.opNext?.constant, equals(5.toFhirInteger));
    });

    test('Decimal', () async {
      expect(testEngine.parse('0.0').constant, 0.0.toFhirDecimal);
      expect(testEngine.parse('3.1415927').constant, 3.1415927.toFhirDecimal);
    });

    test('Date', () async {
      final node1 = testEngine.parse('@2015-02-04');
      expect(
        (node1.constant as FHIRConstant?)?.value,
        equals(FhirDate.fromString('2015-02-04')),
      );

      final node2 = testEngine.parse('@2018-06-12');
      expect(
        (node2.constant as FHIRConstant?)?.value,
        equals(FhirDate.fromString('2018-06-12')),
      );

      final node3 = testEngine.parse('@2018-06');
      expect(
        (node3.constant as FHIRConstant?)?.value,
        equals(FhirDate.fromString('2018-06')),
      );

      final node4 = testEngine.parse('@2018');
      expect(
        (node4.constant as FHIRConstant?)?.value,
        equals(FhirDate.fromString('2018')),
      );
    });

    test('DateTime', () async {
      const dateTime1 = '@2015-02-04T14:34:28+09:00';
      final node1 = testEngine.parse(dateTime1);
      expect(
        (node1.constant as FHIRConstant?)?.value,
        dateTime1,
      );

      const dateTime2 = '@2018-02-04T14:38:28+09:00';
      final node2 = testEngine.parse(dateTime2);
      expect(
        (node2.constant as FHIRConstant?)?.value,
        dateTime2,
      );

      const dateTime3 = '@2018-02-04T14:38:28.559+09:00';
      final node3 = testEngine.parse(dateTime3);
      expect(
        (node3.constant as FHIRConstant?)?.value,
        dateTime3,
      );
    });

    test('Time', () async {
      const time1 = '@14:34:28';
      final node1 = testEngine.parse(time1);
      expect(
        (node1.constant as FHIRConstant?)?.value,
        time1,
      );

      const time2 = '@T06:55:28.559';
      final node2 = testEngine.parse(time2);
      expect(
        (node2.constant as FHIRConstant?)?.value,
        time2,
      );

      const time3 = '@T06:55';
      final node3 = testEngine.parse(time3);
      expect(
        (node3.constant as FHIRConstant?)?.value,
        time3,
      );
    });

    test('Quantity', () async {
      expect(
        testEngine.parse("4.5 'mg'").constant?.toR4Json(),
        Quantity(
          value: 4.5.toFhirDecimal,
          system: 'http://unitsofmeasure.org'.toFhirUri,
          code: 'mg'.toFhirCode,
        ).toJson(),
      );
      expect(
        testEngine.parse("100 '[degF]'").constant?.toR4Json(),
        Quantity(
          code: '[degF]'.toFhirCode,
          system: 'http://unitsofmeasure.org'.toFhirUri,
          value: 100.toFhirDecimal,
        ).toJson(),
      );
    });

    // test('Duration Quantities', () async {
    //   expect(testEngine.parse('1 seconds = 1 second'), [true.toFhirBoolean]);
    //   expect(testEngine.parse("1 seconds = 1 's'"), [true.toFhirBoolean]);
    //   expect(testEngine.parse("2 seconds = 2 's'"), [true.toFhirBoolean]);
    //   expect(testEngine.parse("1 week != 1 'wk'"), [false.toFhirBoolean]);
    // });

    test('Non-Escape Sequences', () async {
      expect(
        testEngine.parse(r"'\p'").constant,
        'p'.toFhirString,
      ); // '\p' -> 'p'
      expect(
        testEngine.parse(r"'\\p'").constant,
        r'\p'.toFhirString,
      ); // '\\p' -> '\p'
      expect(
        testEngine.parse(r"'\3'").constant,
        '3'.toFhirString,
      ); // '\3' -> '3'
      expect(
        testEngine.parse(r"'\u005'").constant,
        'u005'.toFhirString,
      ); // '\u005' -> 'u005'
      // TODO(Dokotela): Uncomment when escape sequences are supported
      // expect( testEngine.parse(r"'\'").constant, ''.toFhirString); // '\'' -> ''
    });
  });
}

import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_r4_path/fhir_r4_path.dart';
import 'package:test/test.dart';

import 'test_data.dart';

Future<void> testBasicOperators() async {
  final testEngine = await FHIRPathEngine.create(WorkerContext());
  group('Operators: ', () {
    test('= : ', () async {
      final node = testEngine.parse('10 = 10');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );
      // Equality with numbers
      final node1 = testEngine.parse('10 = 9');
      expect(
        await testEngine.evaluate(patient3, node1),
        [false.toFhirBoolean],
      );

      final node2 = testEngine.parse('10.0 = 10');
      expect(
        await testEngine.evaluate(patient3, node2),
        [true.toFhirBoolean],
      );

      final node3 = testEngine.parse('10.9 = 9.1');
      expect(
        await testEngine.evaluate(patient3, node3),
        [false.toFhirBoolean],
      );

      final node4 = testEngine.parse('10.9 = 10.9');
      expect(
        await testEngine.evaluate(patient3, node4),
        [true.toFhirBoolean],
      );

      // Equality with booleans
      final node5 = testEngine.parse('true = true');
      expect(
        await testEngine.evaluate(patient3, node5),
        [true.toFhirBoolean],
      );

      final node6 = testEngine.parse('false = true');
      expect(
        await testEngine.evaluate(patient3, node6),
        [false.toFhirBoolean],
      );

      // Equality with dates
      final node7 = testEngine.parse('@2021 = @2021');
      expect(
        await testEngine.evaluate(patient3, node7),
        [true.toFhirBoolean],
      );

      final node8 = testEngine.parse('@2021 = @2020');
      expect(
        await testEngine.evaluate(patient3, node8),
        [false.toFhirBoolean],
      );

      final node9 = testEngine.parse('@2021-06-06 = @2021-06-06');
      expect(
        await testEngine.evaluate(patient3, node9),
        [true.toFhirBoolean],
      );

      final node10 = testEngine.parse('@2021-06-06 = @2021-05-06');
      expect(
        await testEngine.evaluate(patient3, node10),
        [false.toFhirBoolean],
      );

      final node11 = testEngine.parse('@2021-06-06T12:36 = @2021-06-06T12:36');
      expect(
        await testEngine.evaluate(patient3, node11),
        [true.toFhirBoolean],
      );

      final node12 = testEngine.parse('@2021-06-06T12:36 = @2021-05-06T12:35');
      expect(
        await testEngine.evaluate(patient3, node12),
        [false.toFhirBoolean],
      );

      final node13 =
          testEngine.parse('@2012-01-01T10:30:31.0 = @2012-01-01T10:30:31');
      expect(
        await testEngine.evaluate(patient3, node13),
        [true.toFhirBoolean],
      );

      final node14 =
          testEngine.parse('@2012-01-01T10:30:31.1 = @2012-01-01T10:30:31');
      expect(
        await testEngine.evaluate(patient3, node14),
        [false.toFhirBoolean],
      );

      final node15 = testEngine.parse('@T12:25 = @T12:25');
      expect(
        await testEngine.evaluate(patient3, node15),
        [true.toFhirBoolean],
      );

      final node16 = testEngine.parse('@T12:25 = @T12:27');
      expect(
        await testEngine.evaluate(patient3, node16),
        [false.toFhirBoolean],
      );

      // Equality with strings
      final node17 = testEngine.parse("'String' = 'String'");
      expect(
        await testEngine.evaluate(patient3, node17),
        [true.toFhirBoolean],
      );

      final node18 = testEngine.parse("'String' = 'string'");
      expect(
        await testEngine.evaluate(patient3, node18),
        [false.toFhirBoolean],
      );

      // Additional cases
      final node19 = testEngine.parse('@2012 = @2012');
      expect(
        await testEngine.evaluate(patient3, node19),
        [true.toFhirBoolean],
      );

      final node20 = testEngine.parse('@2012 = @2013');
      expect(
        await testEngine.evaluate(patient3, node20),
        [false.toFhirBoolean],
      );

      final node21 = testEngine.parse('@2012-01 = @2012');
      expect(
        await testEngine.evaluate(patient3, node21),
        <FhirBase>[],
      );

      final node22 = testEngine.parse('@2012-01-01T10:30 = @2012-01-01T10:30');
      expect(
        await testEngine.evaluate(patient3, node22),
        [true.toFhirBoolean],
      );

      final node23 = testEngine.parse('@2012-01-01T10:30 = @2012-01-01T10:31');
      expect(
        await testEngine.evaluate(patient3, node23),
        [false.toFhirBoolean],
      );

      final node24 =
          testEngine.parse('@2012-01-01T10:30:31 = @2012-01-01T10:30');
      expect(
        await testEngine.evaluate(patient3, node24),
        <FhirBase>[],
      );

      final node25 =
          testEngine.parse('@2012-01-01T10:30:31.0 = @2012-01-01T10:30:31');
      expect(
        await testEngine.evaluate(patient3, node25),
        [true.toFhirBoolean],
      );

      final node26 =
          testEngine.parse('@2012-01-01T10:30:31.1 = @2012-01-01T10:30:31');
      expect(
        await testEngine.evaluate(patient3, node26),
        [false.toFhirBoolean],
      );
    });

    group('Operators: ', () {
      test('~ : ', () async {
        final node = testEngine.parse('{} ~ {}');
        expect(
          await testEngine.evaluate(patient3, node),
          [true.toFhirBoolean],
        );

        final node1 = testEngine.parse('10 ~ 10');
        expect(
          await testEngine.evaluate(patient3, node1),
          [true.toFhirBoolean],
        );

        final node2 = testEngine.parse('10 ~ 9');
        expect(
          await testEngine.evaluate(patient3, node2),
          [false.toFhirBoolean],
        );

        final node3 = testEngine.parse('10.0 ~ 10');
        expect(
          await testEngine.evaluate(patient3, node3),
          [true.toFhirBoolean],
        );

        final node4 = testEngine.parse('10.9 ~ 9.1');
        expect(
          await testEngine.evaluate(patient3, node4),
          [false.toFhirBoolean],
        );

        final node5 = testEngine.parse('10.9 ~ 10.9');
        expect(
          await testEngine.evaluate(patient3, node5),
          [true.toFhirBoolean],
        );

        final node6 = testEngine.parse('true ~ true');
        expect(
          await testEngine.evaluate(patient3, node6),
          [true.toFhirBoolean],
        );

        final node7 = testEngine.parse('false ~ true');
        expect(
          await testEngine.evaluate(patient3, node7),
          [false.toFhirBoolean],
        );

        final node8 = testEngine.parse('@2012 ~ @2012');
        expect(
          await testEngine.evaluate(patient3, node8),
          [true.toFhirBoolean],
        );

        final node9 = testEngine.parse('@2012 ~ @2013');
        expect(
          await testEngine.evaluate(patient3, node9),
          [false.toFhirBoolean],
        );

        final node10 = testEngine.parse('@2021-06-06 ~ @2021-06-06');
        expect(
          await testEngine.evaluate(patient3, node10),
          [true.toFhirBoolean],
        );

        final node11 = testEngine.parse('@2021-06-06 ~ @2021-05-06');
        expect(
          await testEngine.evaluate(patient3, node11),
          [false.toFhirBoolean],
        );

        final node12 =
            testEngine.parse('@2021-06-06T12:36 ~ @2021-06-06T12:36');
        expect(
          await testEngine.evaluate(patient3, node12),
          [true.toFhirBoolean],
        );

        final node13 =
            testEngine.parse('@2021-06-06T12:36 ~ @2021-05-06T12:35');
        expect(
          await testEngine.evaluate(patient3, node13),
          [false.toFhirBoolean],
        );

        final node14 =
            testEngine.parse('@2012-01-01T10:30:31.0 ~ @2012-01-01T10:30:31');
        expect(
          await testEngine.evaluate(patient3, node14),
          [true.toFhirBoolean],
        );

        final node15 =
            testEngine.parse('@2012-01-01T10:30:31.1 ~ @2012-01-01T10:30:31');
        expect(
          await testEngine.evaluate(patient3, node15),
          [false.toFhirBoolean],
        );

        final node16 = testEngine.parse('@T12:25 ~ @T12:25');
        expect(
          await testEngine.evaluate(patient3, node16),
          [true.toFhirBoolean],
        );

        final node17 = testEngine.parse('@T12:25 ~ @T12:27');
        expect(
          await testEngine.evaluate(patient3, node17),
          [false.toFhirBoolean],
        );

        final node18 = testEngine.parse("'String' ~ 'String'");
        expect(
          await testEngine.evaluate(patient3, node18),
          [true.toFhirBoolean],
        );

        final node19 = testEngine.parse("'String' ~ 'string'");
        expect(
          await testEngine.evaluate(patient3, node19),
          [true.toFhirBoolean],
        );

        final node20 = testEngine.parse('@2012-01 ~ @2012');
        expect(
          await testEngine.evaluate(patient3, node20),
          <FhirBase>[false.toFhirBoolean],
        );

        final node21 =
            testEngine.parse('@2012-01-01T10:30 ~ @2012-01-01T10:30');
        expect(
          await testEngine.evaluate(patient3, node21),
          [true.toFhirBoolean],
        );

        final node22 =
            testEngine.parse('@2012-01-01T10:30 ~ @2012-01-01T10:31');
        expect(
          await testEngine.evaluate(patient3, node22),
          [false.toFhirBoolean],
        );

        final node23 =
            testEngine.parse('@2012-01-01T10:30:31 ~ @2012-01-01T10:30');
        expect(
          await testEngine.evaluate(patient3, node23),
          <FhirBase>[false.toFhirBoolean],
        );

        final node24 =
            testEngine.parse('@2012-01-01T10:30:31.0 ~ @2012-01-01T10:30:31');
        expect(
          await testEngine.evaluate(patient3, node24),
          [true.toFhirBoolean],
        );

        final node25 =
            testEngine.parse('@2012-01-01T10:30:31.1 ~ @2012-01-01T10:30:31');
        expect(
          await testEngine.evaluate(patient3, node25),
          [false.toFhirBoolean],
        );

        final node26 = testEngine.parse("1 year ~ 1 'a'");
        expect(
          await testEngine.evaluate(patient3, node26),
          [true.toFhirBoolean],
        );

        final node27 = testEngine.parse("1 second ~ 1 's'");
        expect(
          await testEngine.evaluate(patient3, node27),
          [true.toFhirBoolean],
        );
      });
    });

    test('!= : ', () async {
      final node = testEngine.parse('10 != 10');
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );

      final node1 = testEngine.parse('10 != 9');
      expect(
        await testEngine.evaluate(patient3, node1),
        [true.toFhirBoolean],
      );

      final node2 = testEngine.parse('10.0 != 10');
      expect(
        await testEngine.evaluate(patient3, node2),
        [false.toFhirBoolean],
      );

      final node3 = testEngine.parse('10.9 != 9.1');
      expect(
        await testEngine.evaluate(patient3, node3),
        [true.toFhirBoolean],
      );

      final node4 = testEngine.parse('10.9 != 10.9');
      expect(
        await testEngine.evaluate(patient3, node4),
        [false.toFhirBoolean],
      );

      final node5 = testEngine.parse('true != true');
      expect(
        await testEngine.evaluate(patient3, node5),
        [false.toFhirBoolean],
      );

      final node6 = testEngine.parse('false != true');
      expect(
        await testEngine.evaluate(patient3, node6),
        [true.toFhirBoolean],
      );

      final node7 = testEngine.parse('@2021 != @2021');
      expect(
        await testEngine.evaluate(patient3, node7),
        [false.toFhirBoolean],
      );

      final node8 = testEngine.parse('@2021 != @2020');
      expect(
        await testEngine.evaluate(patient3, node8),
        [true.toFhirBoolean],
      );

      final node9 = testEngine.parse('@2021-06-06 != @2021-06-06');
      expect(
        await testEngine.evaluate(patient3, node9),
        [false.toFhirBoolean],
      );

      final node10 = testEngine.parse('@2021-06-06 != @2021-05-06');
      expect(
        await testEngine.evaluate(patient3, node10),
        [true.toFhirBoolean],
      );

      final node11 = testEngine.parse('@2021-06-06T12:36 != @2021-06-06T12:36');
      expect(
        await testEngine.evaluate(patient3, node11),
        [false.toFhirBoolean],
      );

      final node12 = testEngine.parse('@2021-06-06T12:36 != @2021-05-06T12:35');
      expect(
        await testEngine.evaluate(patient3, node12),
        [true.toFhirBoolean],
      );

      final node13 =
          testEngine.parse('@2012-01-01T10:30:31.0 != @2012-01-01T10:30:31');
      expect(
        await testEngine.evaluate(patient3, node13),
        [false.toFhirBoolean],
      );

      final node14 =
          testEngine.parse('@2012-01-01T10:30:31.1 != @2012-01-01T10:30:31');
      expect(
        await testEngine.evaluate(patient3, node14),
        [true.toFhirBoolean],
      );

      final node15 = testEngine.parse('@T12:25 != @T12:25');
      expect(
        await testEngine.evaluate(patient3, node15),
        [false.toFhirBoolean],
      );

      final node16 = testEngine.parse('@T12:25 != @T12:27');
      expect(
        await testEngine.evaluate(patient3, node16),
        [true.toFhirBoolean],
      );

      final node17 = testEngine.parse("'String' != 'String'");
      expect(
        await testEngine.evaluate(patient3, node17),
        [false.toFhirBoolean],
      );

      final node18 = testEngine.parse("'String' != 'string'");
      expect(
        await testEngine.evaluate(patient3, node18),
        [true.toFhirBoolean],
      );
    });

    test('!~ : ', () async {
      final node = testEngine.parse('{} !~ {}');
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );

      final node1 = testEngine.parse('10 !~ 10');
      expect(
        await testEngine.evaluate(patient3, node1),
        [false.toFhirBoolean],
      );

      final node2 = testEngine.parse('10 !~ 9');
      expect(
        await testEngine.evaluate(patient3, node2),
        [true.toFhirBoolean],
      );

      final node3 = testEngine.parse('10.0 !~ 10');
      expect(
        await testEngine.evaluate(patient3, node3),
        [false.toFhirBoolean],
      );

      final node4 = testEngine.parse('10.9 !~ 9.1');
      expect(
        await testEngine.evaluate(patient3, node4),
        [true.toFhirBoolean],
      );

      final node5 = testEngine.parse('10.9 !~ 10.9');
      expect(
        await testEngine.evaluate(patient3, node5),
        [false.toFhirBoolean],
      );

      final node6 = testEngine.parse('true !~ true');
      expect(
        await testEngine.evaluate(patient3, node6),
        [false.toFhirBoolean],
      );

      final node7 = testEngine.parse('false !~ true');
      expect(
        await testEngine.evaluate(patient3, node7),
        [true.toFhirBoolean],
      );

      final node8 = testEngine.parse('@2012 !~ @2012');
      expect(
        await testEngine.evaluate(patient3, node8),
        [false.toFhirBoolean],
      );

      final node9 = testEngine.parse('@2012 !~ @2013');
      expect(
        await testEngine.evaluate(patient3, node9),
        [true.toFhirBoolean],
      );

      final node10 = testEngine.parse('@2021-06-06 !~ @2021-06-06');
      expect(
        await testEngine.evaluate(patient3, node10),
        [false.toFhirBoolean],
      );

      final node11 = testEngine.parse('@2021-06-06 !~ @2021-05-06');
      expect(
        await testEngine.evaluate(patient3, node11),
        [true.toFhirBoolean],
      );

      final node12 = testEngine.parse('@2021-06-06T12:36 !~ @2021-06-06T12:36');
      expect(
        await testEngine.evaluate(patient3, node12),
        [false.toFhirBoolean],
      );

      final node13 = testEngine.parse('@2021-06-06T12:36 !~ @2021-05-06T12:35');
      expect(
        await testEngine.evaluate(patient3, node13),
        [true.toFhirBoolean],
      );

      final node14 =
          testEngine.parse('@2012-01-01T10:30:31.0 !~ @2012-01-01T10:30:31');
      expect(
        await testEngine.evaluate(patient3, node14),
        [false.toFhirBoolean],
      );

      final node15 =
          testEngine.parse('@2012-01-01T10:30:31.1 !~ @2012-01-01T10:30:31');
      expect(
        await testEngine.evaluate(patient3, node15),
        [true.toFhirBoolean],
      );

      final node16 = testEngine.parse('@T12:25 !~ @T12:25');
      expect(
        await testEngine.evaluate(patient3, node16),
        [false.toFhirBoolean],
      );

      final node17 = testEngine.parse('@T12:25 !~ @T12:27');
      expect(
        await testEngine.evaluate(patient3, node17),
        [true.toFhirBoolean],
      );

      final node18 = testEngine.parse("'String' !~ 'String'");
      expect(
        await testEngine.evaluate(patient3, node18),
        [false.toFhirBoolean],
      );

      final node19 = testEngine.parse("'String' !~ 'string'");
      expect(
        await testEngine.evaluate(patient3, node19),
        [false.toFhirBoolean],
      );

      final node20 = testEngine.parse('@2012-01 !~ @2012');
      expect(
        await testEngine.evaluate(patient3, node20),
        [true.toFhirBoolean],
      );

      final node21 = testEngine.parse('@2012-01-01T10:30 !~ @2012-01-01T10:30');
      expect(
        await testEngine.evaluate(patient3, node21),
        [false.toFhirBoolean],
      );

      final node22 = testEngine.parse('@2012-01-01T10:30 !~ @2012-01-01T10:31');
      expect(
        await testEngine.evaluate(patient3, node22),
        [true.toFhirBoolean],
      );

      final node23 =
          testEngine.parse('@2012-01-01T10:30:31 !~ @2012-01-01T10:30');
      expect(
        await testEngine.evaluate(patient3, node23),
        [true.toFhirBoolean],
      );

      final node24 =
          testEngine.parse('@2012-01-01T10:30:31.0 !~ @2012-01-01T10:30:31');
      expect(
        await testEngine.evaluate(patient3, node24),
        [false.toFhirBoolean],
      );

      final node25 =
          testEngine.parse('@2012-01-01T10:30:31.1 !~ @2012-01-01T10:30:31');
      expect(
        await testEngine.evaluate(patient3, node25),
        [true.toFhirBoolean],
      );

      final node26 = testEngine.parse("1 year !~ 1 'a'");
      expect(
        await testEngine.evaluate(patient3, node26),
        [false.toFhirBoolean],
      );

      final node27 = testEngine.parse("1 second !~ 1 's'");
      expect(
        await testEngine.evaluate(patient3, node27),
        [false.toFhirBoolean],
      );
    });
    test('> : ', () async {
      final node = testEngine.parse('@T12:25 > @T12:25');
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );

      final node1 = testEngine.parse('@T12:27 > @T12:25');
      expect(
        await testEngine.evaluate(patient3, node1),
        [true.toFhirBoolean],
      );

      final node2 = testEngine.parse("'String' > 'String'");
      expect(
        await testEngine.evaluate(patient3, node2),
        [false.toFhirBoolean],
      );

      final node3 = testEngine.parse("'string' > 'String'");
      expect(
        await testEngine.evaluate(patient3, node3),
        [true.toFhirBoolean],
      );

      final node4 = testEngine.parse('10 > 5');
      expect(
        await testEngine.evaluate(patient3, node4),
        [true.toFhirBoolean],
      );

      final node5 = testEngine.parse('10 > 5.0');
      expect(
        await testEngine.evaluate(patient3, node5),
        [true.toFhirBoolean],
      );

      final node6 = testEngine.parse("'abc' > 'ABC'");
      expect(
        await testEngine.evaluate(patient3, node6),
        [true.toFhirBoolean],
      );

      final node7 = testEngine.parse("4 'm' > 4 'cm'");
      expect(
        await testEngine.evaluate(patient3, node7),
        [true.toFhirBoolean],
      );

      final node8 = testEngine.parse('@2018-03-01 > @2018-01-01');
      expect(
        await testEngine.evaluate(patient3, node8),
        [true.toFhirBoolean],
      );

      final node9 = testEngine.parse('@2018-03 > @2018-03-01');
      expect(
        await testEngine.evaluate(patient3, node9),
        <FhirBase>[],
      );

      final node10 =
          testEngine.parse('@2018-03-01T10:30:00 > @2018-03-01T10:00:00');
      expect(
        await testEngine.evaluate(patient3, node10),
        [true.toFhirBoolean],
      );

      final node11 = testEngine.parse('@2018-03-01T10 > @2018-03-01T10:30');
      expect(
        await testEngine.evaluate(patient3, node11),
        <FhirBase>[],
      );

      final node12 =
          testEngine.parse('@2018-03-01T10:30:00 > @2018-03-01T10:30:00.0');
      expect(
        await testEngine.evaluate(patient3, node12),
        [false.toFhirBoolean],
      );

      final node13 = testEngine.parse('@T10:30:00 > @T10:00:00');
      expect(
        await testEngine.evaluate(patient3, node13),
        [true.toFhirBoolean],
      );

      final node14 = testEngine.parse('@T10 > @T10:30');
      expect(
        await testEngine.evaluate(patient3, node14),
        <FhirBase>[],
      );

      final node15 = testEngine.parse('@T10:30:00 > @T10:30:00.0');
      expect(
        await testEngine.evaluate(patient3, node15),
        [false.toFhirBoolean],
      );
    });

    test('< : ', () async {
      final node = testEngine.parse('@T12:25 < @T12:25');
      expect(
        await testEngine.evaluate(patient3, node),
        [false.toFhirBoolean],
      );

      final node1 = testEngine.parse('@T12:27 < @T12:25');
      expect(
        await testEngine.evaluate(patient3, node1),
        [false.toFhirBoolean],
      );

      final node2 = testEngine.parse("'String' < 'String'");
      expect(
        await testEngine.evaluate(patient3, node2),
        [false.toFhirBoolean],
      );

      final node3 = testEngine.parse("'String' < 'string'");
      expect(
        await testEngine.evaluate(patient3, node3),
        [true.toFhirBoolean],
      );

      final node4 = testEngine.parse("'string' < 'String'");
      expect(
        await testEngine.evaluate(patient3, node4),
        [false.toFhirBoolean],
      );

      final node5 = testEngine.parse('10 < 5');
      expect(
        await testEngine.evaluate(patient3, node5),
        [false.toFhirBoolean],
      );

      final node6 = testEngine.parse('10 < 5.0');
      expect(
        await testEngine.evaluate(patient3, node6),
        [false.toFhirBoolean],
      );

      final node7 = testEngine.parse("'abc' < 'ABC'");
      expect(
        await testEngine.evaluate(patient3, node7),
        [false.toFhirBoolean],
      );

      final node8 = testEngine.parse("4 'm' < 4 'cm'");
      expect(
        await testEngine.evaluate(patient3, node8),
        [false.toFhirBoolean],
      );

      final node9 = testEngine.parse('@2018-03-01 < @2018-01-01');
      expect(
        await testEngine.evaluate(patient3, node9),
        [false.toFhirBoolean],
      );

      final node10 = testEngine.parse('@2018-03 < @2018-03-01');
      expect(
        await testEngine.evaluate(patient3, node10),
        <FhirBase>[],
      );

      final node11 =
          testEngine.parse('@2018-03-01T10:30:00 < @2018-03-01T10:00:00');
      expect(
        await testEngine.evaluate(patient3, node11),
        [false.toFhirBoolean],
      );

      final node12 = testEngine.parse('@2018-03-01T10 < @2018-03-01T10:30');
      expect(
        await testEngine.evaluate(patient3, node12),
        <FhirBase>[],
      );

      final node13 =
          testEngine.parse('@2018-03-01T10:30:00 < @2018-03-01T10:30:00.0');
      expect(
        await testEngine.evaluate(patient3, node13),
        [false.toFhirBoolean],
      );

      final node14 = testEngine.parse('@T10:30:00 < @T10:00:00');
      expect(
        await testEngine.evaluate(patient3, node14),
        [false.toFhirBoolean],
      );

      final node15 = testEngine.parse('@T10 < @T10:30');
      expect(
        await testEngine.evaluate(patient3, node15),
        <FhirBase>[],
      );

      final node16 = testEngine.parse('@T10:30:00 < @T10:30:00.0');
      expect(
        await testEngine.evaluate(patient3, node16),
        [false.toFhirBoolean],
      );
    });

    test('<= : ', () async {
      final node = testEngine.parse('@T12:25 <= @T12:25');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );

      final node1 = testEngine.parse('@T12:27 <= @T12:25');
      expect(
        await testEngine.evaluate(patient3, node1),
        [false.toFhirBoolean],
      );

      final node2 = testEngine.parse("'String' <= 'String'");
      expect(
        await testEngine.evaluate(patient3, node2),
        [true.toFhirBoolean],
      );

      final node3 = testEngine.parse("'string' <= 'String'");
      expect(
        await testEngine.evaluate(patient3, node3),
        [false.toFhirBoolean],
      );

      final node4 = testEngine.parse('10 <= 5');
      expect(
        await testEngine.evaluate(patient3, node4),
        [false.toFhirBoolean],
      );

      final node5 = testEngine.parse('10 <= 5.0');
      expect(
        await testEngine.evaluate(patient3, node5),
        [false.toFhirBoolean],
      );

      final node6 = testEngine.parse("'abc' <= 'ABC'");
      expect(
        await testEngine.evaluate(patient3, node6),
        [false.toFhirBoolean],
      );

      final node7 = testEngine.parse("4 'm' <= 4 'cm'");
      expect(
        await testEngine.evaluate(patient3, node7),
        [false.toFhirBoolean],
      );

      final node8 = testEngine.parse('@2018-03-01 <= @2018-01-01');
      expect(
        await testEngine.evaluate(patient3, node8),
        [false.toFhirBoolean],
      );

      final node9 = testEngine.parse('@2018-03 <= @2018-03-01');
      expect(
        await testEngine.evaluate(patient3, node9),
        <FhirBase>[],
      );

      final node10 =
          testEngine.parse('@2018-03-01T10:30:00 <= @2018-03-01T10:00:00');
      expect(
        await testEngine.evaluate(patient3, node10),
        [false.toFhirBoolean],
      );

      final node11 = testEngine.parse('@2018-03-01T10 <= @2018-03-01T10:30');
      expect(
        await testEngine.evaluate(patient3, node11),
        <FhirBase>[],
      );

      final node12 =
          testEngine.parse('@2018-03-01T10:30:00 <= @2018-03-01T10:30:00.0');
      expect(
        await testEngine.evaluate(patient3, node12),
        [true.toFhirBoolean],
      );

      final node13 = testEngine.parse('@T10:30:00 <= @T10:00:00');
      expect(
        await testEngine.evaluate(patient3, node13),
        [false.toFhirBoolean],
      );

      final node14 = testEngine.parse('@T10 <= @T10:30');
      expect(
        await testEngine.evaluate(patient3, node14),
        <FhirBase>[],
      );

      final node15 = testEngine.parse('@T10:30:00 <= @T10:30:00.0');
      expect(
        await testEngine.evaluate(patient3, node15),
        [true.toFhirBoolean],
      );
    });

    test('>= : ', () async {
      final node = testEngine.parse('@T12:25 >= @T12:25');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );

      final node1 = testEngine.parse('@T12:27 >= @T12:25');
      expect(
        await testEngine.evaluate(patient3, node1),
        [true.toFhirBoolean],
      );

      final node2 = testEngine.parse("'String' >= 'String'");
      expect(
        await testEngine.evaluate(patient3, node2),
        [true.toFhirBoolean],
      );

      final node3 = testEngine.parse("'string' >= 'String'");
      expect(
        await testEngine.evaluate(patient3, node3),
        [true.toFhirBoolean],
      );

      final node4 = testEngine.parse('10 >= 5');
      expect(
        await testEngine.evaluate(patient3, node4),
        [true.toFhirBoolean],
      );

      final node5 = testEngine.parse('10 >= 5.0');
      expect(
        await testEngine.evaluate(patient3, node5),
        [true.toFhirBoolean],
      );

      final node6 = testEngine.parse("'abc' >= 'ABC'");
      expect(
        await testEngine.evaluate(patient3, node6),
        [true.toFhirBoolean],
      );

      final node7 = testEngine.parse("4 'm' >= 4 'cm'");
      expect(
        await testEngine.evaluate(patient3, node7),
        [true.toFhirBoolean],
      );

      final node8 = testEngine.parse('@2018-03-01 >= @2018-01-01');
      expect(
        await testEngine.evaluate(patient3, node8),
        [true.toFhirBoolean],
      );

      final node9 = testEngine.parse('@2018-03 >= @2018-03-01');
      expect(
        await testEngine.evaluate(patient3, node9),
        <FhirBase>[],
      );

      final node10 =
          testEngine.parse('@2018-03-01T10:30:00 >= @2018-03-01T10:00:00');
      expect(
        await testEngine.evaluate(patient3, node10),
        [true.toFhirBoolean],
      );

      final node11 = testEngine.parse('@2018-03-01T10 >= @2018-03-01T10:30');
      expect(
        await testEngine.evaluate(patient3, node11),
        <FhirBase>[],
      );

      final node12 =
          testEngine.parse('@2018-03-01T10:30:00 >= @2018-03-01T10:30:00.0');
      expect(
        await testEngine.evaluate(patient3, node12),
        [true.toFhirBoolean],
      );

      final node13 = testEngine.parse('@T10:30:00 >= @T10:00:00');
      expect(
        await testEngine.evaluate(patient3, node13),
        [true.toFhirBoolean],
      );

      final node14 = testEngine.parse('@T10 >= @T10:30');
      expect(
        await testEngine.evaluate(patient3, node14),
        <FhirBase>[],
      );

      final node15 = testEngine.parse('@T10:30:00 >= @T10:30:00.0');
      expect(
        await testEngine.evaluate(patient3, node15),
        [true.toFhirBoolean],
      );
    });

    test('is : ', () async {
      final node = testEngine.parse('12 is Integer');
      expect(
        await testEngine.evaluate(patient3, node),
        [true.toFhirBoolean],
      );

      final node1 = testEngine.parse('12 is Decimal');
      expect(
        await testEngine.evaluate(patient3, node1),
        [false.toFhirBoolean],
      );

      final node2 = testEngine.parse('12.5 is Integer');
      expect(
        await testEngine.evaluate(patient3, node2),
        [false.toFhirBoolean],
      );

      final node3 = testEngine.parse('12.5 is Decimal');
      expect(
        await testEngine.evaluate(patient3, node3),
        [true.toFhirBoolean],
      );
    });
  });
  group(
    'Math Operators: ',
    () {
      test('Math Operators: / :', () async {
        final node1 = testEngine.parse('(1.2 / 1.8).round(8) = 0.66666667');
        expect(
          await testEngine.evaluate(patient3, node1),
          [true.toFhirBoolean],
        );

        final node2 = testEngine.parse('1/0');
        expect(
          await testEngine.evaluate(patient3, node2),
          <FhirBase>[],
        );
      });

      test('Math Operators: - :', () async {
        final node1 = testEngine.parse('75-70');

        expect(
          await testEngine.evaluate(patient3, node1),
          [5.toFhirInteger],
        );

        final node2 = testEngine.parse('75-70-75');

        expect(
          await testEngine.evaluate(patient3, node2),
          [-70.toFhirInteger],
        );
      });

      test('Math Operators: Precedence', () async {
        final node1 = testEngine.parse('75+70-75');

        expect(
          await testEngine.evaluate(patient3, node1),
          [70.toFhirInteger],
        );

        final node2 = testEngine.parse('1+2*3+4 = 11');

        expect(
          await testEngine.evaluate(patient3, node2),
          [true.toFhirBoolean],
        );

        final nodeTest = testEngine.parse('2*-3');

        expect(
          await testEngine.evaluate(patient3, nodeTest),
          [-6.toFhirInteger],
        );

        /// (1 + (2 * Unary(null: null)) - 3 + 4) = (Unary(-: null) - 1)
        /// (1 + (2 * Unary(null: null)) - 3 + 4) = (Unary(-: null) - 1)
        final node3 = testEngine.parse('1+2*-3+4 = -1');

        expect(
          await testEngine.evaluate(patient3, node3),
          [true.toFhirBoolean],
        );

        // TODO(Dokotela): Test with Unary First
        // final node4 = testEngine.parse('-1-2*3 = -7');
        // print('************************************');
        // node4.printExpressionTree();
        // print('************************************');
        // expect(
        //    await testEngine.evaluate(patient3, node4),
        //   [true.toFhirBoolean],
        // );

        final node5 = testEngine.parse('1-2*3-4*5 = -25');

        expect(
          await testEngine.evaluate(patient3, node5),
          [true.toFhirBoolean],
        );

        final node6 = testEngine.parse('1-2.ceiling()*3-4*5.ceiling() = -25');

        expect(
          await testEngine.evaluate(patient3, node6),
          [true.toFhirBoolean],
        );
      });
    },
  );
}

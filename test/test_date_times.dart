import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_r4_path/fhir_r4_path.dart';
import 'package:test/test.dart';

import 'test_data.dart';

Future<void> testDateTimes() async {
  final testEngine = await FHIRPathEngine.create(WorkerContext());
  group('DateTime Arithmetic', () {
    final response = questionnaireResponse3;
    test('Basic Date Addition/Subtraction', () async {
      final node1 = testEngine.parse('authored');
      expect(
        await testEngine.evaluate(response, node1),
        ['2014-12-11T04:44:16Z'.toFhirDateTime],
      );

      final node2 = testEngine.parse('authored + 6 months');
      expect(
        await testEngine.evaluate(response, node2),
        ['2015-06-11T04:44:16Z'.toFhirDateTime],
      );

      final node3 = testEngine.parse('authored - 6 months');
      expect(
        await testEngine.evaluate(response, node3),
        ['2014-06-11T04:44:16Z'.toFhirDateTime],
      );

      final node4 =
          testEngine.parse('(today() - 6 months) > (today() - 7 months)');
      expect(
        await testEngine.evaluate(response, node4),
        [true.toFhirBoolean],
      );

      final node5 =
          testEngine.parse('(today() - 6 months) < (today() - 7 months)');
      expect(
        await testEngine.evaluate(response, node5),
        [false.toFhirBoolean],
      );

      final node6 = testEngine.parse('@2014 + 24 months');
      expect(
        await testEngine.evaluate(response, node6),
        ['2016'.toFhirDate],
      );

      final node7 = testEngine.parse('@2019-03-01 + 24 months // @2021-03-01');
      expect(
        await testEngine.evaluate(response, node7),
        ['2021-03-01'.toFhirDate],
      );

      final node8 = testEngine.parse('@2014 + 23 months');
      expect(
        await testEngine.evaluate(response, node8),
        ['2015'.toFhirDate],
      );

      // 2016 is a leap year: 2016-01-01 + 365 days = 2016-12-31, which at
      // year precision is still 2016 (Java reference adds days via
      // Calendar.add). An earlier expectation of 2017 encoded a duration-
      // normalisation bug that folded 365 days into "1 year 1 month 1 day".
      final node9 = testEngine.parse('@2016 + 365 days');
      expect(
        await testEngine.evaluate(response, node9),
        ['2016'.toFhirDate],
      );

      final node10 = testEngine.parse('@2014 - 24 months');
      expect(
        await testEngine.evaluate(response, node10),
        ['2012'.toFhirDate],
      );

      final node11 = testEngine.parse('@2019-03-01 - 24 months // @2021-03-01');
      expect(
        await testEngine.evaluate(response, node11),
        ['2017-03-01'.toFhirDate],
      );
    });
  });
}

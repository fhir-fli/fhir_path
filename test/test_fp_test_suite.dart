// ignore_for_file: lines_longer_than_80_chars

import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_r4_path/fhir_r4_path.dart';
import 'package:test/test.dart';

import 'support/walk.dart';

import 'test_data.dart';

/// FHIRPath Test Suite - reference="http://hl7.org/fhirpath|2.0.0"
Future<void> testFpTestSuite() async {
  group('testMiscellaneousAccessorTests - Miscellaneous accessor tests', () {
    // <test name="testExtractBirthDate" description="Extract birthDate"
    // inputfile="patient-example.xml" predicate="false">
    // <expression>birthDate</expression>
    // <output type="date">1974-12-25</output>
    // });

    test('testExtractBirthDate', () async {
      expect(
        await walkPath(context: patient1, pathExpression: 'birthDate'),
        ['1974-12-25'.toFhirDate],
      );
    });

    // <test name="testPatientHasBirthDate"
    // description="patient has a birthDate"
    // inputfile="patient-example.xml" predicate="true">
    // <expression>birthDate</expression>
    // <output type="boolean">true</output>
    // });

    test('testPatientHasBirthDate', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'birthDate.exists()',
        ),
        [true.toFhirBoolean],
      );
    });

    // <test name="testPatientTelecomTypes" description="patient telecom types"
    // inputfile="patient-example.xml">
    // <expression>telecom.use</expression>
    // <output type="code">home</output>
    // <output type="code">work</output>
    // <output type="code">mobile</output>
    // <output type="code">old</output>
    // });

    test('testPatientTelecomTypes', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'telecom.use',
        ),
        [
          ContactPointUse.home,
          ContactPointUse.work,
          ContactPointUse.mobile,
          ContactPointUse.old,
        ],
      );
    });
  });

  // Tests ported from the Java Unit Tests
  group('testBasics - Tests ported from the Java Unit Tests', () {
    // test(patient(), "name.given", 3, "string");
    // <output type="string">Peter</output>
    // <output type="string">James</output>
    // <output type="string">Jim</output>
    // <output type="string">Peter</output>
    // <output type="string">James</output>
    // });

    test('testSimple', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'name.given',
        ),
        [
          'Peter'.toFhirString,
          'James'.toFhirString,
          'Jim'.toFhirString,
          'Peter'.toFhirString,
          'James'.toFhirString,
        ],
      );
    });

    // test(patient(), "name.period", 0);
    // <test name="testSimpleNone" inputfile="patient-example.xml">
    // <expression>name.suffix</expression>
    // });

    test('testSimpleNone', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'name.suffix',
        ),
        <FhirBase>[],
      );
    });

    // Not in the official suite — keeps coverage of extracting a complex
    // (non-primitive) child through the engine.
    test('testSimplePeriod', () async {
      expect(
          (await walkPath(
            context: patient1,
            pathExpression: 'name.period',
          ))
              .map((e) => e.toJson())
              .toList(),
          [
            {'end': '2002'},
          ]);
    });

    // test(patient(), "name.\"given\"", 3, "string");
    // <output type="string">Peter</output>
    // <output type="string">James</output>
    // <output type="string">Jim</output>
    // <output type="string">Peter</output>
    // <output type="string">James</output>
    // });

    test('testEscapedIdentifier', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'name.`given`',
        ),
        [
          'Peter'.toFhirString,
          'James'.toFhirString,
          'Jim'.toFhirString,
          'Peter'.toFhirString,
          'James'.toFhirString,
        ],
      );
    });

    // <output type="string">Peter</output>
    // <output type="string">James</output>
    // <output type="string">Jim</output>
    // <output type="string">Peter</output>
    // <output type="string">James</output>
    // });

    test('testSimpleBackTick1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '`Patient`.name.`given`',
        ),
        [
          'Peter'.toFhirString,
          'James'.toFhirString,
          'Jim'.toFhirString,
          'Peter'.toFhirString,
          'James'.toFhirString,
        ],
      );
    });

    // testWrong(patient(), "name.given1");
    // <test name="testSimpleFail" inputfile="patient-example.xml" mode="strict">
    // <expression invalid="semantic">name.given1</expression>
    // });

    // Official testSimpleFail runs in strict mode and expects a semantic
    // error for the unknown path; our engine evaluates leniently, where an
    // unknown name resolves to empty.
    test('testSimpleFail-lenient', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'name.given1',
        ),
        <FhirBase>[],
      );
    });

    // test(patient(), "Patient.name.given", 3, "string");
    // <output type="string">Peter</output>
    // <output type="string">James</output>
    // <output type="string">Jim</output>
    // <output type="string">Peter</output>
    // <output type="string">James</output>
    // });

    test('testSimpleWithContext', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.given',
        ),
        [
          'Peter'.toFhirString,
          'James'.toFhirString,
          'Jim'.toFhirString,
          'Peter'.toFhirString,
          'James'.toFhirString,
        ],
      );
    });

    // testWrong(patient(), "Encounter.name.given");
    // <test name="testSimpleWithWrongContext" inputfile="patient-example.xml"
    //  mode="strict">
    // <expression invalid="semantic">Encounter.name.given</expression>
    // Official testSimpleWithWrongContext runs in strict mode and expects a
    // semantic error (the context type does not match the resource); our
    // engine evaluates leniently, where the wrong context resolves to empty.
    test('testSimpleWithWrongContext-lenient', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Encounter.name.given',
        ),
        <FhirBase>[],
      );
    });
  });

  group('testObservations', () {
    // test(observation(), "Observation.value.unit", 1, "string");
    test('testPolymorphismA', () async {
      expect(
        await walkPath(
          context: observation1,
          pathExpression: 'Observation.value.unit',
        ),
        ['lbs'.toFhirString],
      );
    });

    // testWrong(observation(), "Observation.valueQuantity.unit");
    // <test name="testPolymorphismB" inputfile="observation-example.xml"
    //  mode="strict">
    // <expression invalid="semantic">Observation.valueQuantity.unit</expression>
    // });

    test('testPolymorphismIsA', () async {
      expect(
        await walkPath(
          context: observation1,
          pathExpression: 'Observation.value is Quantity',
        ),
        [true.toFhirBoolean],
      );
    });

    // FIXED: Test makes wrong assumption about precedence
    // test("testPolymorphismIsB", () async {
    //   expect(
    //       await walkPath(
    //           context: observation1,
    //           pathExpression: r"Observation.value is Period.not()"),
    //       [true]);
    // });

    test('testPolymorphismIsB-fixed', () async {
      expect(
        await walkPath(
          context: observation1,
          pathExpression: '(Observation.value is Period).not()',
        ),
        [true.toFhirBoolean],
      );
    });

    // Official testPolymorphismAsA: the as() function form is retained by
    // the spec for backwards compatibility (the Java reference implements
    // it); an earlier revision asserted a project-invented deprecation throw.
    test('testPolymorphismAsA', () async {
      expect(
        await walkPath(
          context: observation1,
          pathExpression: 'Observation.value.as(Quantity).unit',
        ),
        ['lbs'.toFhirString],
      );
    });
  });

  // testBoolean(observation(), "(Observation.value as Quantity).unit", true);
  test('testPolymorphismAsAFunction', () async {
    expect(
      await walkPath(
        context: observation1,
        pathExpression: '(Observation.value as Quantity).unit',
      ),
      ['lbs'.toFhirString],
    );
  });

  // testWrong(observation(), "(Observation.value as Period).unit");
  // <test name="testPolymorphismAsB" inputfile="observation-example.xml"
  //  mode="strict">
  // <expression invalid="semantic">(Observation.value as Period).unit</expression>
  // });
  test('testPolymorphismAsB', () async {
    expect(
      await walkPath(
        context: observation1,
        pathExpression: '(Observation.value as Period).unit',
      ),
      <FhirBase>[],
    );
  });

  // Official testPolymorphismAsBFunction: the value is a Quantity, so
  // as(Period) filters it out and the result is empty. (An earlier revision
  // asserted a project-invented deprecation throw.)
  test('testPolymorphismAsBFunction', () async {
    expect(
      await walkPath(
        context: observation1,
        pathExpression: 'Observation.value.as(Period).start',
      ),
      <FhirBase>[],
    );
  });

  group('testDollar', () {
    // test(patient(), "Patient.name.given.where(substring($this.length()-3) = 'out')", 0);
    test('testDollarThis1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression:
              r"Patient.name.given.where(substring($this.length()-3) = 'out')",
        ),
        <FhirBase>[],
      );
    });

    // test(patient(), "Patient.name.given.where(substring($this.length()-3) = 'ter')", 1, "string");
    test('testDollarThis2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression:
              r"Patient.name.given.where(substring($this.length()-3) = 'ter')",
        ),
        ['Peter'.toFhirString, 'Peter'.toFhirString],
      );
    });

    // Official testDollarOrderAllowed: skip(1) leaves the usual + maiden
    // names, whose givens are Jim, Peter, James.
    test('testDollarOrderAllowed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.skip(1).given',
        ),
        [
          'Jim'.toFhirString,
          'Peter'.toFhirString,
          'James'.toFhirString,
        ],
      );
    });

    // <test name="testDollarOrderAllowedA" inputfile="patient-example.xml">
    // <expression>Patient.name.skip(3).given</expression>
    // });

    test('testDollarOrderAllowedA', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.skip(3).given',
        ),
        <FhirBase>[],
      );
    });

    // Official testDollarOrderNotAllowed runs in strict mode with
    // checkOrderedFunctions and expects a semantic error (skip() over the
    // unordered children() collection); our engine evaluates leniently, so
    // this asserts the lenient evaluation instead.
    test('testDollarOrderNotAllowed-lenient', () async {
      expect(
          (await walkPath(
            context: patient1,
            pathExpression: 'Patient.name.children().skip(1)',
          ))
              .map((e) => e is PrimitiveType ? e.primitiveValue : e.toJson()),
          [
            'Chalmers',
            'Peter',
            'James',
            'usual',
            'Jim',
            'maiden',
            'Windsor',
            'Peter',
            'James',
            {'end': '2002'},
          ]);
    });
  });

  group('testLiterals', () {
    // testBoolean(patient(), "Patient.name.exists() = true", true);
    test('testLiteralTrue', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.exists() = true',
        ),
        [true.toFhirBoolean],
      );
    });

    // testBoolean(patient(), "Patient.name.empty() = false", true);
    test('testLiteralFalse', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.empty() = false',
        ),
        [true.toFhirBoolean],
      );
    });

    // testBoolean(patient(), "Patient.name.given.first() = 'Peter'", true);
    test('testLiteralString', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "Patient.name.given.first() = 'Peter'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralInteger1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.convertsToInteger()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralInteger0', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '0.convertsToInteger()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralIntegerNegative1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(-1).convertsToInteger()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralIntegerNegative1Invalid', () async {
      expect(
        () => walkPath(
          context: patient1,
          pathExpression: '-1.convertsToInteger()',
        ),
        throwsA(const TypeMatcher<PathEngineException>()),
      );
    });

    test('testLiteralIntegerMax', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '2147483647.convertsToInteger()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralString', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'test'.convertsToString()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralStringEscapes', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: r"""'\\\/\f\r\n\t\"\`\'\u002a'.convertsToString()""",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralBooleanTrue', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'true.convertsToBoolean()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralBooleanFalse', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'false.convertsToBoolean()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralDecimal10', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.0.convertsToDecimal()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralDecimal01', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '0.1.convertsToDecimal()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralDecimal00', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '0.0.convertsToDecimal()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralDecimalNegative01', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(-0.1).convertsToDecimal()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralDecimalNegative01Invalid', () async {
      expect(
        () => walkPath(
          context: patient1,
          pathExpression: '-0.1.convertsToDecimal()',
        ),
        throwsA(const TypeMatcher<PathEngineException>()),
      );
    });

    test('testLiteralDecimalMax', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1234567890987654321.0.convertsToDecimal()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralDecimalStep', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '0.00000001.convertsToDecimal()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralDateYear', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2015 is Date',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralDateMonth', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2015-02 is Date',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralDateDay', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2015-02-04 is Date',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralDateTimeYear', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2015T is DateTime',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralDateTimeMonth', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2015-02T is DateTime',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralDateTimeDay', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2015-02-04T is DateTime',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralDateTimeHour', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2015-02-04T14 is DateTime',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralDateTimeMinute', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2015-02-04T14:34 is DateTime',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralDateTimeSecond', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2015-02-04T14:34:28 is DateTime',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralDateTimeMillisecond', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2015-02-04T14:34:28.123 is DateTime',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralDateTimeUTC', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2015-02-04T14:34:28Z is DateTime',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralDateTimeTimezoneOffset', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2015-02-04T14:34:28+10:00 is DateTime',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralTimeHour', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@T14 is Time',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralTimeMinute', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@T14:34 is Time',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralTimeSecond', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@T14:34:28 is Time',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralTimeMillisecond', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@T14:34:28.123 is Time',
        ),
        [true.toFhirBoolean],
      );
    });

    //   Current: "@T14:34:28Z" => TimeParser (@T14:34:28) + IdentifierParser (Z)
    //<test name="testLiteralTimeUTC" inputfile="patient-example.xml"
    // invalid="true"><expression>@T14:34:28Z is Time</expression>});
    test('testLiteralTimeUtc', () async {
      expect(
        () => walkPath(
          context: patient1,
          pathExpression: '@T14:34:28Z is Time',
        ),
        throwsA(const TypeMatcher<PathEngineException>()),
      );
    });

    // <test name="testLiteralTimeTimezoneOffset" inputfile="patient-example.xml"
    // invalid="true"><expression>@T14:34:28+10:00 is Time</expression>});
    test('testLiteralTimeTimezoneOffset', () async {
      expect(
        () => walkPath(
          context: patient1,
          pathExpression: '@T14:34:28+10:00 is Time',
        ),
        throwsA(const TypeMatcher<PathEngineException>()),
      );
    });

    test('testLiteralQuantityDecimal', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "10.1 'mg'.convertsToQuantity()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralQuantityInteger', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "10 'mg'.convertsToQuantity()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralQuantityDay', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '4 days.convertsToQuantity()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralIntegerNotEqual', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '-3 != 3'),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralIntegerEqual', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.given.count() = 5',
        ),
        [true.toFhirBoolean],
      );
    });

    // TODO(Dokotela): fix polarity precedence
    // test('testPolarityPrecedence', () async {
    //   expect(
    //     await walkPath(
    //       context: patient1,
    //       pathExpression: '-Patient.name.given.count() = -5',
    //     ),
    //     [true.toFhirBoolean],
    //   );
    // });

    test('testLiteralIntegerGreaterThan', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.given.count() > -3',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralIntegerCountNotEqual', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.given.count() != 0',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralIntegerLessThanTrue', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 < 2'),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralIntegerLessThanFalse', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 < -2'),
        [false.toFhirBoolean],
      );
    });

    test('testLiteralIntegerLessThanPolarityTrue', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '+1 < +2'),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralIntegerLessThanPolarityFalse', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '-1 < 2'),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralDecimalGreaterThanNonZeroTrue', () async {
      expect(
        await walkPath(
          context: observation1,
          pathExpression: 'Observation.value.value > 180.0',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralDecimalGreaterThanZeroTrue', () async {
      expect(
        await walkPath(
          context: observation1,
          pathExpression: 'Observation.value.value > 0.0',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralDecimalGreaterThanIntegerTrue', () async {
      expect(
        await walkPath(
          context: observation1,
          pathExpression: 'Observation.value.value > 0',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralDecimalLessThanInteger', () async {
      expect(
        await walkPath(
          context: observation1,
          pathExpression: 'Observation.value.value < 190',
        ),
        [true.toFhirBoolean],
      );
    });

    // http://hl7.org/fhirpath/N1/#comparison
    // Both arguments must be of the same type (or implicitly convertible to
    // the same type), and the evaluator will throw an error if the types differ.
    // /*<test name="testLiteralDecimalLessThanInvalid"
    // inputfile="observation-example.xml">
    // <expression invalid="semantic">Observation.value.value
    // < 'test'</expression>// no output - empty set});*/
    // Not in the official suite — comparing a decimal to a string must throw.
    test('testLiteralDecimalLessThanStringThrows', () async {
      expect(
        () => walkPath(
          context: observation1,
          pathExpression: "Observation.value.value < 'test'",
        ),
        throwsA(isA<PathEngineException>()),
      );
    });
  });

  group('testDates', () {
    test('testDateEqual', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.birthDate = @1974-12-25',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testDateNotEqual', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.birthDate != @1974-12-25T12:34:00',
        ),
        <FhirBase>[],
      );
    });

    test('testDateNotEqualTimezoneOffsetBefore', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.birthDate != @1974-12-25T12:34:00-10:00',
        ),
        <FhirBase>[],
      );
    });

    test('testDateNotEqualTimezoneOffsetAfter', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.birthDate != @1974-12-25T12:34:00+10:00',
        ),
        <FhirBase>[],
      );
    });

    test('testDateNotEqualUTC', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.birthDate != @1974-12-25T12:34:00Z',
        ),
        <FhirBase>[],
      );
    });

    test('testDateNotEqualTimeSecond', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.birthDate != @T12:14:15',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testDateNotEqualTimeMinute', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.birthDate != @T12:14',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testDateNotEqualToday', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.birthDate < today()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testDateTimeGreaterThanDate', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'now() > Patient.birthDate',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralDateTimeTZGreater', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression:
              '@2017-11-05T01:30:00.0-04:00 > @2017-11-05T01:15:00.0-05:00',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testLiteralDateTimeTZLess', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression:
              '@2017-11-05T01:30:00.0-04:00 < @2017-11-05T01:15:00.0-05:00',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralDateTimeTZEqualFalse', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression:
              '@2017-11-05T01:30:00.0-04:00 = @2017-11-05T01:15:00.0-05:00',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testLiteralDateTimeTZEqualTrue', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression:
              '@2017-11-05T01:30:00.0-04:00 = @2017-11-05T00:30:00.0-05:00',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('Random Tests', () {
    test('testLiteralUnicode', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: r"Patient.name.given.first() = 'P\u0065ter'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testCollectionNotEmpty', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.given.empty().not()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testCollectionNotEqualEmpty', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.given != {}',
        ),
        <FhirBase>[],
      );
    });

    test('testExpressions', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.select(given | family).distinct()',
        ),
        unorderedEquals([
          'Peter'.toFhirString,
          'James'.toFhirString,
          'Chalmers'.toFhirString,
          'Jim'.toFhirString,
          'Windsor'.toFhirString,
        ]),
      );
    });

    test('testExpressionsEqual', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.given.count() = 1 + 4',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testNotEmpty', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.empty().not()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testEmpty', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.link.empty()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralNotTrue', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'true.not() = false',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLiteralNotFalse', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'false.not() = true',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testIntegerBooleanNotTrue', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(0).not() = true',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testIntegerBooleanNotFalse', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(1).not() = false',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testNotInvalid', () async {
      expect(
        () => walkPath(
          context: patient1,
          pathExpression: '(1|2).not() = false',
        ),
        throwsA(const TypeMatcher<PathEngineException>()),
      );
    });
  });

  group('testTypes', () {
    test('testStringYearConvertsToDate', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'2015'.convertsToDate()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringMonthConvertsToDate', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'2015-02'.convertsToDate()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringDayConvertsToDate', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'2015-02-04'.convertsToDate()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringYearConvertsToDateTime', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'2015'.convertsToDateTime()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringMonthConvertsToDateTime', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'2015-02'.convertsToDateTime()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringDayConvertsToDateTime', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'2015-02-04'.convertsToDateTime()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringHourConvertsToDateTime', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'2015-02-04T14'.convertsToDateTime()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringMinuteConvertsToDateTime', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'2015-02-04T14:34'.convertsToDateTime()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringSecondConvertsToDateTime', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'2015-02-04T14:34:28'.convertsToDateTime()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringMillisecondConvertsToDateTime', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'2015-02-04T14:34:28.123'.convertsToDateTime()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringUTCConvertsToDateTime', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'2015-02-04T14:34:28Z'.convertsToDateTime()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringTZConvertsToDateTime', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'2015-02-04T14:34:28+10:00'.convertsToDateTime()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringHourConvertsToTime', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'14'.convertsToTime()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringMinuteConvertsToTime', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'14:34'.convertsToTime()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringSecondConvertsToTime', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'14:34:28'.convertsToTime()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringMillisecondConvertsToTime', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'14:34:28.123'.convertsToTime()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testIntegerLiteralConvertsToInteger', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.convertsToInteger()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testIntegerLiteralIsInteger', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1 is Integer',
        ),
        [true.toFhirBoolean],
      );
    });

    // TODO(Dokotela): integrate: models https://hl7.org/fhirpath/#models
    // test("testIntegerLiteralIsSystemInteger", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1,
    //           pathExpression: r"1 is System.Integer"),
    //       [true]);
    // });

    test('testStringLiteralConvertsToInteger', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'1'.convertsToInteger()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringLiteralConvertsToIntegerFalse', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'a'.convertsToInteger().not()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringDecimalConvertsToIntegerFalse', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'1.0'.convertsToInteger().not()",
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('Literals & Conversions', () {
    // FIXED: Incorrect test case. Wrong assumptions around precedence
    // test("testStringLiteralIsNotInteger", () async {
    //   expect(await walkPath(context: patient1,
    //  pathExpression: r"'1' is Integer.not()"), [true]);
    // });
    test('testStringLiteralIsNotInteger-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "('1' is Integer).not()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLiteralConvertsToInteger', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'true.convertsToInteger()',
        ),
        [true.toFhirBoolean],
      );
    });

    // FIXED: Incorrect test case. Wrong assumptions around precedence
    // test("testBooleanLiteralIsNotInteger", () async {
    //   expect(await walkPath(context: patient1,
    //  pathExpression: r"true is Integer.not()"), [true]);
    // });
    test('testBooleanLiteralIsNotInteger-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(true is Integer).not()',
        ),
        [true.toFhirBoolean],
      );
    });

    // FIXED: Incorrect test case. Wrong assumptions around precedence
    // test("testDateIsNotInteger", () async {
    //   expect(await walkPath(context: patient1,
    //  pathExpression: r"@2013-04-05 is Integer.not()"),
    //       [true]);
    // });
    test('testDateIsNotInteger-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(@2013-04-05 is Integer).not()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testIntegerLiteralToInteger', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.toInteger() = 1',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringIntegerLiteralToInteger', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'1'.toInteger() = 1",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testDecimalLiteralToInteger', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'1.1'.toInteger() = {}",
        ),
        <FhirBase>[],
      );
    });

    test('testDecimalLiteralToIntegerIsEmpty', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'1.1'.toInteger().empty()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLiteralToInteger', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'true.toInteger() = 1',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testIntegerLiteralConvertsToDecimal', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.convertsToDecimal()',
        ),
        [true.toFhirBoolean],
      );
    });

    // FIXED: wrong grouping again
    // test("testIntegerLiteralIsNotDecimal", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1, pathExpression: r"1 is Decimal.not()"),
    //       [true]);
    // });
    test('testIntegerLiteralIsNotDecimal-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(1 is Decimal).not()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testDecimalLiteralConvertsToDecimal', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.0.convertsToDecimal()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testDecimalLiteralIsDecimal', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.0 is Decimal',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringIntegerLiteralConvertsToDecimal', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'1'.convertsToDecimal()",
        ),
        [true.toFhirBoolean],
      );
    });

    // FIXED: Incorrect precedence
    // test("testStringIntegerLiteralIsNotDecimal", () async {
    //   expect(await walkPath(context: patient1,
    //  pathExpression: r"'1' is Decimal.not()"), [true]);
    // });
    test('testStringIntegerLiteralIsNotDecimal-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "('1' is Decimal).not()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringLiteralConvertsToDecimalFalse', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'1.a'.convertsToDecimal().not()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringDecimalLiteralConvertsToDecimal', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'1.0'.convertsToDecimal()",
        ),
        [true.toFhirBoolean],
      );
    });

    // FIXED: Incorrect precedence
    // test("testStringDecimalLiteralIsNotDecimal", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1,
    //           pathExpression: r"'1.0' is Decimal.not()"),
    //       [true]);
    // });
    test('testStringDecimalLiteralIsNotDecimal-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "('1.0' is Decimal).not()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLiteralConvertsToDecimal', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'true.convertsToDecimal()',
        ),
        [true.toFhirBoolean],
      );
    });

    // FIXED: again, incorrect grouping in example
    // test("testBooleanLiteralIsNotDecimal", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1,
    //           pathExpression: r"true is Decimal.not()"),
    //       [true]);
    // });
    test('testBooleanLiteralIsNotDecimal-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(true is Decimal).not()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testIntegerLiteralToDecimal', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.toDecimal() = 1.0',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testIntegerLiteralToDecimalEquivalent', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.toDecimal() ~ 1.0',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testDecimalLiteralToDecimal', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.0.toDecimal() = 1.0',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testDecimalLiteralToDecimalEqual', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'1.1'.toDecimal() = 1.1",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLiteralToDecimal', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'true.toDecimal() = 1',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testIntegerLiteralConvertsToQuantity', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.convertsToQuantity()',
        ),
        [true.toFhirBoolean],
      );
    });

    // FIXED: Wrong assumption about precedence
    // test("testIntegerLiteralIsNotQuantity", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1,
    //           pathExpression: r"1 is Quantity.not()"),
    //       [true]);
    // });
    test('testDecimalLiteralConvertsToQuantity', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.0.convertsToQuantity()',
        ),
        [true.toFhirBoolean],
      );
    });

    // TODO(Dokotela): testDecimalLiteralIsNotQuantity
    // test('testDecimalLiteralIsNotQuantity', () async {
    //   expect(
    //     await walkPath(
    //       context: patient1,
    //       pathExpression: '1.0 is System.Quantity.not()',
    //     ),
    //     [true.toFhirBoolean],
    //   );
    // });

    test('testStringIntegerLiteralConvertsToQuantity', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'1'.convertsToQuantity()",
        ),
        [true.toFhirBoolean],
      );
    });

    // TODO(Dokotela): testStringIntegerLiteralIsNotQuantity
    // test("testStringIntegerLiteralIsNotQuantity", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1,
    //           pathExpression: r"'1' is System.Quantity.not()"),
    //       [true]);
    // });

    test('testStringQuantityLiteralConvertsToQuantity', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'1 day'.convertsToQuantity()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringQuantityWeekConvertsToQuantity', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: r"'1 \'wk\''.convertsToQuantity()",
        ),
        [true.toFhirBoolean],
      );
    });

    // Official expectation is true: a bare UCUM code (`wk`) is not a valid
    // unquoted unit — only calendar keywords may appear unquoted, so
    // '1 wk' does NOT convert. (An earlier revision expected [false],
    // masking a parseQuantityString that accepted bare UCUM codes.)
    test('testStringQuantityWeekConvertsToQuantityFalse', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'1 wk'.convertsToQuantity().not()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringDecimalLiteralConvertsToQuantityFalse', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'1.a'.convertsToQuantity().not()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringDecimalLiteralConvertsToQuantity', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'1.0'.convertsToQuantity()",
        ),
        [true.toFhirBoolean],
      );
    });

    // TODO(Dokotela): testStringDecimalLiteralIsNotSystemQuantity
    // test("testStringDecimalLiteralIsNotSystemQuantity", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1,
    //           pathExpression: r"'1.0' is System.Quantity.not()"),
    //       [true]);
    // });

    test('testBooleanLiteralConvertsToQuantity', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'true.convertsToQuantity()',
        ),
        [true.toFhirBoolean],
      );
    });

    // TODO(Dokotela): testBooleanLiteralIsNotSystemQuantity
    // test("testBooleanLiteralIsNotSystemQuantity", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1,
    //           pathExpression: r"true is System.Quantity.not()"),
    //       [true]);
    // });

    test('testIntegerLiteralToQuantity', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "1.toQuantity() = 1 '1'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testDecimalLiteralToQuantity', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.0.toQuantity() = 1.0',
        ),
        [true.toFhirBoolean],
      );
    });

    //<test name="testStringIntegerLiteralToQuantity"
    // inputfile="patient-example.xml">
    // <expression>'1'.toQuantity()</expression>
    //  <output type="Quantity">1 '1'</output>});*/
    test('testStringQuantityLiteralToQuantity', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'1 day'.toQuantity() = 1 day",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringQuantityDayLiteralToQuantity', () async {
      expect(
        await walkPath(
          context: patient1,
          // Official expression (fhir-test-cases): 1 'd'. The prior local
          // variant «1 'day'» only passed via ucum's lenient name-fallback
          // bug — 'day' is not valid UCUM, so it canonicalizes to nothing.
          pathExpression: "'1 day'.toQuantity() = 1 'd'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringQuantityWeekLiteralToQuantity', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: r"'1 \'wk\''.toQuantity() = 1 'wk'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringDecimalLiteralToQuantity', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'1.0'.toQuantity() ~ 1",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testIntegerLiteralConvertsToBoolean', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.convertsToBoolean()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testIntegerLiteralConvertsToBooleanFalse', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '2.convertsToBoolean()',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testNegativeIntegerLiteralConvertsToBooleanFalse', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(-1).convertsToBoolean()',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testIntegerLiteralFalseConvertsToBoolean', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '0.convertsToBoolean()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testDecimalLiteralConvertsToBoolean', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.0.convertsToBoolean()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringTrueLiteralConvertsToBoolean', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'true'.convertsToBoolean()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringFalseLiteralConvertsToBoolean', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'false'.convertsToBoolean()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringFalseLiteralAlsoConvertsToBoolean', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'False'.convertsToBoolean()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testTrueLiteralConvertsToBoolean', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'true.convertsToBoolean()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testFalseLiteralConvertsToBoolean', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'false.convertsToBoolean()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testIntegerLiteralToBoolean', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.toBoolean()',
        ),
        [true.toFhirBoolean],
      );
    });

    //<test name="testIntegerLiteralToBooleanEmpty"
    // inputfile="patient-example.xml"><expression>2.toBoolean()
    // </expression>// empty});*/
    test('testIntegerLiteralToBooleanFalse', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '0.toBoolean()',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testStringTrueToBoolean', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'true'.toBoolean()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringFalseToBoolean', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'false'.toBoolean()",
        ),
        [false.toFhirBoolean],
      );
    });

    test('testIntegerLiteralConvertsToString', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.convertsToString()',
        ),
        [true.toFhirBoolean],
      );
    });

    // FIXED: Incorrect assumptions about precedence
    // test("testIntegerLiteralIsNotString", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1, pathExpression: r"1 is String.not()"),
    //       [true]);
    // });
    test('testIntegerLiteralIsNotString-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(1 is String).not()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testNegativeIntegerLiteralConvertsToString', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(-1).convertsToString()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testDecimalLiteralConvertsToString', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.0.convertsToString()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStringLiteralConvertsToString', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'true'.convertsToString()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLiteralConvertsToString', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'true.convertsToString()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testQuantityLiteralConvertsToString', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "1 'wk'.convertsToString()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testIntegerLiteralToString', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.toString()',
        ),
        ['1'.toFhirString],
      );
    });

    test('testNegativeIntegerLiteralToString', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(-1).toString()',
        ),
        ['-1'.toFhirString],
      );
    });

    test('testDecimalLiteralToString', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.0.toString()',
        ),
        ['1.0'.toFhirString],
      );
    });

    test('testStringLiteralToString', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'true'.toString()",
        ),
        ['true'.toFhirString],
      );
    });

    test('testBooleanLiteralToString', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'true.toString()',
        ),
        ['true'.toFhirString],
      );
    });

    test('testQuantityLiteralWkToString', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "1 'wk'.toString()",
        ),
        ["1 'wk'".toFhirString],
      );
    });

    test('testQuantityLiteralWeekToString', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1 week.toString()',
        ),
        ['1 week'.toFhirString],
      );
    });
  });

  group('testAll', () {
    test('testAllTrue1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.select(given.exists()).allTrue()',
        ),
        [true.toFhirBoolean],
      );
    });

    // Official testAllTrue2 (tests-fhir-r4.xml): => false — only the maiden
    // name has a period, so [false, false, true].allTrue() is false. (An
    // earlier revision expected [true], masking a funcAllTrue that had
    // anyTrue's break-on-first-true logic.)
    test('testAllTrue2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.select(period.exists()).allTrue()',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testAllTrue3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.all(given.exists())',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testAllTrue4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.all(period.exists())',
        ),
        [false.toFhirBoolean],
      );
    });
  });

  group('testSubSetOf', () {
    // FIXED: Unclear how $this would be populated?
    // test("testSubSetOf1", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1,
    //          pathExpression: r"Patient.name.first().subsetOf($this.name)"),
    //       [true]);
    // });
    test('testSubSetOf1-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.first().subsetOf(%context.name)',
        ),
        [true.toFhirBoolean],
      );
    });

    // FIXED
    // test("testSubSetOf2", () async {
    //     expect(
    //         await walkPath(context: patient1,
    //      pathExpression: r"Patient.name.subsetOf($this.name.first()).not()"),
    //         [true]);
    //   });
    test('testSubSetOf2-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.subsetOf(%context.name.first()).not()',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testSuperSetOf', () {
    // FIXED
    //test("testSuperSetOf1", () async {
    //   expect(
    //       await walkPath(context: patient1,
    //    pathExpression: r"Patient.name.first().supersetOf($this.name).not()"),
    //       [true]);
    // });
    test('testSuperSetOf1-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression:
              'Patient.name.first().supersetOf(%context.name).not()',
        ),
        [true.toFhirBoolean],
      );
    });

    // FIXED
    // test("testSuperSetOf2", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1,
    //           pathExpression: r"Patient.name.supersetOf($this.name.first())"),
    //       [true]);
    // });
    test('testSuperSetOf2-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.supersetOf(%context.name.first())',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testQuantity', () {
    test('testQuantity1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "4.0000 'g' = 4000.0 'mg'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testQuantity2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "4 'g' ~ 4000 'mg'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testQuantity3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "4 'g' != 4040 'mg'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testQuantity4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "4 'g' ~ 4040 'mg'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testQuantity5', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '7 days = 1 week',
        ),
        [true.toFhirBoolean],
      );
    });

    /// https://hl7.org/fhirpath/N1/#quantity-equality
    /// https://hl7.org/fhirpath/N1/#time-valued-quantities
    /// Best I can tell these are not equal, although they are equivalent.
    ///
    /// According to FHIRPath above day (year, month) don't apply:
    ///
    /// 1 day =  1 'd' and 1 day ~ 1 'd'
    /// 1 week = 1 'wk' and 1 week ~ 1 'wk' (because weeks are just days)
    ///
    /// I think it's therefore fair to assume that:
    ///
    /// 7 day = 1 'wk', but 7 day ~ 1 'wk'
    test('testQuantity6', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "7 days = 1 'wk'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testQuantity7', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '6 days < 1 week',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testQuantity8', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '8 days > 1 week',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testQuantity9', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "2.0 'cm' * 2.0 'm' = 0.040 'm2'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testQuantity10', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "4.0 'g' / 2.0 'm' = 2 'g/m'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testQuantity11', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "1.0 'm' / 1.0 'm' = 1 '1'",
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testCollectionBoolean', () {
    test('testCollectionBoolean1', () async {
      expect(
        () => walkPath(
          context: patient1,
          pathExpression: 'iif(1 | 2 | 3, true, false)',
        ),
        throwsA(const TypeMatcher<PathEngineException>()),
      );
    });

    test('testCollectionBoolean2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'iif({}, true, false)',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testCollectionBoolean3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'iif(true, true, false)',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testCollectionBoolean4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'iif({} | true, true, false)',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testCollectionBoolean5', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'iif(true, true, 1/0)',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testCollectionBoolean6', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'iif(false, 1/0, true)',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testDistinct', () {
    test('testDistinct1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(1 | 2 | 3).isDistinct()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testDistinct2', () async {
      expect(
        await walkPath(
          context: questionnaire1,
          pathExpression: 'Questionnaire.descendants().linkId.isDistinct()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testDistinct3', () async {
      expect(
        await walkPath(
          context: questionnaire1,
          pathExpression:
              'Questionnaire.descendants().linkId.select(substring(0,1)).isDistinct().not()',
        ),
        [true.toFhirBoolean],
      );
    });

    // <test name="testDistinct4" inputfile="patient-example.xml">
    // <expression>(1 | 2 | 3).distinct()</expression>
    // <output type="integer">1</output>
    // <output type="integer">2</output>
    // <output type="integer">3</output>
    // });
    test('testDistinct4', () async {
      expect(
        await walkPath(
          context: questionnaire1,
          pathExpression: '(1 | 2 | 3).distinct()',
        ),
        [
          1.toFhirInteger,
          2.toFhirInteger,
          3.toFhirInteger,
        ],
      );
    });

    // <test name="testDistinct5" inputfile="questionnaire-example.xml">
    // <expression>Questionnaire.descendants().linkId.distinct().count()</expression>
    // <output type="integer">10</output>
    // });
    test('testDistinct5', () async {
      expect(
        await walkPath(
          context: questionnaire1,
          pathExpression:
              'Questionnaire.descendants().linkId.distinct().count()',
        ),
        [10.toFhirInteger],
      );
    });

    // <test name="testDistinct6" inputfile="questionnaire-example.xml">
    // <expression>Questionnaire.descendants().linkId.select(substring(0,1))
    // .distinct().count()</expression>
    // <output type="integer">2</output>
    // });
    test('testDistinct6', () async {
      expect(
        await walkPath(
          context: questionnaire1,
          pathExpression:
              'Questionnaire.descendants().linkId.select(substring(0,1)).distinct().count()',
        ),
        [2.toFhirInteger],
      );
    });
  });

  group('testCount', () {
    test('testCount1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.count()',
        ),
        [3.toFhirInteger],
      );
    });

    test('testCount2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.count() = 3',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testCount3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.first().count()',
        ),
        [1.toFhirInteger],
      );
    });

    test('testCount4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.first().count() = 1',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testWhere', () {
    test('testWhere1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.count() = 3',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testWhere2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "Patient.name.where(given = 'Jim').count() = 1",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testWhere3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "Patient.name.where(given = 'X').count() = 0",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testWhere4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression:
              r"Patient.name.where($this.given = 'Jim').count() = 1",
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testSelect', () {
    test('testSelect1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.select(given).count() = 5',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testSelect2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.select(given | family).count() = 7 ',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testRepeat', () {
    //<test name="testRepeat1" inputfile="valueset-example-expansion.xml">
    //<expression>ValueSet.expansion.repeat(contains).count() = 10
    //</expression><output type="boolean">true</output>});*/
    test('testRepeat2', () async {
      expect(
        await walkPath(
          context: questionnaire1,
          pathExpression: 'Questionnaire.repeat(item).code.count() = 11',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testRepeat3', () async {
      expect(
        await walkPath(
          context: questionnaire1,
          pathExpression: 'Questionnaire.descendants().code.count() = 23',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testRepeat4', () async {
      expect(
        await walkPath(
          context: questionnaire1,
          pathExpression: 'Questionnaire.children().code.count() = 2',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testAggregate', () {
    test('testAggregate1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression:
              r'(1|2|3|4|5|6|7|8|9).aggregate($this+$total, 0) = 45',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testAggregate2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression:
              r'(1|2|3|4|5|6|7|8|9).aggregate($this+$total, 2) = 47',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testAggregate3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression:
              r'(1|2|3|4|5|6|7|8|9).aggregate(iif($total.empty(), $this, iif($this < $total, $this, $total))) = 1',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testAggregate4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression:
              r'(1|2|3|4|5|6|7|8|9).aggregate(iif($total.empty(), $this, iif($this > $total, $this, $total))) = 9',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testIndexer', () {
    // FIXED: Incorrect test case. Union operator does specifically not
    // guarantee an order, whereas equal (=) is specifically expecting an order.
    // test("testIndexer1", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1,
    //          pathExpression: r"Patient.name[0].given = 'Peter' | 'James'"),
    //       [true]);
    // });
    test('testIndexer1-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name[0].given',
        ),
        ['Peter'.toFhirString, 'James'.toFhirString],
      );
    });

    test('testIndexer2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "Patient.name[1].given = 'Jim'",
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testSingle', () {
    //<test name="testSingle2" inputfile="patient-example.xml">
    //<expression  invalid="semantic">
    //Patient.name.single().exists()</expression>});*/
    test('testSingle1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.first().single().exists()',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testFirstLast', () {
    // FIXED: Incorrect test case. Union operator does specifically not
    // guarantee an order
    // test("testFirstLast1", () async {
    //   expect(
    //       await walkPath(context: patient1,
    //      pathExpression: r"Patient.name.first().given = 'Peter' | 'James'"),
    //       [true]);
    // });
    test('testFirstLast1-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.first().given',
        ),
        ['Peter'.toFhirString, 'James'.toFhirString],
      );
    });

    // FIXED: Incorrect test case. Union operator does specifically not
    // guarantee an order
    // test("testFirstLast2", () async {
    //   expect(
    //       await walkPath(context: patient1, pathExpression: r"Patient.name.last().given = 'Peter' | 'James'"),
    //       [true]);
    // });
    test('testFirstLast2-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.last().given',
        ),
        ['Peter'.toFhirString, 'James'.toFhirString],
      );
    });
  });

  group('testTail', () {
    // Incorrect test case. Union operator does specifically not
    // guarantee an order
    // test("testTail1", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1,
    //           pathExpression: r"(0 | 1 | 2).tail() = 1 | 2"),
    //       [true]);
    // });

    // Incorrect test case. Union operator does specifically not
    // guarantee an order
    // test("testTail2", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1,
    //           pathExpression:
    //               r"Patient.name.tail().given = 'Jim' | 'Peter' | 'James'"),
    //       [true]);
    // });
    test('testTail2-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.tail().given',
        ),
        ['Jim'.toFhirString, 'Peter'.toFhirString, 'James'.toFhirString],
      );
    });
  });

  group('testSkip', () {
    // FIXED: Incorrect test case. Assumes order of union
    test('testSkip1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(0 | 1 | 2).skip(1) = 1 | 2',
        ),
        [true.toFhirBoolean],
      );
    });

    // Incorrect test case. Assumes order of union
    test('testSkip2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(0 | 1 | 2).skip(2) = 2',
        ),
        [true.toFhirBoolean],
      );
    });

    // FIXED: Incorrect test case. Assumes order of union
    test('testSkip3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression:
              "Patient.name.skip(1).given.trace('test') = 'Jim' | 'Peter' | 'James'",
        ),
        [true.toFhirBoolean],
      );
    });
    test('testSkip3-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "Patient.name.skip(1).given.trace('test')",
        ),
        ['Jim'.toFhirString, 'Peter'.toFhirString, 'James'.toFhirString],
      );
    });

    test('testSkip4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.skip(3).given.exists() = false',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testTake', () {
    // Incorrect test case. Assumes order of union*      test('testTake1', () async {
    // expect(
    //   await walkPath(
    //     context: patient1,
    //     pathExpression: '(0 | 1 | 2).take(1) = 0',
    //   ),
    //   [true],
    // );

    // Incorrect test case. Assumes order of union
    test('testTake2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(0 | 1 | 2).take(2) = 0 | 1',
        ),
        [true.toFhirBoolean],
      );
    });

    // FIXED: Incorrect test case. Assumes order of union
    test('testTake3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "Patient.name.take(1).given = 'Peter' | 'James'",
        ),
        [true.toFhirBoolean],
      );
    });
    test('testTake3-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.take(1).given',
        ),
        ['Peter'.toFhirString, 'James'.toFhirString],
      );
    });

    // FIXED: Incorrect test case. Assumes order of union
    test('testTake4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression:
              "Patient.name.take(2).given = 'Peter' | 'James' | 'Jim'",
        ),
        [true.toFhirBoolean],
      );
    });
    test('testTake4-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.take(2).given',
        ),
        ['Peter'.toFhirString, 'James'.toFhirString, 'Jim'.toFhirString],
      );
    });

    test('testTake5', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.take(3).given.count() = 5',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testTake6', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.take(4).given.count() = 5',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testTake7', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.name.take(0).given.exists() = false',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testIif', () {
    test('testIif1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression:
              "iif(Patient.name.exists(), 'named', 'unnamed') = 'named'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testIif2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression:
              "iif(Patient.name.empty(), 'unnamed', 'named') = 'named'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testIif3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'iif(true, true, (1 | 2).toString())',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testIif4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'iif(false, (1 | 2).toString(), true)',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testToInteger', () {
    test('testToInteger1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'1'.toInteger() = 1",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testToInteger2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'-1'.toInteger() = -1",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testToInteger3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'0'.toInteger() = 0",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testToInteger4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'0.0'.toInteger().empty()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testToInteger5', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'st'.toInteger().empty()",
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testToDecimal', () {
    test('testToDecimal1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'1'.toDecimal() = 1",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testToDecimal2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'-1'.toInteger() = -1",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testToDecimal3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'0'.toDecimal() = 0",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testToDecimal4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'0.0'.toDecimal() = 0.0",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testToDecimal5', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'st'.toDecimal().empty()",
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testToString', () {
    test('testToString1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "1.toString() = '1'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testToString2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'-1'.toInteger() = -1",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testToString3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "0.toString() = '0'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testToString4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "0.0.toString() = '0.0'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testToString5', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "@2014-12-14.toString() = '2014-12-14'",
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testCase', () {
    test('testCase1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'t'.upper() = 'T'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testCase2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'t'.lower() = 't'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testCase3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'T'.upper() = 'T'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testCase4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'T'.lower() = 't'",
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testToChars', () {
    // FIXED: Incorrect test case. Union has no guaranteed order
    // test("testToChars1", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1,
    //           pathExpression: r"'t2'.toChars() = 't' | '2'"),
    //       [true]);
    // });
    test('testToChars1-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'t2'.toChars()",
        ),
        [
          't'.toFhirString,
          '2'.toFhirString,
        ],
      );
    });
  });

  group('testSubstring', () {
    test('testSubstring1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.substring(2) = '345'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testSubstring2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.substring(2,1) = '3'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testSubstring3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.substring(2,5) = '345'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testSubstring4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.substring(25).empty()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testSubstring5', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.substring(-1).empty()",
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testStartsWith', () {
    test('testStartsWith1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.startsWith('2') = false",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStartsWith2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.startsWith('1') = true",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStartsWith3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.startsWith('12') = true",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStartsWith4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.startsWith('13') = false",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStartsWith5', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.startsWith('12345') = true",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStartsWith6', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.startsWith('123456') = false",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testStartsWith7', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.startsWith('') = true",
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testEndsWith', () {
    test('testEndsWith1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.endsWith('2') = false",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testEndsWith2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.endsWith('5') = true",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testEndsWith3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.endsWith('45') = true",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testEndsWith4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.endsWith('35') = false",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testEndsWith5', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.endsWith('12345') = true",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testEndsWith6', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.endsWith('012345') = false",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testEndsWith7', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.endsWith('') = true",
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testContainsString', () {
    test('testContainsString1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.contains('6') = false",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testContainsString2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.contains('5') = true",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testContainsString3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.contains('45') = true",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testContainsString4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.contains('35') = false",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testContainsString5', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.contains('12345') = true",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testContainsString6', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.contains('012345') = false",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testContainsString7', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.contains('') = true",
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testLength', () {
    test('testLength1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'123456'.length() = 6",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLength2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'12345'.length() = 5",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLength3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'123'.length() = 3",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLength4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'1'.length() = 1",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLength5', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "''.length() = 0",
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testTrace', () {
    test('testTrace1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "name.given.trace('test').count() = 5",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testTrace2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "name.trace('test', given).count() = 3",
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testToday', () {
    test('testToday1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.birthDate < today()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testToday2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'today().toString().length() = 10',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testNow', () {
    test('testNow1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.birthDate < now()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testNow2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'now().toString().length() > 10',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testEquality', () {
    test('testEquality1', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 = 1'),
        [true.toFhirBoolean],
      );
    });

    test('testEquality2', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '{} = {}'),
        <FhirBase>[],
      );
    });

    test('testEquality3', () async {
      expect(
        await walkPath(context: patient1, pathExpression: 'true = {}'),
        <FhirBase>[],
      );
    });

    test('testEquality4', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '(1) = (1)'),
        [true.toFhirBoolean],
      );
    });

    // FIXED: This test is applying =, which are explicitly order-dependent,
    // on two unions, which are explicitly not order-dependent
    // test("testEquality5", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1, pathExpression: r"(1 | 2) = (1 | 2)"),
    //       [true]);
    // });
    test('testEquality5-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(1 | 2) ~ (1 | 2)',
        ),
        [true.toFhirBoolean],
      );
    });

    // FIXED: This test is applying =, which are explicitly order-dependent,
    // on two unions, which are explicitly not order-dependent
    // test("testEquality6", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1,
    //           pathExpression: r"(1 | 2 | 3) = (1 | 2 | 3)"),
    //       [true]);
    // });
    test('testEquality6-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(1 | 2 | 3) ~ (1 | 2 | 3)',
        ),
        [true.toFhirBoolean],
      );
    });

    // FIXED: This test is applying =, which are explicitly order-dependent,
    // on two unions, which are explicitly not order-dependent
    // test("testEquality7", () async {
    //   expect(await walkPath(context: patient1, "(1 | 1) = (1 | 2 | {})"),
    //       []);
    // });
    test('testEquality7-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(1 | 1) ~ (1 | 2 | {})',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testEquality8', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 = 2'),
        [false.toFhirBoolean],
      );
    });

    test('testEquality9', () async {
      expect(
        await walkPath(context: patient1, pathExpression: "'a' = 'a'"),
        [true.toFhirBoolean],
      );
    });

    test('testEquality10', () async {
      expect(
        await walkPath(context: patient1, pathExpression: "'a' = 'A'"),
        [false.toFhirBoolean],
      );
    });

    test('testEquality11', () async {
      expect(
        await walkPath(context: patient1, pathExpression: "'a' = 'b'"),
        [false.toFhirBoolean],
      );
    });

    test('testEquality12', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1.1 = 1.1'),
        [true.toFhirBoolean],
      );
    });

    test('testEquality13', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1.1 = 1.2'),
        [false.toFhirBoolean],
      );
    });

    test('testEquality14', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.10 = 1.1',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testEquality15', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '0 = 0'),
        [true.toFhirBoolean],
      );
    });

    test('testEquality16', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '0.0 = 0'),
        [true.toFhirBoolean],
      );
    });

    test('testEquality17', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2012-04-15 = @2012-04-15',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testEquality18', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2012-04-15 = @2012-04-16',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testEquality19', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2012-04-15 = @2012-04-15T10:00:00',
        ),
        <FhirBase>[],
      );
    });

    test('testEquality20', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2012-04-15T15:00:00 = @2012-04-15T10:00:00',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testEquality21', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2012-04-15T15:30:31 = @2012-04-15T15:30:31.0',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testEquality22', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2012-04-15T15:30:31 = @2012-04-15T15:30:31.1',
        ),
        [false.toFhirBoolean],
      );
    });

    // Official testEquality23: empty — one operand has a timezone and the
    // other does not, and the two could denote the same instant in some
    // timezone, so the comparison is indeterminate. (An earlier revision
    // expected [false], masking the missing timezone-presence rule.)
    test('testEquality23', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2012-04-15T15:00:00Z = @2012-04-15T10:00:00',
        ),
        <FhirBase>[],
      );
    });

    test('testEquality24', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression:
              '@2012-04-15T15:00:00+02:00 = @2012-04-15T16:00:00+03:00',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testEquality25', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'name = name',
        ),
        [true.toFhirBoolean],
      );
    });

    // FIXED: union is not in defined order
    // test("testEquality26", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1,
    //           pathExpression:
    //               r"name.take(2) = name.take(2).first() | name.take(2).last()"),
    //       [true]);
    // });
    test('testEquality26-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: r'name.take(2) = name.take(2).select($this)',
        ),
        [true.toFhirBoolean],
      );
    });

    // Incorrect: union is not in defined order
    // test("testEquality27", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1,
    //           pathExpression:
    //               r"name.take(2) = name.take(2).last() | name.take(2).first()"),
    //       [false]);
    // });

    test('testEquality28', () async {
      expect(
        await walkPath(
          context: observation1,
          pathExpression: "Observation.value = 185 '[lb_av]'",
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testNEquality', () {
    test('testNEquality1', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 != 1'),
        [false.toFhirBoolean],
      );
    });

    test('testNEquality2', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '{} != {}'),
        <FhirBase>[],
      );
    });

    test('testNEquality3', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 != 2'),
        [true.toFhirBoolean],
      );
    });

    test('testNEquality4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'a' != 'a'",
        ),
        [false.toFhirBoolean],
      );
    });

    test('testNEquality5', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'a' != 'b'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testNEquality6', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.1 != 1.1',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testNEquality7', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.1 != 1.2',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testNEquality8', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.10 != 1.1',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testNEquality9', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '0 != 0'),
        [false.toFhirBoolean],
      );
    });

    test('testNEquality10', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '0.0 != 0'),
        [false.toFhirBoolean],
      );
    });

    test('testNEquality11', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2012-04-15 != @2012-04-15',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testNEquality12', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2012-04-15 != @2012-04-16',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testNEquality13', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2012-04-15 != @2012-04-15T10:00:00',
        ),
        <FhirBase>[],
      );
    });

    test('testNEquality14', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2012-04-15T15:00:00 != @2012-04-15T10:00:00',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testNEquality15', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2012-04-15T15:30:31 != @2012-04-15T15:30:31.0',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testNEquality16', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2012-04-15T15:30:31 != @2012-04-15T15:30:31.1',
        ),
        [true.toFhirBoolean],
      );
    });

    // Official testNEquality17: empty — same timezone-presence
    // indeterminacy as testEquality23. (Earlier revisions, including a
    // duplicate "-fixed" copy, expected [true].)
    test('testNEquality17', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2012-04-15T15:00:00Z != @2012-04-15T10:00:00',
        ),
        <FhirBase>[],
      );
    });

    test('testNEquality18', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression:
              '@2012-04-15T15:00:00+02:00 != @2012-04-15T16:00:00+03:00',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testNEquality19', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'name != name',
        ),
        [false.toFhirBoolean],
      );
    });

    // Incorrect: assumptions about order
    // test("testNEquality20", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1,
    //           pathExpression:
    //               r"name.take(2) != name.take(2).first() | name.take(2).last()"),
    //       [false]);
    // });

    // Incorrect: assumptions about order
    // test("testNEquality21", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1,
    //           pathExpression:
    //               r"name.take(2) != name.take(2).last() | name.take(2).first()"),
    //       [true]);
    // });

    test('testNEquality22', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.2 / 1.8 != 0.6666667',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testNEquality23', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(1.2 / 1.8).round(2) != 0.67',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testNEquality24', () async {
      expect(
        await walkPath(
          context: observation1,
          pathExpression: "Observation.value != 185 'kg'",
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testEquivalent', () {
    test('testEquivalent1', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 ~ 1'),
        [true.toFhirBoolean],
      );
    });

    test('testEquivalent2', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '{} ~ {}'),
        [true.toFhirBoolean],
      );
    });

    test('testEquivalent3', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 ~ {}'),
        [false.toFhirBoolean],
      );
    });

    test('testEquivalent4', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 ~ 2'),
        [false.toFhirBoolean],
      );
    });

    test('testEquivalent5', () async {
      expect(
        await walkPath(context: patient1, pathExpression: "'a' ~ 'a'"),
        [true.toFhirBoolean],
      );
    });

    test('testEquivalent6', () async {
      expect(
        await walkPath(context: patient1, pathExpression: "'a' ~ 'A'"),
        [true.toFhirBoolean],
      );
    });

    test('testEquivalent7', () async {
      expect(
        await walkPath(context: patient1, pathExpression: "'a' ~ 'b'"),
        [false.toFhirBoolean],
      );
    });

    test('testEquivalent8', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1.1 ~ 1.1'),
        [true.toFhirBoolean],
      );
    });

    test('testEquivalent9', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1.1 ~ 1.2'),
        [false.toFhirBoolean],
      );
    });

    test('testEquivalent10', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.10 ~ 1.1',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testEquivalent11', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.2 / 1.8 ~ 0.67',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testEquivalent12', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '0 ~ 0'),
        [true.toFhirBoolean],
      );
    });

    test('testEquivalent13', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '0.0 ~ 0'),
        [true.toFhirBoolean],
      );
    });

    test('testEquivalent14', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2012-04-15 ~ @2012-04-15',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testEquivalent15', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2012-04-15 ~ @2012-04-16',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testEquivalent16', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2012-04-15 ~ @2012-04-15T10:00:00',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testEquivalent17', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2012-04-15T15:30:31 ~ @2012-04-15T15:30:31.0',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testEquivalent18', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2012-04-15T15:30:31 ~ @2012-04-15T15:30:31.1',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testEquivalent19', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'name ~ name',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testEquivalent20', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression:
              'name.take(2).given ~ name.take(2).first().given | name.take(2).last().given',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testEquivalent21', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression:
              'name.take(2).given ~ name.take(2).last().given | name.take(2).first().given',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testEquivalent22', () async {
      expect(
        await walkPath(
          context: observation1,
          pathExpression: "Observation.value ~ 185 '[lb_av]'",
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testNotEquivalent', () {
    test('testNotEquivalent1', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 !~ 1'),
        [false.toFhirBoolean],
      );
    });

    test('testNotEquivalent2', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '{} !~ {}'),
        [false.toFhirBoolean],
      );
    });

    test('testNotEquivalent3', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '{} !~ 1'),
        [true.toFhirBoolean],
      );
    });

    test('testNotEquivalent4', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 !~ 2'),
        [true.toFhirBoolean],
      );
    });

    test('testNotEquivalent5', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'a' !~ 'a'",
        ),
        [false.toFhirBoolean],
      );
    });

    test('testNotEquivalent6', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'a' !~ 'A'",
        ),
        [false.toFhirBoolean],
      );
    });

    test('testNotEquivalent7', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'a' !~ 'b'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testNotEquivalent8', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.1 !~ 1.1',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testNotEquivalent9', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.1 !~ 1.2',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testNotEquivalent10', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.10 !~ 1.1',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testNotEquivalent11', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '0 !~ 0'),
        [false.toFhirBoolean],
      );
    });

    test('testNotEquivalent12', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '0.0 !~ 0'),
        [false.toFhirBoolean],
      );
    });

    test('testNotEquivalent13', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.2 / 1.8 !~ 0.6',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testNotEquivalent14', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2012-04-15 !~ @2012-04-15',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testNotEquivalent15', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2012-04-15 !~ @2012-04-16',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testNotEquivalent16', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2012-04-15 !~ @2012-04-15T10:00:00',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testNotEquivalent17', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2012-04-15T15:30:31 !~ @2012-04-15T15:30:31.0',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testNotEquivalent18', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2012-04-15T15:30:31 !~ @2012-04-15T15:30:31.1',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testNotEquivalent19', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'name !~ name',
        ),
        [false.toFhirBoolean],
      );
    });

    // Incorrect: Keep assuming order
    // test("testNotEquivalent20", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1,
    //           pathExpression:
    //               r"name.take(2).given !~ name.take(2).first().given | name.take(2).last().given"),
    //       [false]);
    // });

    // Incorrect: Keep assuming order
    // test("testNotEquivalent21", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1,
    //           pathExpression:
    //               r"name.take(2).given !~ name.take(2).last().given | name.take(2).first().given"),
    //       [false]);
    // });

    test('testNotEquivalent22', () async {
      expect(
        await walkPath(
          context: observation1,
          pathExpression: "Observation.value !~ 185 'kg'",
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testLessThan', () {
    test('testLessThan1', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 < 2'),
        [true.toFhirBoolean],
      );
    });

    test('testLessThan2', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1.0 < 1.2'),
        [true.toFhirBoolean],
      );
    });

    test('testLessThan3', () async {
      expect(
        await walkPath(context: patient1, pathExpression: "'a' < 'b'"),
        [true.toFhirBoolean],
      );
    });

    test('testLessThan4', () async {
      expect(
        await walkPath(context: patient1, pathExpression: "'A' < 'a'"),
        [true.toFhirBoolean],
      );
    });

    test('testLessThan5', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2014-12-12 < @2014-12-13',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLessThan6', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2014-12-13T12:00:00 < @2014-12-13T12:00:01',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLessThan7', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@T12:00:00 < @T14:00:00',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLessThan8', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 < 1'),
        [false.toFhirBoolean],
      );
    });

    test('testLessThan9', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1.0 < 1.0'),
        [false.toFhirBoolean],
      );
    });

    test('testLessThan10', () async {
      expect(
        await walkPath(context: patient1, pathExpression: "'a' < 'a'"),
        [false.toFhirBoolean],
      );
    });

    test('testLessThan11', () async {
      expect(
        await walkPath(context: patient1, pathExpression: "'A' < 'A'"),
        [false.toFhirBoolean],
      );
    });

    test('testLessThan12', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2014-12-12 < @2014-12-12',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testLessThan13', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2014-12-13T12:00:00 < @2014-12-13T12:00:00',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testLessThan14', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@T12:00:00 < @T12:00:00',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testLessThan15', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '2 < 1'),
        [false.toFhirBoolean],
      );
    });

    test('testLessThan16', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1.1 < 1.0'),
        [false.toFhirBoolean],
      );
    });

    test('testLessThan17', () async {
      expect(
        await walkPath(context: patient1, pathExpression: "'b' < 'a'"),
        [false.toFhirBoolean],
      );
    });

    test('testLessThan18', () async {
      expect(
        await walkPath(context: patient1, pathExpression: "'B' < 'A'"),
        [false.toFhirBoolean],
      );
    });

    test('testLessThan19', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2014-12-13 < @2014-12-12',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testLessThan20', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2014-12-13T12:00:01 < @2014-12-13T12:00:00',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testLessThan21', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@T12:00:01 < @T12:00:00',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testLessThan22', () async {
      expect(
        await walkPath(
          context: observation1,
          pathExpression: "Observation.value < 200 '[lb_av]'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLessThan23', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2018-03 < @2018-03-01',
        ),
        <FhirBase>[],
      );
    });

    test('testLessThan24', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2018-03-01T10 < @2018-03-01T10:30',
        ),
        <FhirBase>[],
      );
    });

    test('testLessThan25', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@T10 < @T10:30',
        ),
        <FhirBase>[],
      );
    });

    test('testLessThan26', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2018-03-01T10:30:00 < @2018-03-01T10:30:00.0',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testLessThan27', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@T10:30:00 < @T10:30:00.0',
        ),
        [false.toFhirBoolean],
      );
    });
  });

  group('testLessOrEqual', () {
    test('testLessOrEqual1', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 <= 2'),
        [true.toFhirBoolean],
      );
    });

    test('testLessOrEqual2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.0 <= 1.2',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLessOrEqual3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'a' <= 'b'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLessOrEqual4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'A' <= 'a'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLessOrEqual5', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2014-12-12 <= @2014-12-13',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLessOrEqual6', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2014-12-13T12:00:00 <= @2014-12-13T12:00:01',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLessOrEqual7', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@T12:00:00 <= @T14:00:00',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLessOrEqual8', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 <= 1'),
        [true.toFhirBoolean],
      );
    });

    test('testLessOrEqual9', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.0 <= 1.0',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLessOrEqual10', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'a' <= 'a'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLessOrEqual11', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'A' <= 'A'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLessOrEqual12', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2014-12-12 <= @2014-12-12',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLessOrEqual13', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2014-12-13T12:00:00 <= @2014-12-13T12:00:00',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLessOrEqual14', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@T12:00:00 <= @T12:00:00',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLessOrEqual15', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '2 <= 1'),
        [false.toFhirBoolean],
      );
    });

    test('testLessOrEqual16', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.1 <= 1.0',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testLessOrEqual17', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'b' <= 'a'",
        ),
        [false.toFhirBoolean],
      );
    });

    test('testLessOrEqual18', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'B' <= 'A'",
        ),
        [false.toFhirBoolean],
      );
    });

    test('testLessOrEqual19', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2014-12-13 <= @2014-12-12',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testLessOrEqual20', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2014-12-13T12:00:01 <= @2014-12-13T12:00:00',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testLessOrEqual21', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@T12:00:01 <= @T12:00:00',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testLessOrEqual22', () async {
      expect(
        await walkPath(
          context: observation1,
          pathExpression: "Observation.value <= 200 '[lb_av]'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLessOrEqual23', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2018-03 <= @2018-03-01',
        ),
        <FhirBase>[],
      );
    });

    test('testLessOrEqual24', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2018-03-01T10 <= @2018-03-01T10:30',
        ),
        <FhirBase>[],
      );
    });

    test('testLessOrEqual25', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@T10 <= @T10:30',
        ),
        <FhirBase>[],
      );
    });

    test('testLessOrEqual26', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2018-03-01T10:30:00 <= @2018-03-01T10:30:00.0',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLessOrEqual27', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@T10:30:00 <= @T10:30:00.0',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testGreatorOrEqual', () {
    test('testGreatorOrEqual1', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 >= 2'),
        [false.toFhirBoolean],
      );
    });

    test('testGreatorOrEqual2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.0 >= 1.2',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testGreatorOrEqual3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'a' >= 'b'",
        ),
        [false.toFhirBoolean],
      );
    });

    test('testGreatorOrEqual4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'A' >= 'a'",
        ),
        [false.toFhirBoolean],
      );
    });

    test('testGreatorOrEqual5', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2014-12-12 >= @2014-12-13',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testGreatorOrEqual6', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2014-12-13T12:00:00 >= @2014-12-13T12:00:01',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testGreatorOrEqual7', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@T12:00:00 >= @T14:00:00',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testGreatorOrEqual8', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 >= 1'),
        [true.toFhirBoolean],
      );
    });

    test('testGreatorOrEqual9', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.0 >= 1.0',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testGreatorOrEqual10', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'a' >= 'a'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testGreatorOrEqual11', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'A' >= 'A'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testGreatorOrEqual12', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2014-12-12 >= @2014-12-12',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testGreatorOrEqual13', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2014-12-13T12:00:00 >= @2014-12-13T12:00:00',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testGreatorOrEqual14', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@T12:00:00 >= @T12:00:00',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testGreatorOrEqual15', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '2 >= 1'),
        [true.toFhirBoolean],
      );
    });

    test('testGreatorOrEqual16', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.1 >= 1.0',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testGreatorOrEqual17', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'b' >= 'a'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testGreatorOrEqual18', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'B' >= 'A'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testGreatorOrEqual19', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2014-12-13 >= @2014-12-12',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testGreatorOrEqual20', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2014-12-13T12:00:01 >= @2014-12-13T12:00:00',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testGreatorOrEqual21', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@T12:00:01 >= @T12:00:00',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testGreatorOrEqual22', () async {
      expect(
        await walkPath(
          context: observation1,
          pathExpression: "Observation.value >= 100 '[lb_av]'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testGreatorOrEqual23', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2018-03 >= @2018-03-01',
        ),
        <FhirBase>[],
      );
    });

    test('testGreatorOrEqual24', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2018-03-01T10 >= @2018-03-01T10:30',
        ),
        <FhirBase>[],
      );
    });

    test('testGreatorOrEqual25', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@T10 >= @T10:30',
        ),
        <FhirBase>[],
      );
    });

    test('testGreatorOrEqual26', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2018-03-01T10:30:00 >= @2018-03-01T10:30:00.0',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testGreatorOrEqual27', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@T10:30:00 >= @T10:30:00.0',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testGreaterThan', () {
    test('testGreaterThan1', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 > 2'),
        [false.toFhirBoolean],
      );
    });

    test('testGreaterThan2', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1.0 > 1.2'),
        [false.toFhirBoolean],
      );
    });

    test('testGreaterThan3', () async {
      expect(
        await walkPath(context: patient1, pathExpression: "'a' > 'b'"),
        [false.toFhirBoolean],
      );
    });

    test('testGreaterThan4', () async {
      expect(
        await walkPath(context: patient1, pathExpression: "'A' > 'a'"),
        [false.toFhirBoolean],
      );
    });

    test('testGreaterThan5', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2014-12-12 > @2014-12-13',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testGreaterThan6', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2014-12-13T12:00:00 > @2014-12-13T12:00:01',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testGreaterThan7', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@T12:00:00 > @T14:00:00',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testGreaterThan8', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 > 1'),
        [false.toFhirBoolean],
      );
    });

    test('testGreaterThan9', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1.0 > 1.0'),
        [false.toFhirBoolean],
      );
    });

    test('testGreaterThan10', () async {
      expect(
        await walkPath(context: patient1, pathExpression: "'a' > 'a'"),
        [false.toFhirBoolean],
      );
    });

    test('testGreaterThan11', () async {
      expect(
        await walkPath(context: patient1, pathExpression: "'A' > 'A'"),
        [false.toFhirBoolean],
      );
    });

    test('testGreaterThan12', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2014-12-12 > @2014-12-12',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testGreaterThan13', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2014-12-13T12:00:00 > @2014-12-13T12:00:00',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testGreaterThan14', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@T12:00:00 > @T12:00:00',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testGreaterThan15', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '2 > 1'),
        [true.toFhirBoolean],
      );
    });

    test('testGreaterThan16', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1.1 > 1.0'),
        [true.toFhirBoolean],
      );
    });

    test('testGreaterThan17', () async {
      expect(
        await walkPath(context: patient1, pathExpression: "'b' > 'a'"),
        [true.toFhirBoolean],
      );
    });

    test('testGreaterThan18', () async {
      expect(
        await walkPath(context: patient1, pathExpression: "'B' > 'A'"),
        [true.toFhirBoolean],
      );
    });

    test('testGreaterThan19', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2014-12-13 > @2014-12-12',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testGreaterThan20', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2014-12-13T12:00:01 > @2014-12-13T12:00:00',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testGreaterThan21', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@T12:00:01 > @T12:00:00',
        ),
        [true.toFhirBoolean],
      );
    });

    // Compare Quantity objects to ValidatedQuantity
    test('testGreaterThan22', () async {
      expect(
        await walkPath(
          context: observation1,
          pathExpression: "Observation.value > 100 '[lb_av]'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testGreaterThan23', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2018-03 > @2018-03-01',
        ),
        <FhirBase>[],
      );
    });

    test('testGreaterThan24', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2018-03-01T10 > @2018-03-01T10:30',
        ),
        <FhirBase>[],
      );
    });

    test('testGreaterThan25', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@T10 > @T10:30',
        ),
        <FhirBase>[],
      );
    });

    test('testGreaterThan26', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@2018-03-01T10:30:00 > @2018-03-01T10:30:00.0',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testGreaterThan27', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '@T10:30:00 > @T10:30:00.0',
        ),
        [false.toFhirBoolean],
      );
    });
  });

  group('testUnion', () {
    test('testUnion1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(1 | 2 | 3).count() = 3',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testUnion2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(1 | 2 | 2).count() = 2',
        ),
        [true.toFhirBoolean],
      );
    }); // merge duplicates

    test('testUnion3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(1|1).count() = 1',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testUnion4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.union(2).union(3).count() = 3',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testUnion5', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.union(2.union(3)).count() = 3',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testUnion6', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(1 | 2).combine(2).count() = 3',
        ),
        [true.toFhirBoolean],
      );
    }); // do not merge duplicates

    test('testUnion7', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.combine(1).count() = 2',
        ),
        [true.toFhirBoolean],
      );
    }); // do not merge duplicates

    test('testUnion8', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.combine(1).union(2).count() = 2',
        ),
        [true.toFhirBoolean],
      );
    }); // do not merge duplicates
  });

  group('testIntersect', () {
    test('testIntersect1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(1 | 2 | 3).intersect(2 | 4) = 2',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testIntersect2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(1 | 2).intersect(4).empty()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testIntersect3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(1 | 2).intersect({}).empty()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testIntersect4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.combine(1).intersect(1).count() = 1',
        ),
        [true.toFhirBoolean],
      );
    }); // do not merge duplicates
  });

  group('testExclude', () {
    test('testExclude1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(1 | 2 | 3).exclude(2 | 4) = 1 | 3',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testExclude2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(1 | 2).exclude(4) = 1 | 2',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testExclude3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(1 | 2).exclude({}) = 1 | 2',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testExclude4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.combine(1).exclude(2).count() = 2',
        ),
        [true.toFhirBoolean],
      );
    }); // do not merge duplicates
  });

  group('testIn', () {
    test('testIn1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1 in (1 | 2 | 3)',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testIn2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1 in (2 | 3)',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testIn3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'a' in ('a' | 'c' | 'd')",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testIn4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'b' in ('a' | 'c' | 'd')",
        ),
        [false.toFhirBoolean],
      );
    });
  });

  group('testContainsCollection', () {
    test('testContainsCollection1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(1 | 2 | 3) contains 1',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testContainsCollection2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(2 | 3) contains 1 ',
        ),
        [false.toFhirBoolean],
      );
    });

    test('testContainsCollection3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "('a' | 'c' | 'd') contains 'a'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testContainsCollection4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "('a' | 'c' | 'd') contains 'b'",
        ),
        [false.toFhirBoolean],
      );
    });
  });

  group('testBooleanLogicAnd', () {
    test('testBooleanLogicAnd1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(true and true) = true',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLogicAnd2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(true and false) = false',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLogicAnd3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(true and {}).empty()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLogicAnd4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(false and true) = false',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLogicAnd5', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(false and false) = false',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLogicAnd6', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(false and {}) = false',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLogicAnd7', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '({} and true).empty()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLogicAnd8', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '({} and false) = false',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLogicAnd9', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '({} and {}).empty()',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testBooleanLogicOr', () {
    test('testBooleanLogicOr1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(true or true) = true',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLogicOr2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(true or false) = true',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLogicOr3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(true or {}) = true',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLogicOr4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(false or true) = true',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLogicOr5', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(false or false) = false',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLogicOr6', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(false or {}).empty()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLogicOr7', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '({} or true) = true',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLogicOr8', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '({} or false).empty()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLogicOr9', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '({} or {}).empty()',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testBooleanLogicXOr', () {
    test('testBooleanLogicXOr1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(true xor true) = false',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLogicXOr2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(true xor false) = true',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLogicXOr3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(true xor {}).empty()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLogicXOr4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(false xor true) = true',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLogicXOr5', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(false xor false) = false',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLogicXOr6', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(false xor {}).empty()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLogicXOr7', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '({} xor true).empty()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLogicXOr8', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '({} xor false).empty()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanLogicXOr9', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '({} xor {}).empty()',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testBooleanImplies', () {
    test('testBooleanImplies1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(true implies true) = true',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanImplies2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(true implies false) = false',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanImplies3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(true implies {}).empty()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanImplies4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(false implies true) = true',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanImplies5', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(false implies false) = true',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanImplies6', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(false implies {}) = true',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanImplies7', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '({} implies true) = true',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanImplies8', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '({} implies false).empty()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testBooleanImplies9', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '({} implies {}).empty()',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testPlus', () {
    test('testPlus1', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 + 1 = 2'),
        [true.toFhirBoolean],
      );
    });

    test('testPlus2', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 + 0 = 1'),
        [true.toFhirBoolean],
      );
    });

    test('testPlus3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.2 + 1.8 = 3.0',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testPlus4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'a'+'b' = 'ab'",
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testConcatenate', () {
    test('testConcatenate1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'a' & 'b' = 'ab'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testConcatenate2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "'1' & {} = '1'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testConcatenate3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "{} & 'b' = 'b'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testConcatenate4', () async {
      expect(
        () => walkPath(
          context: patient1,
          pathExpression: "(1 | 2 | 3) & 'b' = '1,2,3b'",
        ),
        throwsA(const TypeMatcher<PathEngineException>()),
      );
    });
  });

  group('testMinus', () {
    test('testMinus1', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 - 1 = 0'),
        [true.toFhirBoolean],
      );
    });

    test('testMinus2', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 - 0 = 1'),
        [true.toFhirBoolean],
      );
    });

    // FIXED: This fails, because Dart thinks 1.8-1.2 = 0.6000000000000001
    // test("testMinus3", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1, pathExpression: r"1.8 - 1.2 = 0.6"),
    //       [true]);
    // });
    test('testMinus3-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(1.8 - 1.2).round(8) = 0.6',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testMinus4', () async {
      expect(
        () => walkPath(
          context: patient1,
          pathExpression: "'a'-'b' = 'ab'",
        ),
        throwsA(const TypeMatcher<PathEngineException>()),
      );
    });
  });

  group('testMultiply', () {
    test('testMultiply1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.2 * 1.8 = 2.16',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testMultiply2', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 * 1 = 1'),
        [true.toFhirBoolean],
      );
    });

    test('testMultiply3', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 * 0 = 0'),
        [true.toFhirBoolean],
      );
    });
  });

  group('testDivide', () {
    test('testDivide1', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 / 1 = 1'),
        [true.toFhirBoolean],
      );
    });

    test('testDivide2', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '4 / 2 = 2'),
        [true.toFhirBoolean],
      );
    });

    test('testDivide3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '4.0 / 2.0 = 2.0',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testDivide4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1 / 2 = 0.5',
        ),
        [true.toFhirBoolean],
      );
    });

    // FIXED: Already discussed on Zulip, this should round to 8 digits prior
    // to comparison
    // test("testDivide5", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1,
    //           pathExpression: r"1.2 / 1.8 = 0.66666667"),
    //       [true]);
    // });
    test('testDivide5-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(1.2 / 1.8).round(8) = 0.66666667',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testDivide6', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '1 / 0'),
        <FhirBase>[],
      );
    });
  });

  group('testDiv', () {
    test('testDiv1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1 div 1 = 1',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testDiv2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '4 div 2 = 2',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testDiv3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '5 div 2 = 2',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testDiv4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '2.2 div 1.8 = 1',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testDiv5', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '5 div 0'),
        <FhirBase>[],
      );
    });
  });

  group('testMod', () {
    test('testMod1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1 mod 1 = 0',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testMod2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '4 mod 2 = 0',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testMod3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '5 mod 2 = 1',
        ),
        [true.toFhirBoolean],
      );
    });

    // FIXED: Not passing because Dart thinks this is 0.40000000000000013
    // test("testMod4", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1, pathExpression: r"2.2 mod 1.8 = 0.4"),
    //       [true]);
    // });
    test('testMod4-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(2.2 mod 1.8).round(8) = 0.4',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testMod5', () async {
      expect(
        await walkPath(context: patient1, pathExpression: '5 mod 0'),
        <FhirBase>[],
      );
    });
  });

  group('testRound', () {
    test('testRound1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.round() = 1',
        ),
        [true.toFhirBoolean],
      );
    });

    // FIXED: Incorrect test case: 3.14159.round(3) // 3.142
    // test("testRound2", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1,
    //           pathExpression: r"3.14159.round(3) = 2"),
    //       [true]);
    // });
    test('testRound2-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '3.14159.round(3) = 3.142',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testSqrt', () {
    test('testSqrt1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '81.sqrt() = 9.0',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testSqrt2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(-1).sqrt()',
        ),
        <FhirBase>[],
      );
    });
  });

  group('testAbs', () {
    test('testAbs1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(-5).abs() = 5',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testAbs2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(-5.5).abs() = 5.5',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testAbs3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "(-5.5 'mg').abs() = 5.5 'mg'",
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testCeiling', () {
    test('testCeiling1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.ceiling() = 1',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testCeiling2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(-1.1).ceiling() = -1',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testCeiling3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.1.ceiling() = 2',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testExp', () {
    test('testExp1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '0.exp() = 1',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testExp2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(-0.0).exp() = 1',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testFloor', () {
    test('testFloor1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.floor() = 1',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testFloor2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '2.1.floor() = 2',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testFloor3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(-2.1).floor() = -3',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testLn', () {
    test('testLn1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.ln() = 0.0',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLn2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.0.ln() = 0.0',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testLog', () {
    test('testLog1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '16.log(2) = 4.0',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testLog2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '100.0.log(10.0) = 2.0',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testPower', () {
    test('testPower1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '2.power(3) = 8',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testPower2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '2.5.power(2) = 6.25',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testPower3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(-1).power(0.5)',
        ),
        <FhirBase>[],
      );
    });
  });

  group('testTruncate', () {
    test('testTruncate1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '101.truncate() = 101',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testTruncate2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1.00000001.truncate() = 1',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testTruncate3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(-1.56).truncate() = -1',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testPrecedence', () {
    // FIXED: <test name="testPrecedence1" name="testUnaryPrecedence"
    // inputfile="patient-example.xml">
    // <expression invalid="semantic">-1.convertsToInteger()</expression>
    // should error because unary does not work on boolean: -(1.convertsToInteger())
    // })
    test('testPrecedence1-fixed', () async {
      await expectLater(
        walkPath(
          context: patient1,
          pathExpression: '-1.convertsToInteger()',
        ),
        throwsA(isA<PathEngineException>()),
      );
    });

    test('testPrecedence2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1+2*3+4 = 11',
        ),
        [true.toFhirBoolean],
      );
    });

    // FIXED: Incorrect test case. 'is' has higher precedence than >
    // test("testPrecedence3", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1, pathExpression: r"1 > 2 is Boolean"),
    //       [true]);
    // });
    test('testPrecedence3-fixed', () async {
      await expectLater(
        walkPath(
          context: patient1,
          pathExpression: '1 > 2 is Boolean',
        ),
        throwsA(isA<PathEngineException>()),
      );
    });

    // FIXED: Incorrect test case. 'is' has higher precedence than |
    // test("testPrecedence4", () async {
    //   expect(
    //       await walkPath(
    //           context: patient1, pathExpression: r"1 | 1 is Integer"),
    //       [true]);
    // });
    test('testPrecedence4-fixeda', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '1 | 1 is Integer',
        ),
        [1.toFhirInteger, true.toFhirBoolean],
      );
    });
    test('testPrecedence4-fixedb', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(1 | 1) is Integer',
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testVariables', () {
    test('testVariables1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "%sct = 'http://snomed.info/sct'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testVariables2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "%loinc = 'http://loinc.org'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testVariables3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "%ucum = 'http://unitsofmeasure.org'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testVariables4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression:
              "%`vs-administrative-gender` = 'http://hl7.org/fhir/ValueSet/administrative-gender'",
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testExtension', () {
    test('testExtension1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression:
              "Patient.birthDate.extension('http://hl7.org/fhir/StructureDefinition/patient-birthTime').exists()",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testExtension2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression:
              'Patient.birthDate.extension(%`ext-patient-birthTime`).exists()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testExtension3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression:
              "Patient.birthDate.extension('http://hl7.org/fhir/StructureDefinition/patient-birthTime1').empty()",
        ),
        [true.toFhirBoolean],
      );
    });
  });

  group('testType', () {
    test('testType1', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "1.type().namespace = 'System'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testType2', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "1.type().name = 'Integer'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testType3', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "true.type().namespace = 'System'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testType4', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "true.type().name = 'Boolean'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testType5', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'true is Boolean',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testType6', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'true is System.Boolean',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testType7', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'true is Boolean',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testType8', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'true is System.Boolean',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testType9', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "Patient.active.type().namespace = 'FHIR'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testType10', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "Patient.active.type().name = 'boolean'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testType11', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.active is boolean',
        ),
        [true.toFhirBoolean],
      );
    });

    // Official testType12: Patient.active.is(Boolean).not() => true — a bare
    // `Boolean` resolves to System.Boolean, and a FHIR boolean is not a
    // System value, so `is(Boolean)` is FALSE and the .not() is TRUE. (An
    // earlier revision used the grammatically-invalid operator form
    // `x is Boolean.not()` and expected [false], which encoded a
    // case-insensitive-matching bug in the old `is` operator, not the spec.)
    test('testType12', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.active.is(Boolean).not()',
        ),
        [true.toFhirBoolean],
      );
    });
    // Operator-form equivalent of testType12 (`x is T` ≡ `x.is(T)`,
    // FHIRPath spec §6.3), parenthesised so .not() applies to the result.
    test('testType12-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(Patient.active is Boolean).not()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testType13', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.active is FHIR.boolean',
        ),
        [true.toFhirBoolean],
      );
    });

    // Official testType14: Patient.active.is(System.Boolean).not() => true
    // (a FHIR boolean is not a System value).
    test('testType14', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.active.is(System.Boolean).not()',
        ),
        [true.toFhirBoolean],
      );
    });
    // Operator-form equivalent, parenthesised so .not() applies to the
    // result.
    test('testType14-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(Patient.active is System.Boolean).not()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testType15', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "Patient.type().namespace = 'FHIR'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testType16', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: "Patient.type().name = 'Patient'",
        ),
        [true.toFhirBoolean],
      );
    });

    test('testType17', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient is Patient',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testType18', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient is FHIR.Patient',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testType19', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient is FHIR.`Patient`',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testType20', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.ofType(Patient).type().name',
        ),
        ['Patient'.toFhirString],
      );
    });

    test('testType21', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.ofType(FHIR.Patient).type().name',
        ),
        ['Patient'.toFhirString],
      );
    });

    // Official testType22: Patient.is(System.Patient).not() => true (a
    // Resource is never a System value). Parenthesised for the operator form.
    test('testType22-fixed', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: '(Patient is System.Patient).not()',
        ),
        [true.toFhirBoolean],
      );
    });

    test('testType23', () async {
      expect(
        await walkPath(
          context: patient1,
          pathExpression: 'Patient.ofType(FHIR.`Patient`).type().name',
        ),
        ['Patient'.toFhirString],
      );
    });
  });

  // TODO(Dokotela): conforms to
  group('testConformsTo', () {
    // test('testConformsTo', () async {
    //   expect(
    //     await walkPath(
    //       context: patient1,
    //       pathExpression:
    //           "conformsTo('http://hl7.org/fhir/StructureDefinition/Patient')",
    //     ),
    //     [true.toFhirBoolean],
    //   );
    // });
    // test('testConformsTo', () async {
    //   expect(
    //     await walkPath(
    //       context: patient1,
    //       pathExpression:
    //           "conformsTo('http://hl7.org/fhir/StructureDefinition/Person')",
    //     ),
    //     [false.toFhirBoolean],
    //   );
    // });
    test('testConformsTo', () async {
      expect(
        () => walkPath(
          context: patient1,
          pathExpression: "conformsTo('http://trash')",
        ),
        throwsA(const TypeMatcher<PathEngineException>()),
      );
    });
  });
}

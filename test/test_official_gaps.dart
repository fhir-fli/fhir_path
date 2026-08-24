// GENERATED port of official FHIRPath tests (fhir-test-cases
// r4/fhirpath/tests-fhir-r4.xml) that were missing from the suite.
// Expressions and expectations are verbatim from the official XML
// (date/dateTime/time outputs stripped of their FHIRPath literal @-prefix;
// quantity outputs asserted via `= <quantity literal>`); deviations are
// commented per-test. Invalid-marked tests assert a throw; strict-mode /
// static-semantic-check tests and tests blocked on documented engine
// limitations are omitted with a rationale comment.
// ignore_for_file: lines_longer_than_80_chars

import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_r4_path/fhir_r4_path.dart';
import 'package:test/test.dart';

import 'test_data.dart';

Future<void> testOfficialGaps() async {
  final engine = await FHIRPathEngine.create(WorkerContext());

  Future<List<String?>> eval(FhirBase context, String expr) async {
    final node = engine.parse(expr);
    final result = await engine.evaluate(context, node);
    return result
        .map((e) => e.isPrimitive ? e.primitiveValue : e.toString())
        .toList();
  }

  group('official-comments', () {
    test('testComment2', () async {
      expect(
        await eval(
          patient1,
          '// This is a multi line comment using // that\n  // should not fail during parsing\n  2+2',
        ),
        ['4'],
      );
    });

    test('testComment3', () async {
      expect(
        await eval(
          patient1,
          '2 + 2 \n      /*\nThis is a multi-line comment\nAny text enclosed within is ignored\n+2\n*/',
        ),
        ['4'],
      );
    });

    test('testComment4', () async {
      expect(
        await eval(
          patient1,
          '2 + 2 \n      /*\nThis is a multi-line comment\nAny text enclosed within is ignored\n*/\n+2',
        ),
        ['6'],
      );
    });

    test('testComment5', () async {
      expect(
        await eval(
          patient1,
          '/*\nThis is a multi-line comment\nAny text enclosed within is ignored\n*/\n2+2',
        ),
        ['4'],
      );
    });

    // testComment6: BLOCKED on arbitrary-precision decimal arithmetic: 2/2 must render
    // as the decimal '1' (Java BigDecimal), but our double-backed decimal
    // arithmetic renders '1.0'. Tracked with the deferred decimal-precision
    // workstream.
    // expression: 2 // comment <newline> / 2

    // Official: invalid="syntax" — must error.
    test('testComment7', () async {
      expect(
        () async => eval(patient1, '2 + 2 /'),
        throwsA(anything),
      );
    });

    // Official: invalid="syntax" — must error.
    test('testComment8', () async {
      expect(
        () async => eval(patient1, '2 + 2 /* not finished'),
        throwsA(anything),
      );
    });

    test('testComment9', () async {
      expect(
        await eval(patient1, r'2 + /* inline $@%^+ * */ 2 = 4'),
        ['true'],
      );
    });
  });

  group('official-testBasics', () {
    // testSimpleFail: official expects an error from strict mode
    // (invalid=semantic); our engine evaluates leniently, so
    // there is no error to assert.
    // expression: name.given1

    // testSimpleWithWrongContext: official expects an error from strict mode
    // (invalid=semantic); our engine evaluates leniently, so
    // there is no error to assert.
    // expression: Encounter.name.given
  });

  group('official-testObservations', () {
    // testPolymorphismB: official expects an error from strict mode
    // (invalid=semantic); our engine evaluates leniently, so
    // there is no error to assert.
    // expression: Observation.valueQuantity.unit

    test('testPolymorphismIsA1', () async {
      expect(
        await eval(observation1, 'Observation.value.is(Quantity)'),
        ['true'],
      );
    });

    test('testPolymorphismIsA2', () async {
      expect(
        await eval(observation1, 'Observation.value is Quantity'),
        ['true'],
      );
    });

    test('testPolymorphismIsA3', () async {
      expect(
        await eval(observation1, 'Observation.issued is instant'),
        <String?>[],
      );
    });
  });

  group('official-testDollar', () {
    // testDollarOrderNotAllowed: official expects an error from strict mode
    // (invalid=semantic); our engine evaluates leniently, so
    // there is no error to assert.
    // expression: Patient.children().skip(1)
  });

  group('official-testLiterals', () {
    test('testLiteralString1', () async {
      expect(
        await eval(patient1, "Patient.name.given.first() = 'Peter'"),
        ['true'],
      );
    });

    test('testLiteralString2', () async {
      expect(
        await eval(patient1, "'test'.convertsToString()"),
        ['true'],
      );
    });

    // Official: invalid="execution" — must error.
    test('testLiteralTimeUTC', () async {
      expect(
        () async => eval(patient1, '@T14:34:28Z.is(Time)'),
        throwsA(anything),
      );
    });

    // Official: invalid="execution" — must error.
    test('testLiteralDecimalLessThanInvalid', () async {
      expect(
        () async => eval(observation1, "Observation.value.value < 'test'"),
        throwsA(anything),
      );
    });

    test('testDateTimeGreaterThanDate1', () async {
      expect(
        await eval(patient1, 'now() > Patient.birthDate'),
        ['true'],
      );
    });

    test('testDateGreaterThanDate', () async {
      expect(
        await eval(patient1, 'today() > Patient.birthDate'),
        ['true'],
      );
    });

    // testDateTimeGreaterThanDate2 (now() > today() => empty) is
    // time-of-day dependent: the comparison timezone-normalises now() (the
    // Java reference does the same via setTimeZoneZulu), so near the local
    // day boundary the normalised date differs from today() and the result
    // becomes true/false instead of empty. Deterministic only when the
    // normalised date matches the local date, so it cannot be asserted
    // reliably.
    // expression: now() > today()

    test('testLiteralNotOnEmpty', () async {
      expect(
        await eval(patient1, '{}.not().empty()'),
        ['true'],
      );
    });
  });

  group('official-testTypes', () {
    test('testIntegerLiteralIsSystemInteger', () async {
      expect(
        await eval(patient1, '1.is(System.Integer)'),
        ['true'],
      );
    });

    test('testIntegerLiteralToDeciamlEquivalent', () async {
      expect(
        await eval(patient1, '1.toDecimal() ~ 1.0'),
        ['true'],
      );
    });

    test('testIntegerLiteralIsNotQuantity', () async {
      expect(
        await eval(patient1, '1.is(Quantity).not()'),
        ['true'],
      );
    });

    test('testStringIntegerLiteralIsNotQuantity', () async {
      expect(
        await eval(patient1, "'1'.is(System.Quantity).not()"),
        ['true'],
      );
    });

    test('testStringDecimalLiteralIsNotSystemQuantity', () async {
      expect(
        await eval(patient1, "'1.0'.is(System.Quantity).not()"),
        ['true'],
      );
    });

    test('testBooleanLiteralIsNotSystemQuantity', () async {
      expect(
        await eval(patient1, 'true.is(System.Quantity).not()'),
        ['true'],
      );
    });

    // Official output is the quantity 1 '1'; asserted via = literal.
    test('testStringIntegerLiteralToQuantity', () async {
      expect(
        await eval(patient1, "('1'.toQuantity()) = 1 '1'"),
        ['true'],
      );
    });

    test('testStringQuantityMonthLiteralToQuantity', () async {
      expect(
        await eval(patient1, r"'1 \'mo\''.toQuantity() = 1 month"),
        <String?>[],
      );
    });

    test('testStringQuantityYearLiteralToQuantity', () async {
      expect(
        await eval(patient1, r"'1 \'a\''.toQuantity() = 1 year"),
        <String?>[],
      );
    });

    test('testIntegerLiteralToBooleanEmpty', () async {
      expect(
        await eval(patient1, '2.toBoolean()'),
        <String?>[],
      );
    });
  });

  group('official-testExists', () {
    test('testExists2', () async {
      expect(
        await eval(patient1, "Patient.name.exists(use = 'nickname')"),
        ['false'],
      );
    });

    test('testExists3', () async {
      expect(
        await eval(patient1, "Patient.name.exists(use = 'official')"),
        ['true'],
      );
    });

    test('testExists4', () async {
      expect(
        await eval(
          patient1,
          "Patient.maritalStatus.coding.exists(code = 'P' and system = 'http://terminology.hl7.org/CodeSystem/v3-MaritalStatus')\n\t\t\tor Patient.maritalStatus.coding.exists(code = 'A' and system = 'http://terminology.hl7.org/CodeSystem/v3-MaritalStatus')",
        ),
        ['false'],
      );
    });

    test('testExists5', () async {
      expect(
        await eval(patient1, '(1 | 2).exists()'),
        ['true'],
      );
    });
  });

  group('official-testSelect', () {
    test('testSelect3', () async {
      expect(
        await eval(patient1, "name.select(use.contains('i')).count()"),
        ['3'],
      );
    });
  });

  group('official-testRepeat', () {
    test('testRepeat5', () async {
      expect(
        await eval(patient1, "Patient.name.repeat('test')"),
        ['test'],
      );
    });
  });

  group('official-testSingle', () {
    // Official: invalid="execution" — must error.
    test('testSingle2', () async {
      expect(
        () async => eval(patient1, 'Patient.name.single().exists()'),
        throwsA(anything),
      );
    });
  });

  group('official-testIif', () {
    test('testIif5', () async {
      expect(
        await eval(patient1, "iif(false, 'true-result').empty()"),
        ['true'],
      );
    });

    // testIif6: official expects an error from strict mode
    // (invalid=semantic); our engine evaluates leniently, so
    // there is no error to assert.
    // expression: iif('non boolean criteria', 'true-result', 'true-result')

    test('testIif7', () async {
      expect(
        await eval(patient1, "{}.iif(true, 'true-result', 'false-result')"),
        ['true-result'],
      );
    });

    test('testIif8', () async {
      expect(
        await eval(
          patient1,
          "('item').iif(true, 'true-result', 'false-result')",
        ),
        ['true-result'],
      );
    });

    test('testIif9', () async {
      expect(
        await eval(
          patient1,
          r"('context').iif(true, select($this), 'false-result')",
        ),
        ['context'],
      );
    });

    // Official: invalid="execution" — must error.
    test('testIif10', () async {
      expect(
        () async => eval(
          patient1,
          "('item1' | 'item2').iif(true, 'true-result', 'false-result')",
        ),
        throwsA(anything),
      );
    });

    test('testIif11', () async {
      expect(
        await eval(
          patient1,
          r"('context').iif($this = 'context','true-result', 'false-result')",
        ),
        ['true-result'],
      );
    });
  });

  group('official-testIndexOf', () {
    test('testIndexOf2', () async {
      expect(
        await eval(patient1, "'LogicalModel-Person'.indexOf('z')"),
        ['-1'],
      );
    });

    test('testIndexOf3', () async {
      expect(
        await eval(patient1, "'LogicalModel-Person'.indexOf('')"),
        ['0'],
      );
    });

    test('testIndexOf5', () async {
      expect(
        await eval(
          patient1,
          "'LogicalModel-Person'.indexOf({}).empty() = true",
        ),
        ['true'],
      );
    });

    test('testIndexOf4', () async {
      expect(
        await eval(patient1, "{}.indexOf('-').empty() = true"),
        ['true'],
      );
    });

    test('testIndexOf6', () async {
      expect(
        await eval(patient1, '{}.indexOf({}).empty() = true'),
        ['true'],
      );
    });
  });

  group('official-testSubstring', () {
    test('testSubstring7', () async {
      expect(
        await eval(patient1, "'LogicalModel-Person'.substring(0, 12)"),
        ['LogicalModel'],
      );
    });

    test('testSubstring8', () async {
      expect(
        await eval(
          patient1,
          "'LogicalModel-Person'.substring(0, 'LogicalModel-Person'.indexOf('-'))",
        ),
        ['LogicalModel'],
      );
    });

    test('testSubstring9', () async {
      expect(
        await eval(patient1, '{}.substring(25).empty() = true'),
        ['true'],
      );
    });
  });

  group('official-testStartsWith', () {
    test('testStartsWith8', () async {
      expect(
        await eval(patient1, "{}.startsWith('1').empty() = true"),
        ['true'],
      );
    });

    test('testStartsWith9', () async {
      expect(
        await eval(patient1, "{}.startsWith('').empty() = true"),
        ['true'],
      );
    });

    test('testStartsWith10', () async {
      expect(
        await eval(patient1, "''.startsWith('') = true"),
        ['true'],
      );
    });

    test('testStartsWith11', () async {
      expect(
        await eval(patient1, "{}.startsWith('').exists() = false"),
        ['true'],
      );
    });
  });

  group('official-testEndsWith', () {
    test('testEndsWith8', () async {
      expect(
        await eval(patient1, "{}.endsWith('1').empty() = true"),
        ['true'],
      );
    });

    test('testEndsWith9', () async {
      expect(
        await eval(patient1, "{}.endsWith('').empty() = true"),
        ['true'],
      );
    });
  });

  group('official-testContainsString', () {
    test('testContainsString8', () async {
      expect(
        await eval(patient1, "{}.contains('a').empty() = true"),
        ['true'],
      );
    });

    test('testContainsString9', () async {
      expect(
        await eval(patient1, "{}.contains('').empty() = true"),
        ['true'],
      );
    });
  });

  group('official-testMatches', () {
    test('testMatchesCaseSensitive2', () async {
      expect(
        await eval(patient1, "'FHIR'.matches('fhir')"),
        ['false'],
      );
    });

    test('testMatchesEmpty', () async {
      expect(
        await eval(patient1, "'FHIR'.matches({}).empty() = true"),
        ['true'],
      );
    });

    test('testMatchesEmpty2', () async {
      expect(
        await eval(patient1, "{}.matches('FHIR').empty() = true"),
        ['true'],
      );
    });

    test('testMatchesEmpty3', () async {
      expect(
        await eval(patient1, '{}.matches({}).empty() = true'),
        ['true'],
      );
    });

    test('testMatchesSingleLineMode1', () async {
      expect(
        await eval(patient1, "'A\n\t\t\tB'.matches('A.*B')"),
        ['true'],
      );
    });

    test('testMatchesWithinUrl1', () async {
      expect(
        await eval(
          patient1,
          "'http://fhir.org/guides/cqf/common/Library/FHIR-ModelInfo|4.0.1'.matches('library')",
        ),
        ['false'],
      );
    });

    test('testMatchesWithinUrl2', () async {
      expect(
        await eval(
          patient1,
          "'http://fhir.org/guides/cqf/common/Library/FHIR-ModelInfo|4.0.1'.matches('Library')",
        ),
        ['true'],
      );
    });

    test('testMatchesWithinUrl3', () async {
      expect(
        await eval(
          patient1,
          r"'http://fhir.org/guides/cqf/common/Library/FHIR-ModelInfo|4.0.1'.matches('^Library$')",
        ),
        ['false'],
      );
    });

    test('testMatchesWithinUrl1a', () async {
      expect(
        await eval(
          patient1,
          "'http://fhir.org/guides/cqf/common/Library/FHIR-ModelInfo|4.0.1'.matches('.*Library.*')",
        ),
        ['true'],
      );
    });

    test('testMatchesWithinUrl4', () async {
      expect(
        await eval(
          patient1,
          "'http://fhir.org/guides/cqf/common/Library/FHIR-ModelInfo|4.0.1'.matches('Measure')",
        ),
        ['false'],
      );
    });

    test('testMatchesFullWithinUrl1', () async {
      expect(
        await eval(
          patient1,
          "'http://fhir.org/guides/cqf/common/Library/FHIR-ModelInfo|4.0.1'.matchesFull('library')",
        ),
        ['false'],
      );
    });

    test('testMatchesFullWithinUrl3', () async {
      expect(
        await eval(
          patient1,
          "'http://fhir.org/guides/cqf/common/Library/FHIR-ModelInfo|4.0.1'.matchesFull('Library')",
        ),
        ['false'],
      );
    });

    test('testMatchesFullWithinUrl4', () async {
      expect(
        await eval(
          patient1,
          r"'http://fhir.org/guides/cqf/common/Library/FHIR-ModelInfo|4.0.1'.matchesFull('^Library$')",
        ),
        ['false'],
      );
    });

    test('testMatchesFullWithinUrl1a', () async {
      expect(
        await eval(
          patient1,
          "'http://fhir.org/guides/cqf/common/Library/FHIR-ModelInfo|4.0.1'.matchesFull('.*Library.*')",
        ),
        ['true'],
      );
    });

    test('testMatchesFullWithinUrl2', () async {
      expect(
        await eval(
          patient1,
          "'http://fhir.org/guides/cqf/common/Library/FHIR-ModelInfo|4.0.1'.matchesFull('Measure')",
        ),
        ['false'],
      );
    });

    test('testMatchesUnicodeCharacters', () async {
      expect(
        await eval(patient1, "'🔥🔥🔥'.matches('🔥+')"),
        ['true'],
      );
    });
  });

  group('official-testReplaceMatches', () {
    test('testReplaceMatches2', () async {
      expect(
        await eval(patient1, "'abc'.replaceMatches('', 'x')"),
        ['abc'],
      );
    });

    test('testReplaceMatches3', () async {
      expect(
        await eval(patient1, "'123456'.replaceMatches('234', '')"),
        ['156'],
      );
    });

    test('testReplaceMatches4', () async {
      expect(
        await eval(patient1, "{}.replaceMatches('234', 'X').empty() = true"),
        ['true'],
      );
    });

    test('testReplaceMatches5', () async {
      expect(
        await eval(patient1, "'123'.replaceMatches({}, 'X').empty() = true"),
        ['true'],
      );
    });

    test('testReplaceMatches6', () async {
      expect(
        await eval(patient1, "'123'.replaceMatches('2', {}).empty() = true"),
        ['true'],
      );
    });

    test('testReplaceMatches7', () async {
      expect(
        await eval(patient1, "'abc123'.replaceMatches('[0-9]', '-')"),
        ['abc---'],
      );
    });
  });

  group('official-testReplace', () {
    test('testReplace2', () async {
      expect(
        await eval(patient1, "'abc'.replace('', 'x')"),
        ['xaxbxcx'],
      );
    });

    test('testReplace3', () async {
      expect(
        await eval(patient1, "'123456'.replace('234', '')"),
        ['156'],
      );
    });

    test('testReplace4', () async {
      expect(
        await eval(patient1, "{}.replace('234', 'X').empty() = true"),
        ['true'],
      );
    });

    test('testReplace5', () async {
      expect(
        await eval(patient1, "'123'.replace({}, 'X').empty() = true"),
        ['true'],
      );
    });

    test('testReplace6', () async {
      expect(
        await eval(patient1, "'123'.replace('2', {}).empty() = true"),
        ['true'],
      );
    });
  });

  group('official-testLength', () {
    test('testLength6', () async {
      expect(
        await eval(patient1, '{}.length().empty() = true'),
        ['true'],
      );
    });
  });

  group('official-testEncodeDecode', () {
    test('testEncodeHex', () async {
      expect(
        await eval(patient1, "'test'.encode('hex')"),
        ['74657374'],
      );
    });

    test('testEncodeBase64B', () async {
      expect(
        await eval(patient1, "'subjects?_d'.encode('base64')"),
        ['c3ViamVjdHM/X2Q='],
      );
    });

    test('testEncodeUrlBase64', () async {
      expect(
        await eval(patient1, "'subjects?_d'.encode('urlbase64')"),
        ['c3ViamVjdHM_X2Q='],
      );
    });

    test('testDecodeBase64A', () async {
      expect(
        await eval(patient1, "'dGVzdA=='.decode('base64')"),
        ['test'],
      );
    });

    test('testDecodeHex', () async {
      expect(
        await eval(patient1, "'74657374'.decode('hex')"),
        ['test'],
      );
    });

    test('testDecodeBase64B', () async {
      expect(
        await eval(patient1, "'c3ViamVjdHM/X2Q='.decode('base64')"),
        ['subjects?_d'],
      );
    });

    test('testDecodeUrlBase64', () async {
      expect(
        await eval(patient1, "'c3ViamVjdHM_X2Q='.decode('urlbase64')"),
        ['subjects?_d'],
      );
    });
  });

  group('official-testEscapeUnescape', () {
    test('testEscapeJson', () async {
      expect(
        await eval(patient1, "'\"1<2\"'.escape('json')"),
        [r'\"1<2\"'],
      );
    });

    test('testUnescapeHtml', () async {
      expect(
        await eval(patient1, "'&quot;1&lt;2&quot;'.unescape('html')"),
        ['"1<2"'],
      );
    });

    test('testUnescapeJson', () async {
      expect(
        await eval(patient1, "'\\\"1<2\\\"'.unescape('json')"),
        ['"1<2"'],
      );
    });
  });

  group('official-testTrim', () {
    test('testTrim2', () async {
      expect(
        await eval(patient1, "'123 456'.trim().length() = 7"),
        ['true'],
      );
    });

    test('testTrim3', () async {
      expect(
        await eval(patient1, "' 123456 '.trim().length() = 6"),
        ['true'],
      );
    });

    test('testTrim4', () async {
      expect(
        await eval(patient1, "'  '.trim().length() = 0"),
        ['true'],
      );
    });

    test('testTrim5', () async {
      expect(
        await eval(patient1, '{}.trim().empty() = true'),
        ['true'],
      );
    });

    test('testTrim6', () async {
      expect(
        await eval(patient1, "'      '.trim() = ''"),
        ['true'],
      );
    });
  });

  group('official-testSplit', () {
    test('testSplit2', () async {
      expect(
        await eval(patient1, "'A,,C'.split(',').join(',') = 'A,,C'"),
        ['true'],
      );
    });

    test('testSplit3', () async {
      expect(
        await eval(
          patient1,
          "'[stop]ONE[stop][stop]TWO[stop][stop][stop]THREE[stop][stop]'.split('[stop]').trace('n').count() = 9",
        ),
        ['true'],
      );
    });

    test('testSplit4', () async {
      expect(
        await eval(
          patient1,
          "'[stop]ONE[stop][stop]TWO[stop][stop][stop]THREE[stop][stop]'.split('[stop]').join('[stop]')",
        ),
        ['[stop]ONE[stop][stop]TWO[stop][stop][stop]THREE[stop][stop]'],
      );
    });
  });

  group('official-testSort', () {
    test('testSort2', () async {
      expect(
        await eval(patient1, '(3 | 2 | 1).sort() = (1 | 2 | 3)'),
        ['true'],
      );
    });

    test('testSort3', () async {
      expect(
        await eval(patient1, r'(1 | 2 | 3).sort($this) = (1 | 2 | 3)'),
        ['true'],
      );
    });

    test('testSort4', () async {
      expect(
        await eval(patient1, r'(3 | 2 | 1).sort($this) = (1 | 2 | 3)'),
        ['true'],
      );
    });

    test('testSort5', () async {
      expect(
        await eval(patient1, r'(1 | 2 | 3).sort(-$this) = (3 | 2 | 1)'),
        ['true'],
      );
    });

    test('testSort6', () async {
      expect(
        await eval(
          patient1,
          r"('a' | 'b' | 'c').sort($this) = ('a' | 'b' | 'c')",
        ),
        ['true'],
      );
    });

    test('testSort7', () async {
      expect(
        await eval(
          patient1,
          r"('c' | 'b' | 'a').sort($this) = ('a' | 'b' | 'c')",
        ),
        ['true'],
      );
    });

    test('testSort8', () async {
      expect(
        await eval(
          patient1,
          r"('a' | 'b' | 'c').sort(-$this) = ('c' | 'b' | 'a')",
        ),
        ['true'],
      );
    });

    test('testSort9', () async {
      expect(
        await eval(
          patient1,
          "Patient.name[0].given.sort() = ('James' | 'Peter')",
        ),
        ['true'],
      );
    });

    test('testSort10', () async {
      expect(
        await eval(
          patient1,
          "Patient.name.sort(-family, -given.first()).first().use = 'usual'",
        ),
        ['true'],
      );
    });
  });

  group('official-testEquality', () {
    test('testEquality27', () async {
      expect(
        await eval(
          patient1,
          'name.take(2) = name.take(2).last() | name.take(2).first()',
        ),
        ['false'],
      );
    });
  });

  group('official-testNEquality', () {
    test('testNEquality20', () async {
      expect(
        await eval(
          patient1,
          'name.take(2) != name.take(2).first() | name.take(2).last()',
        ),
        ['false'],
      );
    });

    test('testNEquality21', () async {
      expect(
        await eval(
          patient1,
          'name.take(2) != name.take(2).last() | name.take(2).first()',
        ),
        ['true'],
      );
    });
  });

  group('official-testEquivalent', () {
    test('testEquivalent23', () async {
      expect(
        await eval(observation1, '(1 | 2 | 3) ~ (1 | 2 | 3)'),
        ['true'],
      );
    });

    test('testEquivalent23', () async {
      expect(
        await eval(observation1, '(1 | 2 | 3) ~ (3 | 2 | 1)'),
        ['true'],
      );
    });
  });

  group('official-testNotEquivalent', () {
    test('testNotEquivalent20', () async {
      expect(
        await eval(
          patient1,
          'name.take(2).given !~ name.take(2).first().given | name.take(2).last().given',
        ),
        ['false'],
      );
    });

    test('testNotEquivalent21', () async {
      expect(
        await eval(
          patient1,
          'name.take(2).given !~ name.take(2).last().given | name.take(2).first().given',
        ),
        ['false'],
      );
    });
  });

  group('official-testCombine()', () {
    test('testCombine2', () async {
      expect(
        await eval(patient1, "name.given.combine(name.family).exclude('Jim')"),
        ['Peter', 'James', 'Peter', 'James', 'Chalmers', 'Windsor'],
      );
    });

    test('testCombine3', () async {
      expect(
        await eval(
          patient1,
          r"name.given.combine($this.name.family).exclude('Jim')",
        ),
        ['Peter', 'James', 'Peter', 'James', 'Chalmers', 'Windsor'],
      );
    });
  });

  group('official-testUnion', () {
    test('testUnion9', () async {
      expect(
        await eval(patient1, 'name.select(use | given).count()'),
        ['8'],
      );
    });

    test('testUnion10', () async {
      expect(
        await eval(patient1, r'name.select(use.union($this.given)).count()'),
        ['8'],
      );
    });

    test('testUnion11', () async {
      expect(
        await eval(patient1, 'name.select(use.union(given)).count()'),
        ['8'],
      );
    });
  });

  group('official-testPlus', () {
    test('testPlusDate1', () async {
      expect(
        await eval(patient1, '@1973-12-25 + 7 days'),
        ['1974-01-01'],
      );
    });

    test('testPlusDate2', () async {
      expect(
        await eval(patient1, '@1973-12-25 + 7.7 days'),
        ['1974-01-01'],
      );
    });

    test('testPlusDate3', () async {
      expect(
        await eval(patient1, '@1973-12-25T00:00:00.000+10:00 + 7 days'),
        ['1974-01-01T00:00:00.000+10:00'],
      );
    });

    test('testPlusDate4', () async {
      expect(
        await eval(patient1, '@1973-12-25T00:00:00.000+10:00 + 7.7 days'),
        ['1974-01-01T00:00:00.000+10:00'],
      );
    });

    test('testPlusDate5', () async {
      expect(
        await eval(patient1, '@1973-12-25T00:00:00.000+10:00 + 1 second'),
        ['1973-12-25T00:00:01.000+10:00'],
      );
    });

    test('testPlusDate6', () async {
      expect(
        await eval(patient1, '@1973-12-25T00:00:00.000+10:00 + 10 millisecond'),
        ['1973-12-25T00:00:00.010+10:00'],
      );
    });

    test('testPlusDate7', () async {
      expect(
        await eval(patient1, '@1973-12-25T00:00:00.000+10:00 + 1 minute'),
        ['1973-12-25T00:01:00.000+10:00'],
      );
    });

    test('testPlusDate8', () async {
      expect(
        await eval(patient1, '@1973-12-25T00:00:00.000+10:00 + 1 hour'),
        ['1973-12-25T01:00:00.000+10:00'],
      );
    });

    test('testPlusDate9', () async {
      expect(
        await eval(patient1, '@1973-12-25 + 1 day'),
        ['1973-12-26'],
      );
    });

    test('testPlusDate10', () async {
      expect(
        await eval(patient1, '@1973-12-25 + 1 month'),
        ['1974-01-25'],
      );
    });

    test('testPlusDate11', () async {
      expect(
        await eval(patient1, '@1973-12-25 + 1 week'),
        ['1974-01-01'],
      );
    });

    test('testPlusDate12', () async {
      expect(
        await eval(patient1, '@1973-12-25 + 1 year'),
        ['1974-12-25'],
      );
    });

    test('testPlusDate13', () async {
      expect(
        await eval(patient1, "@1973-12-25 + 1 'd'"),
        ['1973-12-26'],
      );
    });

    // Official: invalid="execution" — must error.
    test('testPlusDate14', () async {
      expect(
        () async => eval(patient1, "@1973-12-25 + 1 'mo'"),
        throwsA(anything),
      );
    });

    test('testPlusDate15', () async {
      expect(
        await eval(patient1, "@1973-12-25 + 1 'wk'"),
        ['1974-01-01'],
      );
    });

    // Official: invalid="execution" — must error.
    test('testPlusDate16', () async {
      expect(
        () async => eval(patient1, "@1973-12-25 + 1 'a'"),
        throwsA(anything),
      );
    });

    // Official: invalid="execution" — must error.
    test('testPlusDate17', () async {
      expect(
        () async => eval(patient1, "@1975-12-25 + 1 'a'"),
        throwsA(anything),
      );
    });

    test('testPlusDate18', () async {
      expect(
        await eval(patient1, "@1973-12-25T00:00:00.000+10:00 + 1 's'"),
        ['1973-12-25T00:00:01.000+10:00'],
      );
    });

    test('testPlusDate19', () async {
      expect(
        await eval(patient1, "@1973-12-25T00:00:00.000+10:00 + 0.1 's'"),
        ['1973-12-25T00:00:00.000+10:00'],
      );
    });

    test('testPlusDate20', () async {
      expect(
        await eval(patient1, "@1973-12-25T00:00:00.000+10:00 + 10 'ms'"),
        ['1973-12-25T00:00:00.010+10:00'],
      );
    });

    test('testPlusDate21', () async {
      expect(
        await eval(patient1, "@1973-12-25T00:00:00.000+10:00 + 1 'min'"),
        ['1973-12-25T00:01:00.000+10:00'],
      );
    });

    test('testPlusDate22', () async {
      expect(
        await eval(patient1, "@1973-12-25T00:00:00.000+10:00 + 1 'h'"),
        ['1973-12-25T01:00:00.000+10:00'],
      );
    });

    // testPlus6: official expects an error from a static semantic-check phase
    // (invalid=semantic); our engine evaluates leniently, so
    // there is no error to assert.
    // expression: @1974-12-25 + 7
  });

  group('official-testMinus', () {
    test('testMinus5', () async {
      expect(
        await eval(patient1, "@1974-12-25 - 1 'month'"),
        ['1974-11-25'],
      );
    });

    // Official: invalid="execution" — must error.
    test('testMinus6', () async {
      expect(
        () async => eval(patient1, "@1974-12-25 - 1 'cm'"),
        throwsA(anything),
      );
    });
  });

  group('official-testExp', () {
    test('testExp3', () async {
      expect(
        await eval(patient1, '{}.exp().empty() = true'),
        ['true'],
      );
    });
  });

  group('official-testPrecedence', () {
    test('testPrecedence4', () async {
      expect(
        await eval(patient1, '(1 | 1 is Integer).count()'),
        ['2'],
      );
    });

    test('testPrecedence5', () async {
      expect(
        await eval(patient1, "true and '0215' in ('0215' | '0216')"),
        ['true'],
      );
    });

    test('testPrecedence6', () async {
      expect(
        await eval(
          observation1,
          "category.exists(coding.exists(system = 'http://terminology.hl7.org/CodeSystem/observation-category' and code.trace('c') in ('vital-signs' | 'vital-signs2').trace('codes')))",
        ),
        ['true'],
      );
    });
  });

  group('official-testType', () {
    test('testType1a', () async {
      expect(
        await eval(patient1, "1.type().name = 'Integer'"),
        ['true'],
      );
    });

    test('testType2a', () async {
      expect(
        await eval(patient1, "'1'.type().name = 'String'"),
        ['true'],
      );
    });
  });

  group('official-testConformsTo', () {
    // Official testConformsTo2 needs conformsToProfile host services; without
    // them the engine throws (same convention as the main suite's
    // testConformsTo).
    test('testConformsTo2-no-host-services', () async {
      expect(
        () => eval(
          patient1,
          "conformsTo('http://hl7.org/fhir/StructureDefinition/Person')",
        ),
        throwsA(isA<PathEngineException>()),
      );
    });

    // Official testConformsTo3 needs conformsToProfile host services; without
    // them the engine throws (same convention as the main suite's
    // testConformsTo).
    test('testConformsTo3-no-host-services', () async {
      expect(
        () => eval(patient1, "conformsTo('http://trash')"),
        throwsA(isA<PathEngineException>()),
      );
    });
  });

  group('official-LowBoundary', () {
    test('LowBoundaryDecimal1', () async {
      expect(
        await eval(patient1, '1.587.lowBoundary(6)'),
        ['1.586500'],
      );
    });

    test('LowBoundaryDecimal2', () async {
      expect(
        await eval(patient1, '1.587.lowBoundary(2)'),
        ['1.58'],
      );
    });

    test('LowBoundaryDecimal3', () async {
      expect(
        await eval(patient1, '1.587.lowBoundary(-1)'),
        <String?>[],
      );
    });

    test('LowBoundaryDecimal4', () async {
      expect(
        await eval(patient1, '1.587.lowBoundary(0)'),
        ['1'],
      );
    });

    test('LowBoundaryDecimal5', () async {
      expect(
        await eval(patient1, '1.587.lowBoundary(32)'),
        <String?>[],
      );
    });

    test('LowBoundaryNegDecimalDefault', () async {
      expect(
        await eval(patient1, '(-1.587).lowBoundary()'),
        ['-1.58750000'],
      );
    });

    test('LowBoundaryNegDecimal1', () async {
      expect(
        await eval(patient1, '(-1.587).lowBoundary(6)'),
        ['-1.587500'],
      );
    });

    test('LowBoundaryNegDecimal2', () async {
      expect(
        await eval(patient1, '(-1.587).lowBoundary(2)'),
        ['-1.59'],
      );
    });

    test('LowBoundaryNegDecimal3', () async {
      expect(
        await eval(patient1, '(-1.587).lowBoundary(-1)'),
        <String?>[],
      );
    });

    test('LowBoundaryNegDecimal4', () async {
      expect(
        await eval(patient1, '(-1.587).lowBoundary(0)'),
        ['-2'],
      );
    });

    test('LowBoundaryNegDecimal5', () async {
      expect(
        await eval(patient1, '(-1.587).lowBoundary(32)'),
        <String?>[],
      );
    });

    test('LowBoundaryDecimal6', () async {
      expect(
        await eval(patient1, '1.587.lowBoundary(39)'),
        <String?>[],
      );
    });

    test('LowBoundaryDecimal7', () async {
      expect(
        await eval(patient1, '1.toDecimal().lowBoundary()'),
        ['0.50000000'],
      );
    });

    test('LowBoundaryDecimal8', () async {
      expect(
        await eval(patient1, '1.lowBoundary(0)'),
        ['0'],
      );
    });

    test('LowBoundaryDecimal9', () async {
      expect(
        await eval(patient1, '1.lowBoundary(5)'),
        ['0.50000'],
      );
    });

    test('LowBoundaryDecimal10', () async {
      expect(
        await eval(patient1, '12.587.lowBoundary(2)'),
        ['12.58'],
      );
    });

    test('LowBoundaryDecimal11', () async {
      expect(
        await eval(patient1, '12.500.lowBoundary(4)'),
        ['12.4995'],
      );
    });

    test('LowBoundaryDecimal12', () async {
      expect(
        await eval(patient1, '120.lowBoundary(2)'),
        ['119.50'],
      );
    });

    test('LowBoundaryDecimal13', () async {
      expect(
        await eval(patient1, '(-120).lowBoundary(2)'),
        ['-120.50'],
      );
    });

    test('LowBoundaryDecimal14', () async {
      expect(
        await eval(patient1, '0.0034.lowBoundary(1)'),
        ['0.0'],
      );
    });

    test('LowBoundaryDecimal15', () async {
      expect(
        await eval(patient1, '(-0.0034).lowBoundary(1)'),
        ['-0.0'],
      );
    });

    // Official output is the quantity 1.58650000 'cm'; asserted via = literal.
    test('LowBoundaryQuantity', () async {
      expect(
        await eval(patient1, "(1.587 'cm'.lowBoundary(8)) = 1.58650000 'cm'"),
        ['true'],
      );
    });

    test('LowBoundaryDateMonth', () async {
      expect(
        await eval(patient1, '@2014.lowBoundary(6)'),
        ['2014-01'],
      );
    });

    test('LowBoundaryDateTimeMillisecond1', () async {
      expect(
        await eval(patient1, '@2014-01-01T08.lowBoundary(17)'),
        ['2014-01-01T08:00:00.000+14:00'],
      );
    });

    test('LowBoundaryDateTimeMillisecond2', () async {
      expect(
        await eval(patient1, '@2014-01-01T08:05+08:00.lowBoundary(17)'),
        ['2014-01-01T08:05:00.000+08:00'],
      );
    });

    test('LowBoundaryDateTimeMillisecond3', () async {
      expect(
        await eval(patient1, '@2014-01-01T08.lowBoundary(8)'),
        ['2014-01-01'],
      );
    });

    test('LowBoundaryTimeMillisecond', () async {
      expect(
        await eval(patient1, '@T10:30.lowBoundary(9)'),
        ['10:30:00.000'],
      );
    });
  });

  group('official-HighBoundary', () {
    test('HighBoundaryDecimal1', () async {
      expect(
        await eval(patient1, '1.587.highBoundary(2)'),
        ['1.59'],
      );
    });

    test('HighBoundaryDecimal2', () async {
      expect(
        await eval(patient1, '1.587.highBoundary(6)'),
        ['1.587500'],
      );
    });

    test('HighBoundaryDecimal3', () async {
      expect(
        await eval(patient1, '1.587.highBoundary(-1)'),
        <String?>[],
      );
    });

    test('HighBoundaryDecimal4', () async {
      expect(
        await eval(patient1, '(-1.587).highBoundary()'),
        ['-1.58650000'],
      );
    });

    test('HighBoundaryDecimal5', () async {
      expect(
        await eval(patient1, '(-1.587).highBoundary(2)'),
        ['-1.58'],
      );
    });

    test('HighBoundaryDecimal6', () async {
      expect(
        await eval(patient1, '(-1.587).highBoundary(6)'),
        ['-1.586500'],
      );
    });

    test('HighBoundaryDecimal7', () async {
      expect(
        await eval(patient1, '1.587.highBoundary(39)'),
        <String?>[],
      );
    });

    test('HighBoundaryDecimal8', () async {
      expect(
        await eval(patient1, '1.highBoundary()'),
        ['1.50000000'],
      );
    });

    test('HighBoundaryDecimal9', () async {
      expect(
        await eval(patient1, '1.highBoundary(0)'),
        ['2'],
      );
    });

    test('HighBoundaryDecimal10', () async {
      expect(
        await eval(patient1, '1.highBoundary(5)'),
        ['1.50000'],
      );
    });

    test('HighBoundaryDecimal11', () async {
      expect(
        await eval(patient1, '12.587.highBoundary(2)'),
        ['12.59'],
      );
    });

    test('HighBoundaryDecimal12', () async {
      expect(
        await eval(patient1, '12.500.highBoundary(4)'),
        ['12.5005'],
      );
    });

    test('HighBoundaryDecimal13', () async {
      expect(
        await eval(patient1, '120.highBoundary(2)'),
        ['120.50'],
      );
    });

    test('HighBoundaryDecimal14', () async {
      expect(
        await eval(patient1, '-120.highBoundary(2)'),
        ['-120.50'],
      );
    });

    test('HighBoundaryDecimal15', () async {
      expect(
        await eval(patient1, '0.0034.highBoundary(1)'),
        ['0.0'],
      );
    });

    test('HighBoundaryDecimal16', () async {
      expect(
        await eval(patient1, '-0.0034.highBoundary(1)'),
        ['0.0'],
      );
    });

    test('HighBoundaryDecimal', () async {
      expect(
        await eval(patient1, '1.587.highBoundary(8)'),
        ['1.58750000'],
      );
    });

    // Official output is the quantity 1.58750000 'm'; asserted via = literal.
    test('HighBoundaryQuantity', () async {
      expect(
        await eval(patient1, "(1.587 'm'.highBoundary(8)) = 1.58750000 'm'"),
        ['true'],
      );
    });

    test('HighBoundaryDateMonth', () async {
      expect(
        await eval(patient1, '@2014.highBoundary(6)'),
        ['2014-12'],
      );
    });

    test('HighBoundaryDateTimeMillisecond1', () async {
      expect(
        await eval(patient1, '@2014-01-01T08.highBoundary(17)'),
        ['2014-01-01T08:00:59.999-12:00'],
      );
    });

    test('HighBoundaryDateTimeMillisecond2', () async {
      expect(
        await eval(patient1, '@2014-01-01T08:05-05:00.highBoundary(17)'),
        ['2014-01-01T08:05:59.999-05:00'],
      );
    });

    test('HighBoundaryDateTimeMillisecond3', () async {
      expect(
        await eval(patient1, '@2014-01-01T08.highBoundary(17)'),
        ['2014-01-01T08:00:59.999-12:00'],
      );
    });

    test('HighBoundaryTimeMillisecond', () async {
      expect(
        await eval(patient1, '@T10:30.highBoundary(9)'),
        ['10:30:59.999'],
      );
    });
  });

  group('official-Comparable', () {
    test('Comparable2', () async {
      expect(
        await eval(patient1, "1 'cm'.comparable(1 '[s]')"),
        ['false'],
      );
    });

    test('Comparable3', () async {
      expect(
        await eval(patient1, "1 'cm'.comparable(1 's')"),
        ['false'],
      );
    });
  });

  group('official-Precision', () {
    test('PrecisionYear', () async {
      expect(
        await eval(patient1, '@2014.precision()'),
        ['4'],
      );
    });

    test('PrecisionDateTimeMilliseconds', () async {
      expect(
        await eval(patient1, '@2014-01-05T10:30:00.000.precision()'),
        ['17'],
      );
    });

    test('PrecisionTimeMinutes', () async {
      expect(
        await eval(patient1, '@T10:30.precision()'),
        ['4'],
      );
    });

    test('PrecisionTimeMilliseconds', () async {
      expect(
        await eval(patient1, '@T10:30:00.000.precision()'),
        ['9'],
      );
    });
  });

  group('official-from-Zulip', () {
    // Official: invalid="execution" — must error.
    test('from-zulip-2', () async {
      expect(
        () async => eval(patient1, "(true | 'foo').allTrue()"),
        throwsA(anything),
      );
    });
  });

  group('official-polymorphics', () {
    // testPolymorphicsB: official expects an error from a static semantic-check phase
    // (invalid=semantic); our engine evaluates leniently, so
    // there is no error to assert.
    // expression: Observation.valueQuantity.exists()
  });

  group('official-testInheritance', () {
    test('testFHIRPathAsFunction11', () async {
      expect(
        await eval(patient1, 'Patient.gender.as(string)'),
        <String?>[],
      );
    });

    test('testFHIRPathAsFunction12', () async {
      expect(
        await eval(patient1, 'Patient.gender.as(code)'),
        ['male'],
      );
    });

    test('testFHIRPathAsFunction13', () async {
      expect(
        await eval(patient1, 'Patient.gender.as(id)'),
        <String?>[],
      );
    });

    test('testFHIRPathAsFunction16', () async {
      expect(
        await eval(patient1, 'Patient.gender.ofType(string)'),
        <String?>[],
      );
    });

    test('testFHIRPathAsFunction17', () async {
      expect(
        await eval(patient1, 'Patient.gender.ofType(code)'),
        ['male'],
      );
    });

    test('testFHIRPathAsFunction18', () async {
      expect(
        await eval(patient1, 'Patient.gender.ofType(id)'),
        <String?>[],
      );
    });

    // testFHIRPathAsFunction21: Official expects an execution error from the as() singleton rule,
    // but the Java reference only enforces that rule for R5+ (its R4
    // engine sets doNotEnforceAsSingletonRule); our R4 binding matches the
    // reference's R4 leniency, so there is no error to assert.
    // expression: Patient.name.as(HumanName).use

    test('testFHIRPathAsFunction22', () async {
      expect(
        await eval(patient1, 'Patient.name.ofType(HumanName).use'),
        ['official', 'usual', 'maiden'],
      );
    });

    // Official: invalid="execution" — must error.
    test('testFHIRPathAsFunction23', () async {
      expect(
        () async => eval(patient1, 'Patient.gender.as(string1)'),
        throwsA(anything),
      );
    });

    // Official: invalid="execution" — must error.
    test('testFHIRPathAsFunction24', () async {
      expect(
        () async => eval(patient1, 'Patient.gender.ofType(string1)'),
        throwsA(anything),
      );
    });
  });
}

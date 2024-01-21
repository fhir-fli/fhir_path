// ignore_for_file: unnecessary_string_escapes

// Package imports:
import 'package:fhir/primitive_types/primitive_types.dart';
import 'package:test/test.dart';

// Project imports:
import 'package:fhir_path/fhir_path.dart';
import 'package:ucum/ucum.dart';

FhirPathParser parseResult(String arg) => fhirPathLexer.parse(arg).value;

void testBasicTypes() {
  group('Basic Types', () {
    setUpAll(() {
      UcumService();
    });
    test('Boolean', () {
      expect(parseResult('true'), const BooleanParser(true));
      expect(parseResult('false'), const BooleanParser(false));
    });
    test('String', () {
      expect(parseResult("'test string'"), const StringParser('test string'));
      expect(parseResult("'urn:oid:3.4.5.6.7.8'"),
          const StringParser('urn:oid:3.4.5.6.7.8'));
    });
    test('Delimited Identifier', () {
      expect(
          parseResult("`test string`"), const IdentifierParser('test string'));
      expect(parseResult("`urn:oid:3.4.5.6.7.8`"),
          const IdentifierParser('urn:oid:3.4.5.6.7.8'));
    });
    test('Integer', () {
      expect(parseResult('0'), const IntegerParser(0));
      expect(parseResult('45'), const IntegerParser(45));
      // TODO(Dokotela)
      // expect(parseResult('-5'), const  IntegerParser(-5));
    });
    test('Decimal', () {
      expect(parseResult('0.0'), const DecimalParser(0.0));
      expect(parseResult('3.1415927'), const DecimalParser(3.1415927));
    });
    test('Date', () {
      expect(parseResult('@2015-02-04'),
          DateParser(FhirDate.fromString('2015-02-04')));
      expect(parseResult('@2018-06-12'),
          DateParser(FhirDate.fromString('2018-06-12')));
      expect(parseResult('@2018-06-12'),
          DateParser(FhirDate.fromString('2018-06-12')));
      expect(parseResult('@2018-06-12'),
          DateParser(FhirDate.fromString('2018-06-12')));
      expect(
          parseResult('@2018-06'), DateParser(FhirDate.fromString('2018-06')));
      expect(parseResult('@2018'), DateParser(FhirDate.fromString('2018')));
    });
  });

  test('DateTime', () {
    expect(parseResult('@2015-02-04T14:34:28+09:00'),
        DateTimeParser(FhirDateTime.fromString('2015-02-04T05:34:28Z')));
    expect(parseResult('@2018-02-04T14:38:28+09:00'),
        DateTimeParser(FhirDateTime.fromString('2018-02-04T14:38:28+09:00')));
    expect(parseResult('@2014-01-25T14:30:14.559'),
        DateTimeParser(FhirDateTime.fromString('2014-01-25T14:30:14.559')));
    expect(
        parseResult(
            '@2014-01-25T14:30:14.559Z // A date time with UTC timezone offset'),
        DateTimeParser(FhirDateTime.fromString('2014-01-25T14:30:14.559Z')));
    expect(
        parseResult(
            '@2014-01-25T14:30 // A partial DateTime with year, month, day, hour, and minute'),
        DateTimeParser(FhirDateTime.fromString('2014-01-25T14:30')));
    expect(
        parseResult(
            '@2014-03-25T // A partial DateTime with year, month, and day'),
        DateTimeParser(FhirDateTime.fromString('2014-03-25')));
    expect(parseResult('@2014-01T // A partial DateTime with year and month'),
        DateTimeParser(FhirDateTime.fromString('2014-01')));
    expect(parseResult('@2014T // A partial DateTime with only the year'),
        DateTimeParser(FhirDateTime.fromString('2014')));
  });
  test('Time', () {
    expect(parseResult('@T14:34:28'), TimeParser(FhirTime('14:34:28')));
    expect(parseResult('@T06:55:28'), TimeParser(FhirTime('06:55:28')));
    expect(parseResult('@T06:55:28.559'), TimeParser(FhirTime('06:55:28.559')));
    expect(parseResult('@T06:55'), TimeParser(FhirTime('06:55')));
    expect(parseResult('@T06:54'), TimeParser(FhirTime('06:54')));
  });
  test('Quantity', () {
    expect(
        parseResult("4.5 'mg'"),
        QuantityParser(
            ValidatedQuantity(value: Decimal.fromString('4.5'), code: 'mg')));
    expect(
        parseResult("100 '[degF]'"),
        QuantityParser(ValidatedQuantity(
            value: Decimal.fromString('100'), code: '[degF]')));
  });
  test('Duration quantities', () {
    expect(walkFhirPath(context: null, pathExpression: r"1 seconds = 1 second"),
        [true]);
    expect(walkFhirPath(context: null, pathExpression: r"1 seconds = 1 's'"),
        [true]);
    expect(walkFhirPath(context: null, pathExpression: r"2 seconds = 2 's'"),
        [true]);
    expect(walkFhirPath(context: null, pathExpression: r"1 week != 1 'wk'"),
        [false]);
  });
  test('Non-Escape Sequences', () {
    expect(parseResult("'\p' // 'p'"), const StringParser('p'));
    expect(parseResult("'\\p' // '\p'"), const StringParser(r'\p'));
    expect(parseResult("'\3' // '3'"), const StringParser('3'));
    // expect(parseResult("""'\u005' // 'u005'"""), 'u005');
    expect(parseResult("'\' // ''"), const StringParser(''));
  });
}

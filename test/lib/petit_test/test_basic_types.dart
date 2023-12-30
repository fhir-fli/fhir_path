// ignore_for_file: depend_on_referenced_packages, prefer_single_quotes, unnecessary_statements, leading_newlines_in_multiline_strings, directives_ordering, always_specify_types, unnecessary_parenthesis, avoid_dynamic_calls

// Package imports:
import 'package:fhir/primitive_types/primitive_types.dart';
import 'package:fhir_path/antlrish/fhirpath_lexer.dart';
import 'package:test/test.dart';

// Project imports:
import 'package:fhir_path/petit/petit_fhir_path.dart';

FhirPathParser parseResult(String arg) => fhirPathLexer().parse(arg).value;

void testBasicTypes() {
  group('Basic Types', () {
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
      expect(parseResult("`test string`"),
          const DelimitedIdentifierParser('test string'));
      expect(parseResult("`urn:oid:3.4.5.6.7.8`"),
          const DelimitedIdentifierParser('urn:oid:3.4.5.6.7.8'));
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
      expect(parseResult('@2015-02-04'), DateParser(FhirDate('2015-02-04')));
      expect(parseResult('@2018-06-12'), DateParser(FhirDate('2018-06-12')));
      expect(parseResult('@2018-06-12'), DateParser(FhirDate('2018-06-12')));
      expect(parseResult('@2018-06-12'), DateParser(FhirDate('2018-06-12')));
      expect(parseResult('@2018-06'), DateParser(FhirDate('2018-06')));
      expect(parseResult('@2018'), DateParser(FhirDate('2018')));
    });
  });

  test('DateTime', () {
    expect(parseResult('@2015-02-04T14:34:28+09:00'),
        DateTimeParser(FhirDateTime('2015-02-04T05:34:28')));
    expect(parseResult('@2018-02-04T14:38:28+09:00'),
        DateTimeParser(FhirDateTime('2018-02-04T14:38:28+09:00')));
    expect(parseResult('@2014-01-25T14:30:14.559'),
        DateTimeParser(FhirDateTime('2014-01-25T14:30:14.559')));
    expect(
        parseResult(
            '@2014-01-25T14:30:14.559Z // A date time with UTC timezone offset'),
        DateTimeParser(FhirDateTime('2014-01-25T14:30:14.559Z')));
    expect(
        parseResult(
            '@2014-01-25T14:30 // A partial DateTime with year, month, day, hour, and minute'),
        DateTimeParser(FhirDateTime('2014-01-25T14:30')));
    expect(
        parseResult(
            '@2014-03-25T // A partial DateTime with year, month, and day'),
        DateTimeParser(FhirDateTime('2014-03-25')));
    expect(parseResult('@2014-01T // A partial DateTime with year and month'),
        DateTimeParser(FhirDateTime('2014-01')));
    expect(parseResult('@2014T // A partial DateTime with only the year'),
        DateTimeParser(FhirDateTime('2014')));
  });
  test('Time', () {
    expect(parseResult('@T14:34:28'), TimeParser(FhirTime('14:34:28')));
    expect(parseResult('@T06:55:28'), TimeParser(FhirTime('06:55:28')));
    expect(parseResult('@T06:55:28.559'), TimeParser(FhirTime('06:55:28.559')));
    expect(parseResult('@T06:55'), TimeParser(FhirTime('06:55')));
    expect(parseResult('@T06:54'), TimeParser(FhirTime('06:54')));
  });
  test('Quantity', () {
    expect(parseResult("4.5 'mg'"), QuantityParser("4.5 'mg'"));
    expect(parseResult("100 '[degF]'"), QuantityParser("100 '[degF]'"));
  });
  // test('Duration quantities', () {
  //   expect(
  //       walkFhirPath(context: null, pathExpression: r"1 seconds = 1 second"),
  //       [true]);
  //   expect(walkFhirPath(context: null, pathExpression: r"1 seconds = 1 's'"),
  //       [true]);
  //   expect(walkFhirPath(context: null, pathExpression: r"2 seconds = 2 's'"),
  //       [true]);
  //   expect(walkFhirPath(context: null, pathExpression: r"1 week != 1 'w'"),
  //       [true]);
  // });
  // test('Non-Escape Sequences', () {
  // TODO(Dokotela):  figure out escape sequences
  // expect(
  //     ((parseResult("'\p' // 'p'") as ParserList).first as StringParser)
  //         .value
  //         .value,
  //     'p');
  // expect(
  //     ((parseResult("'\\p' // '\p'") as ParserList).first as StringParser)
  //         .value
  //         .value,
  //     '\p');
  // expect(
  //     ((parseResult("'\3' // '3'") as ParserList).first as StringParser)
  //         .value
  //         .value,
  //     '3');
  // expect(
  //     ((parseResult("'\u005' // 'u005'") as ParserList).first
  //             as StringParser)
  //         .value
  //         .value,
  //     'u005');
  // expect(
  //     ((parseResult(""' // '"") as ParserList).first as StringParser)
  //         .value
  //         .value,
  //     '');
  // });
  // });
}

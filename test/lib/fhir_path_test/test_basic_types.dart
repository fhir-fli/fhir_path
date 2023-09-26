// ignore_for_file: depend_on_referenced_packages, prefer_single_quotes, unnecessary_statements, leading_newlines_in_multiline_strings, directives_ordering, always_specify_types, unnecessary_parenthesis, avoid_dynamic_calls

// Package imports:
import 'package:fhir/primitive_types/primitive_types.dart';
import 'package:test/test.dart';

// Project imports:
import 'package:fhir_path/fhir_path.dart';

FhirPathParser parseResult(String arg) => fhirPathLexer().parse(arg).value;

void testBasicTypes() {
  group('Basic Types', () {
    test('Boolean', () {
      expect((((parseResult('true') as ParserList)).first as ValueParser).value,
          (const ParserList([BooleanParser(true)]).first as ValueParser).value);
      expect(
          (((parseResult('false') as ParserList)).first as ValueParser).value,
          (const ParserList([BooleanParser(false)]).first as ValueParser)
              .value);
    });
    test('String', () {
      expect(
          (((parseResult("'test string'") as ParserList)).first as ValueParser)
              .value,
          (const ParserList([StringParser('test string')]).first as ValueParser)
              .value);
      expect(
          (((parseResult("'urn:oid:3.4.5.6.7.8'") as ParserList)).first
                  as ValueParser)
              .value,
          (const ParserList([StringParser('urn:oid:3.4.5.6.7.8')]).first
                  as ValueParser)
              .value);
    });
    test('Delimited Identifier', () {
      expect(
          ((parseResult("`test string`") as ParserList).first as ValueParser)
              .value,
          (const ParserList([DelimitedIdentifierParser('test string')]).first
                  as ValueParser)
              .value);
      expect(
          ((parseResult("`urn:oid:3.4.5.6.7.8`") as ParserList).first
                  as ValueParser)
              .value,
          (const ParserList([DelimitedIdentifierParser('urn:oid:3.4.5.6.7.8')])
                  .first as ValueParser)
              .value);
    });
    test('Integer', () {
      expect((((parseResult('0') as ParserList)).first as ValueParser).value,
          (const ParserList([IntegerParser(0)]).first as ValueParser).value);
      expect((((parseResult('45') as ParserList)).first as ValueParser).value,
          (const ParserList([IntegerParser(45)]).first as ValueParser).value);
      expect(
          ((((parseResult('-5') as ParserList)).first as OperatorParser)
                  .after
                  .first as ValueParser)
              .value,
          ((const ParserList([IntegerParser(5)])).first as ValueParser).value);
    });
    test('Decimal', () {
      expect((((parseResult('0.0') as ParserList)).first as ValueParser).value,
          (const ParserList([DecimalParser(0.0)]).first as ValueParser).value);
      expect(
          (((parseResult('3.1415927') as ParserList)).first as ValueParser)
              .value,
          (const ParserList([DecimalParser(3.1415927)]).first as ValueParser)
              .value);
    });
    test('Date', () {
      expect(
          (((parseResult('@2015-02-04') as ParserList)).first as ValueParser)
              .value,
          (ParserList([DateParser(FhirDate('2015-02-04'))]).first
                  as ValueParser)
              .value);
      expect(
          (((parseResult('@2018-06-12') as ParserList)).first as ValueParser)
              .value,
          (ParserList([DateParser(FhirDate('2018-06-12'))]).first
                  as ValueParser)
              .value);
      expect(
          (((parseResult('@2018-06-12') as ParserList)).first as ValueParser)
              .value,
          (ParserList([DateParser(FhirDate('2018-06-12'))]).first
                  as ValueParser)
              .value);
      expect(
          (((parseResult('@2018-06-12') as ParserList)).first as ValueParser)
              .value,
          (ParserList([DateParser(FhirDate('2018-06-12'))]).first
                  as ValueParser)
              .value);
      expect(
          (((parseResult('@2018-06') as ParserList)).first as ValueParser)
              .value,
          (ParserList([DateParser((FhirDate('2018-06')))]).first as ValueParser)
              .value);
      expect(
          (((parseResult('@2018') as ParserList)).first as ValueParser).value,
          (ParserList([DateParser(FhirDate('2018'))]).first as ValueParser)
              .value);
    });
    test('DateTime', () {
      expect(
          (((parseResult('@2015-02-04T14:34:28+09:00') as ParserList)).first
                  as ValueParser)
              .value
              .first
              .value,
          DateTimeParser([
            DateParser(FhirDate('2015-02-04')),
            TimeParser(FhirTime('05:34:28'))
          ]).value.first.value);
      expect(
          (((parseResult('@2018-02-04T14:34:28+09:00') as ParserList)).first
                  as ValueParser)
              .value
              .last
              .value,
          DateTimeParser([
            DateParser(FhirDate('2015-02-04')),
            TimeParser(FhirTime('05:34:28'))
          ]).value.last.value);
      expect(
          (((parseResult('@2014-01-25T14:30:14.559') as ParserList)).first
                  as ValueParser)
              .value
              .first
              .value,
          (ParserList([
            DateTimeParser([FhirDate('2014-01-25'), FhirTime('14:30:14.559')])
          ]).first as ValueParser)
              .value
              .first);
      expect(
          ((parseResult('@2014-03-25T // A partial DateTime with year, month, and day')
                      as ParserList)
                  .first as ValueParser)
              .value,
          (ParserList([
            DateTimeParser([FhirDateTime('2014-03-25')])
          ]).first as ValueParser)
              .value);
    });
    test('Time', () {
      expect(
          (((parseResult('@T14:34:28') as ParserList)).first as ValueParser)
              .value,
          (ParserList([TimeParser(FhirTime('14:34:28'))]).first as ValueParser)
              .value);
      expect(
          (((parseResult('@T06:55:28') as ParserList)).first as ValueParser)
              .value,
          (ParserList([TimeParser(FhirTime('06:55:28'))]).first as ValueParser)
              .value);
      expect(
          (((parseResult('@T06:55:28.559') as ParserList)).first as ValueParser)
              .value,
          (ParserList([TimeParser(FhirTime('06:55:28.559'))]).first
                  as ValueParser)
              .value);
      expect(
          (((parseResult('@T06:55') as ParserList)).first as ValueParser).value,
          (ParserList([TimeParser(FhirTime('06:55'))]).first as ValueParser)
              .value);
      expect(
          (((parseResult('@T06:54') as ParserList)).first as ValueParser).value,
          (ParserList([TimeParser(FhirTime('06:54'))]).first as ValueParser)
              .value);
    });
    test('Quantity', () {
      expect(
          (((parseResult("4.5 'mg'") as ParserList)).first as ValueParser)
              .value,
          (ParserList([QuantityParser(FhirPathQuantity(4.5, 'mg'))]).first
                  as ValueParser)
              .value);
      expect(
        ((parseResult("100 '[degF]'") as ParserList).first as ValueParser)
            .value,
        (ParserList([QuantityParser(FhirPathQuantity(100, '[degF]'))]).first
                as ValueParser)
            .value,
      );
    });
    test('Duration quantities', () {
      expect(
          walkFhirPath(context: null, pathExpression: r"1 seconds = 1 second"),
          [true]);
      expect(walkFhirPath(context: null, pathExpression: r"1 seconds = 1 's'"),
          [true]);
      expect(walkFhirPath(context: null, pathExpression: r"2 seconds = 2 's'"),
          [true]);
      expect(walkFhirPath(context: null, pathExpression: r"1 week != 1 'w'"),
          [true]);
    });
    test('Non-Escape Sequences', () {
      expect(
          ((parseResult("'p' // 'p'") as ParserList).first as StringParser)
              .value,
          'p');
      expect(
          ((parseResult("'\\p' // 'p'") as ParserList).first as StringParser)
              .value,
          'p');
      expect(
          ((parseResult("'3' // '3'") as ParserList).first as StringParser)
              .value,
          '3');
      expect(
          ((parseResult(r"'\u005' // 'u005'") as ParserList).first
                  as StringParser)
              .value,
          'u005');
      // TODO(Dokotela): empty escape sequence
      // expect(
      //     ((parseResult(r"" ' // ' "") as ParserList).first as StringParser)
      //         .value,
      //     '');
    });
  });
}

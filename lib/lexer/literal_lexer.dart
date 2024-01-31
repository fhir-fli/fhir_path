// ignore_for_file: avoid_dynamic_calls

// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:fhir/primitive_types/primitive_types.dart';
import 'package:petitparser/petitparser.dart';
import 'package:ucum/ucum.dart';

// Project imports:
import '../fhir_path.dart';

/******************************************************************************
 *  Most of these Lexers specify basic literals as defined in the FHIRPath
 * grammar that can be seen here: http://hl7.org/fhirpath/grammar.html
 * ***************************************************************************/

/// Finds strings 'true' or 'false' (without quotes)
final Parser<BooleanParser> booleanLiteral = (string('true') | string('false'))
    .flatten()
    .map((value) => BooleanParser(value == 'true'));

/// Allows environmental variables to be passed to FHIRPath
final Parser<EnvVariableParser> envVariableLexer =
    (char('%') & (IDENTIFIER | DELIMITEDIDENTIFIER))
        .flatten()
        .map((value) => EnvVariableParser(value));

// TODO(Dokotela): unit should be optional
final Parser<QuantityParser> quantityLiteral =
    (NUMBER.flatten() & (char(' ') & unit)).map((value) {
  return QuantityParser(ValidatedQuantity(
      value: Decimal.fromString(value[0]),
      code: value.length > 1 ? value[1].last : null));
});

final Parser<String> unit = (pluralDateTimePrecision |
        dateTimePrecision |
        STRING
            .where((value) {
              return UcumService().validate(value.value) == null;
            })
            .trim()
            .map((value) => value.value))
    .flatten()
    .map((value) {
  if (value.startsWith("'")) {
    value = value.substring(1, value.length - 1);
  }
  if (value.endsWith("'")) {
    value = value.substring(0, value.length - 1);
  }
  return value;
});

final Parser<String> dateTimePrecision = (string('year') |
        string('month') |
        string('week') |
        string('day') |
        string('hour') |
        string('minute') |
        string('second') |
        string('millisecond'))
    .flatten();

final Parser<String> pluralDateTimePrecision = (string('years') |
        string('months') |
        string('weeks') |
        string('days') |
        string('hours') |
        string('minutes') |
        string('seconds') |
        string('milliseconds'))
    .flatten();

/// Follows DateTime format specified in FHIRPath (I have also updated the FHIR)
/// package to follow many of these guidelines
final Parser<DateParser> DATE = (char('@') & DATEFORMAT).flatten().map((value) {
  return DateParser(FhirDate.fromString(value.replaceFirst('@', '')));
});

final Parser<DateTimeParser> DATETIME = (char('@') &
        DATEFORMAT &
        char('T') &
        (TIMEFORMAT & TIMEZONEOFFSETFORMAT.optional()).optional())
    .flatten()
    .map((value) {
  return DateTimeParser(FhirDateTime.fromString(value.replaceFirst('@', '')));
});

final Parser<TimeParser> TIME = (char('@') & char('T') & TIMEFORMAT)
    .flatten()
    .map((value) => TimeParser(FhirTime(value.replaceFirst('@T', ''))));

final Parser<String> DATEFORMAT = (pattern('0-9').times(4) &
        (char('-') &
                pattern('0-9').times(2) &
                (char('-') & pattern('0-9').times(2)).optional())
            .optional())
    .flatten();

final Parser<String> TIMEFORMAT = (pattern('0-9').times(2) &
        (char(':') &
                pattern('0-9').times(2) &
                (char(':') &
                        pattern('0-9').times(2) &
                        (char('.') & pattern('0-9').plus()).optional())
                    .optional())
            .optional())
    .flatten();

final Parser<String> TIMEZONEOFFSETFORMAT = (char('Z') |
        (pattern('+-') &
            pattern('0-9').times(2) &
            char(':') &
            pattern('0-9').times(2)))
    .flatten();

/// An Identifier has no quotes
final Parser<IdentifierParser> IDENTIFIER = ((pattern('A-Za-z') | char('_')) &
        (pattern('A-Za-z0-9') | char('_')).star())
    .flatten()
    .map((value) => IdentifierParser('', value));

/// DELIMITEDIDENTIFIER is signified by a backquote (`) on either end
final Parser<IdentifierParser> DELIMITEDIDENTIFIER =
    (char('`') & (ESC | char('`').neg()).star() & char('`')).map((value) {
  final middleValue = value[1]
      .map((e) => e is Token
          ? e.value.contains('u') as bool
              ? utf8.decode(
                  [int.parse(e.value.split('u').last as String, radix: 16)])
              : e.value.replaceAll(r'\\', r'\')
          : e == r'\'
              ? ''
              : e)
      .join('');
  return IdentifierParser('`', middleValue);
});

final Parser<IdentifierParser> DOUBLEQUOTEDIDENTIFIER =
    (char('"') & (ESC | char('"').neg()).star() & char('"')).map((value) {
  final middleValue = value[1]
      .map((e) => e is Token
          ? e.value.contains('u') as bool
              ? utf8.decode(
                  [int.parse(e.value.split('u').last as String, radix: 16)])
              : e.value.replaceAll(r'\\', r'\')
          : e == r'\'
              ? ''
              : e)
      .join('');
  return IdentifierParser('"', middleValue);
});

/// A String is signified by single quotes (') on either end
final Parser<StringParser> STRING =
    (char("'") & (ESC | char("'").neg()).star() & char("'")).map((value) {
  return StringParser(value[1].join(''));
});

/// Also allows leading zeroes now (just like CQL and XSD)
final Parser NUMBER = DECIMAL.or(INTEGER);

final Parser<DecimalParser> DECIMAL =
    (pattern('0-9').plus() & char('.') & pattern('0-9').plus())
        .flatten()
        .map((value) => DecimalParser(double.parse(value)));

final Parser<IntegerParser> INTEGER = pattern('0-9')
    .plus()
    .flatten()
    .map((value) => IntegerParser(int.parse(value)));

/// No equivalent for piping whitespace to the HIDDEN channel in Dart
final Parser<WhiteSpaceParser> WS =
    pattern(' \r\n\t').plus().flatten().map((value) => WhiteSpaceParser(value));

final Parser<WhiteSpaceParser> COMMENT = string('/*')
    .seq(pattern('^\\*'))
    .star()
    .seq(string('*/'))
    .flatten()
    .map((value) => WhiteSpaceParser(value));

final Parser<WhiteSpaceParser> LINE_COMMENT =
    (string('//') & (string('\r') | string('\n')).neg().star())
        .flatten()
        .map((value) => WhiteSpaceParser(value));

final Parser<String> ESC = ((char('\\') & pattern('`\'\\/fnrt')).flatten() |
        (char('\\') & UNICODE).map((value) {
          return String.fromCharCodes(
              [int.parse(value[1].replaceAll('u', ''), radix: 16)]);
        }))
    .map((value) {
  return value == r"\'"
      ? "'"
      : value == r"\`"
          ? '`'
          : jsonDecode('"$value"');
});

final Parser<String> UNICODE =
    string('u').seq(HEX).seq(HEX).seq(HEX).seq(HEX).flatten().map((value) {
  return value;
});

final Parser<String> HEX = pattern('0-9a-fA-F').flatten();

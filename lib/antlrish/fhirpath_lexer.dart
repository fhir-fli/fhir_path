import 'package:fhir/primitive_types/primitive_types.dart';

import '../fhir_path.dart';
import 'package:petitparser/parser.dart';

/// Grammar rules [FHIRPath](http://hl7.org/fhirpath/N1) Normative Release
///prog: line (line)*; line: ID ( '(' expr ')') ':' expr '\r'? '\n';

final Parser<FhirPathParser> fhirPathLexer = fhirPathExpression().map((value) {
  FhirPathParser? setupParser(List<dynamic> list) {
    FhirPathParser? nextParser;
    for (var i = 0; i < list.length; i++) {
      if (list[i] is FhirPathParser) {
        nextParser = setupParser(list.sublist(i + 1));
        if (nextParser != null) {
          return list[i].copyWithNextParser(nextParser);
        } else {
          return list[i];
        }
      }
      if (list[i] is List) {
        nextParser = setupParser(list[i]);
        if (nextParser != null) {
          final nextNextParser = setupParser(list.sublist(i + 1));
          if (nextNextParser != null) {
            return nextParser.copyWithNextParser(nextNextParser);
          } else {
            return nextParser;
          }
        }
      } else {
        if (list[i] != '.') {
          print('$i: ${list[i].runtimeType}: ${list[i]}');
        }
      }
    }
    return null;
  }

  if (value is FhirPathParser) {
    return value;
  } else if (value is List && value.first is FhirPathParser) {
    final parser = setupParser(value);
    if (parser != null) {
      return parser;
    } else {
      return EmptyParser();
    }
  } else {
    return EmptyParser();
  }
});

Parser fhirPathExpression() {
  final _expression = undefined();
  final _invocation = undefined();
  final _function = undefined();
  final _paramList = undefined();

  final Parser expressionPart = (char('(') & _expression & char(')')) |
      _invocation |
      (literal & char('.') & _invocation) |
      _function |
      literal |
      string('\$this') |
      string('\$index') |
      string('\$total') |
      externalConstant |
      (_expression & char('.') & _invocation) |
      (_expression & char('[') & _expression & char(']')) |
      ((char('+') | char('-')) & _expression) |
      (_expression &
          (char('*') | char('/') | string('div') | string('mod')) &
          _expression) |
      (_expression & (char('+') | char('-') | char('&')) & _expression) |
      (_expression & (string('is') | string('as')) & typeSpecifier) |
      (_expression & char('|') & _expression) |
      (_expression &
          (string('<=') | char('<') | char('>') | string('>=') & _expression)) |
      (_expression &
          (char('=') | char('~') | string('!=') | string('!~')) &
          _expression) |
      (_expression & (string('in') | string('contains')) & _expression) |
      (_expression & string('and') & _expression) |
      (_expression & (string('or') | string('xor')) & _expression) |
      (_expression & string('implies') & _expression);

  /// | (IDENTIFIER)? '=>' expression #lambdaExpression

  /// invocation : // Terms that can be used after the function/member invocation '.'
  final Parser invocationPart = ((_function |
          identifier |
          string('\$this') |
          string('\$index') |
          string('\$total')) &
      (char('.') & _invocation).star());

  final Parser functionPart = ((pattern('A-Za-z').plus().flatten().where(
                      (value) => noArgumentFunctions.keys.contains(value)) &
                  string('()'))
              .map((value) {
            return noArgumentFunctions[value[0]]!;
          }) |
          (pattern('A-Za-z')
                  .plus()
                  .flatten()
                  .where((value) => argumentFunctionNames.contains(value)) &
              char('(') &
              _paramList.optional() &
              char(')')))
      .map((value) => value);

  final Parser paramListPart = _expression & (char(',') & _expression).star();

  _expression.set(expressionPart.end());
  _invocation.set(invocationPart);
  _function.set(functionPart);
  _paramList.set(paramListPart);
  return _expression;
}

final Parser literal = ((STRING |
                NULL.flatten().map((value) => EmptySetParser()) |
                (string('true') | string('false'))
                    .map((value) => BooleanParser(value == 'true')) |
                quantity |
                NUMBER |
                DATETIME |
                DATE |
                TIME)
            .trim() &
        ignored.optional())
    .map((value) => value[0]);

final Parser NULL = char('{').trim() & char('}').trim();

final Parser externalConstant = char('%').seq(identifier | STRING);

/// TODO(Dokotela): unit should be optional
final Parser<QuantityParser> quantity = (NUMBER & (char(' ') & unit))
    .flatten()
    .map((value) => QuantityParser(value));

final Parser<String> unit =
    (dateTimePrecision | pluralDateTimePrecision | STRING).flatten();

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

final Parser typeSpecifier = qualifiedIdentifier;

final Parser qualifiedIdentifier =
    identifier.seq(char('.').seq(identifier).star());

final Parser identifier = (IDENTIFIER.map((value) => IdentifierParser(value)) |
        DELIMITEDIDENTIFIER.map((value) => DelimitedIdentifierParser(value)) |
        string('as') |
        string('contains') |
        string('in') |
        string('is'))
    .map((value) => value);

/// *********************** Lexical rules ************************************
///
///  NOTE: The goal of these rules in the grammar is to provide a date token to the parser. As such it
///  is not attempting to validate that the date is a correct date, that task is for the parser or
///  interpreter.
///

final Parser<DateParser> DATE = (char('@') & DATEFORMAT)
    .flatten()
    .map((value) => DateParser(FhirDate(value.replaceFirst('@', ''))));

final Parser<DateTimeParser> DATETIME = (char('@') &
        DATEFORMAT &
        char('T') &
        (TIMEFORMAT & TIMEZONEOFFSETFORMAT.optional()).optional())
    .flatten()
    .map((value) {
  return DateTimeParser(FhirDateTime(value.replaceFirst('@', '')));
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

final Parser<String> trueFalseParser =
    (string('true') | string('false')).flatten();

final Parser<String> IDENTIFIER = ((pattern('A-Za-z') | char('_'))
        .seq((pattern('A-Za-z0-9') | char('_')).star()))
    .flatten()
    .where((value) =>
        value != 'true' &&
        value != 'false' &&
        !allFunctionNames.contains(value));

final Parser<String> DELIMITEDIDENTIFIER =
    (char('`') & (ESC | char('`').neg()).star() & char('`'))
        .flatten()
        .where((value) =>
            value != 'true' &&
            value != 'false' &&
            !allFunctionNames.contains(value))
        .map((value) =>
            // Remove the backticks from the parsed value
            value.substring(1, value.length - 1));

final Parser<StringParser> STRING =
    (char("'") & (ESC | char("'").neg()).star() & char("'"))
        .flatten()
        .map((value) =>
            // Remove the quotes from the parsed value
            StringParser(value.substring(1, value.length - 1)));

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

final Parser ignored = COMMENT | LINE_COMMENT | WS;

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

final Parser<String> ESC =
    char('\\').seq(pattern('`\'\\/fnrt')).or(UNICODE).flatten();

final Parser<String> UNICODE =
    string('u').seq(HEX).seq(HEX).seq(HEX).seq(HEX).flatten();

final Parser<String> HEX = pattern('0-9a-fA-F');

final Set<String> allFunctionNames = {
  ...argumentFunctionNames,
  ...noArgumentFunctions.keys,
};

final Set<String> argumentFunctionNames = {
  'union',
  'combine',
  'exists',
  'all',
  'subsetOf',
  'supersetOf',
  'where',
  'select',
  'repeat',
  'ofType',
  // TODO(Dokotela) how to differentiate between function & identifier
  //'extension',
  'log',
  'power',
  'round',
  'indexOf',
  'substring',
  'startsWith',
  'endsWith',
  'contains',
  'replace',
  'matches',
  'replaceMatches',
  'skip',
  'take',
  'intersect',
  'exclude',
  'trace',
  'aggregate',
  'iif',
  'as',
  'sum',
  'min',
  'max',
  'avg',
  'answers',
  'ordinal',
};

final Map<String, FhirPathParser> noArgumentFunctions =
    <String, FhirPathParser>{
  'toBoolean': ToBooleanParser(),
  'convertsToBoolean': ConvertsToBooleanParser(),
  'toInteger': ToIntegerParser(),
  'convertsToInteger': ConvertsToIntegerParser(),
  'toDate': ToDateParser(),
  'convertsToDate': ConvertsToDateParser(),
  'toDateTime': ToDateTimeParser(),
  'convertsToDateTime': ConvertsToDateTimeParser(),
  'toDecimal': ToDecimalParser(),
  'convertsToDecimal': ConvertsToDecimalParser(),
  'toString': ToStringParser(),
  'convertsToString': ConvertsToStringParser(),
  'toTime': ToTimeParser(),
  'convertsToTime': ConvertsToTimeParser(),
  'toQuantity': ToQuantityParser(),
  'convertsToQuantity': ConvertsToQuantityParser(),
  'hasValue': HasValueParser(),
  'empty': EmptyParser(),
  'allTrue': AllTrueOrFalseParser(true),
  'anyTrue': AnyTrueOrFalseParser(true),
  'allFalse': AllTrueOrFalseParser(false),
  'anyFalse': AnyTrueOrFalseParser(false),
  'count': CountParser(),
  'distinct': DistinctParser(),
  'isDistinct': IsDistinctParser(),
  'abs': AbsParser(),
  'ceiling': CeilingParser(),
  'exp': ExpParser(),
  'floor': FloorParser(),
  'ln': LnParser(),
  'sqrt': SqrtParser(),
  'truncate': TruncateParser(),
  'upper': UpperParser(),
  'lower': LowerParser(),
  'length': LengthParser(),
  'toChars': ToCharsParser(),
  'single': SingleParser(),
  'first': FirstParser(),
  'last': LastParser(),
  'tail': TailParser(),
  'children': ChildrenParser(),
  'descendants': DescendantsParser(),
  'not': FpNotParser(),
  'now': NowParser(),
  'timeOfDay': TimeOfDayParser(),
  'today': TodayParser(),
};

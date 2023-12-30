import 'package:fhir/primitive_types/primitive_types.dart';

import '../fhir_path.dart';
import 'package:petitparser/parser.dart';

/// Grammar rules [FHIRPath](http://hl7.org/fhirpath/N1) Normative Release
///prog: line (line)*; line: ID ( '(' expr ')') ':' expr '\r'? '\n';

Parser fhirPathLexer() {
  final _expression = undefined();
  final _invocation = undefined();
  final _function = undefined();
  final _paramList = undefined();

  /// expression:
  final Parser expressionPart =

      /// 	| '(' expression ')'	# parenthesizedTerm;
      (char('(') & _expression & char(')')) |

          /// 	function	# functionInvocation
          _function |

          /// 	| literal				# literalTerm
          literal.map((value) {
            print('expressionliteral: $value');
            return value;
          }) |

          /// 	identifier	# memberInvocation
          (identifier &
                  (char('.') & identifier).map((value) => value[1]).star())
              .map((value) {
            var newValue = value[0];
            for (var i = 1; i < value[1].length; i++) {
              newValue += '.' + value[1][i];
            }
            print('expressionidentifier: $newValue');
            return IdentifierParser(newValue);
          }) |
          _invocation.map((value) {
            print('expressioninvocation: $value');
            return value;
          }) |

          /// 	'$this'	# thisInvocation
          string('\$this') |

          /// 	'$index'	# indexInvocation
          string('\$index') |

          /// 	'$total'	# totalInvocation;
          string('\$total') |

          /// 	| externalConstant		# externalConstantTerm
          externalConstant |

          /// 	| expression '[' expression ']'						# indexerExpression
          (_expression & char('[') & _expression & char(']')) |

          /// 	| ('+' | '-') expression							# polarityExpression
          ((char('+') | char('-')) & _expression) |

          /// 	| expression ('*' | '/' | 'div' | 'mod') expression	# multiplicativeExpression
          (_expression &
              (char('*') | char('/') | string('div') | string('mod')) &
              _expression) |

          /// 	| expression ('+' | '-' | '&') expression			# additiveExpression
          (_expression & (char('+') | char('-') | char('&')) & _expression) |

          /// 	| expression ('is' | 'as') typeSpecifier			# typeExpression
          (_expression & (string('is') | string('as')) & typeSpecifier) |

          /// 	| expression '|' expression							# unionExpression
          (_expression & char('|') & _expression) |

          /// 	| expression ('<=' | '<' | '>' | '>=') expression	# inequalityExpression
          (_expression &
              (string('<=') |
                  char('<') |
                  char('>') |
                  string('>=') & _expression)) |

          /// 	| expression ('=' | '~' | '!=' | '!~') expression	# equalityExpression
          (_expression &
              (char('=') | char('~') | string('!=') | string('!~')) &
              _expression) |

          /// 	| expression ('in' | 'contains') expression			# membershipExpression
          (_expression & (string('in') | string('contains')) & _expression) |

          /// 	| expression 'and' expression						# andExpression
          (_expression & string('and') & _expression) |

          /// 	| expression ('or' | 'xor') expression				# orExpression
          (_expression & (string('or') | string('xor')) & _expression) |

          /// 	| expression 'implies' expression					# impliesExpression
          (_expression & string('implies') & _expression);

  /// | (IDENTIFIER)? '=>' expression #lambdaExpression

  /// invocation : // Terms that can be used after the function/member invocation '.'
  final Parser invocationPart =

      /// 	| expression '.' invocation							# invocationExpression
      _expression &
          char('.') &
          (

              /// 	identifier	# memberInvocation
              identifier |

                  /// 	function	# functionInvocation
                  _function |

                  /// 	'$this'	# thisInvocation
                  string('\$this') |

                  /// 	'$index'	# indexInvocation
                  string('\$index') |

                  /// 	'$total'	# totalInvocation;
                  string('\$total'));

  /// function: identifier '(' paramList? ')';
  final Parser functionPart =
      functions & char('(') & _paramList.optional() & char(')');

  /// paramList: expression (',' expression)*;
  final Parser paramListPart = _expression & (char(',') & _expression).star();

  _expression.set(expressionPart.end());
  _invocation.set(invocationPart);
  _function.set(functionPart);
  _paramList.set(paramListPart);
  return _expression;
}

/// literal:
/// 	'{' '}'					# nullLiteral
/// 	| ('true' | 'false')	# booleanLiteral
/// 	| STRING				# stringLiteral
/// 	| NUMBER				# numberLiteral
/// 	| DATE					# dateLiteral
/// 	| DATETIME				# dateTimeLiteral
/// 	| TIME					# timeLiteral
/// 	| quantity				# quantityLiteral;
final Parser literal = ((STRING |
                NULL |
                (string('true') | string('false'))
                    .map((value) => BooleanParser(value == 'true')) |
                quantity |
                NUMBER |
                DATETIME |
                DATE |
                TIME)
            .trim() &
        ignored.optional())
    .map((value) {
  print('literal: ${value[0]}');
  return value[0];
});

final Parser NULL = string('{}');

/// externalConstant: '%' ( identifier | STRING);
final Parser externalConstant = char('%').seq(identifier | STRING);

/// quantity: NUMBER unit?;
/// TODO(Dokotela): unit should be optional
final Parser<QuantityParser> quantity = (NUMBER & (char(' ') & unit))
    .flatten()
    .map((value) => QuantityParser(value));

/// unit:
/// 	dateTimePrecision
/// 	| pluralDateTimePrecision
/// 	| STRING ; // UCUM syntax for units of measure
final Parser<String> unit =
    (dateTimePrecision | pluralDateTimePrecision | STRING).flatten();

/// dateTimePrecision:
/// 	'year'
/// 	| 'month'
/// 	| 'week'
/// 	| 'day'
/// 	| 'hour'
/// 	| 'minute'
/// 	| 'second'
/// 	| 'millisecond';
final Parser<String> dateTimePrecision = (string('year') |
        string('month') |
        string('week') |
        string('day') |
        string('hour') |
        string('minute') |
        string('second') |
        string('millisecond'))
    .flatten();

/// pluralDateTimePrecision:
/// 	'years'
/// 	| 'months'
/// 	| 'weeks'
/// 	| 'days'
/// 	| 'hours'
/// 	| 'minutes'
/// 	| 'seconds'
/// 	| 'milliseconds';
final Parser<String> pluralDateTimePrecision = (string('years') |
        string('months') |
        string('weeks') |
        string('days') |
        string('hours') |
        string('minutes') |
        string('seconds') |
        string('milliseconds'))
    .flatten();

/// typeSpecifier: qualifiedIdentifier;
final Parser typeSpecifier = qualifiedIdentifier;

/// qualifiedIdentifier: identifier ('.' identifier)*;
final Parser qualifiedIdentifier =
    identifier.seq(char('.').seq(identifier).star());

/// identifier:
/// 	IDENTIFIER
/// 	| DELIMITEDIDENTIFIER
/// 	| 'as'
/// 	| 'contains'
/// 	| 'in'
/// 	| 'is';
final Parser<String> identifier = (IDENTIFIER |
        DELIMITEDIDENTIFIER |
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

/// DATE: '@' DATEFORMAT;
final Parser<DateParser> DATE = (char('@') & DATEFORMAT)
    .flatten()
    .map((value) => DateParser(FhirDate(value.replaceFirst('@', ''))));

/// DATETIME:
/// 	'@' DATEFORMAT 'T' (TIMEFORMAT TIMEZONEOFFSETFORMAT?)?;
final Parser<DateTimeParser> DATETIME = (char('@') &
        DATEFORMAT &
        char('T') &
        (TIMEFORMAT & TIMEZONEOFFSETFORMAT.optional()).optional())
    .flatten()
    .map((value) => DateTimeParser(FhirDateTime(value.replaceFirst('@', ''))));

/// TIME: '@' 'T' TIMEFORMAT;
final Parser<TimeParser> TIME = (char('@') & char('T') & TIMEFORMAT)
    .flatten()
    .map((value) => TimeParser(FhirTime(value.replaceFirst('@T', ''))));

/// fragment DATEFORMAT:
/// 	[0-9][0-9][0-9][0-9] ('-' [0-9][0-9] ('-' [0-9][0-9])?)?;
final Parser<String> DATEFORMAT = (pattern('0-9').times(4) &
        (char('-') &
                pattern('0-9').times(2) &
                (char('-') & pattern('0-9').times(2)).optional())
            .optional())
    .flatten();

/// fragment TIMEFORMAT:
/// 	[0-9][0-9] (':' [0-9][0-9] (':' [0-9][0-9] ('.' [0-9]+)?)?)?;
final Parser<String> TIMEFORMAT = (pattern('0-9').times(2) &
        (char(':') &
                pattern('0-9').times(2) &
                (char(':') &
                        pattern('0-9').times(2) &
                        (char('.') & pattern('0-9').plus()).optional())
                    .optional())
            .optional())
    .flatten();

/// fragment TIMEZONEOFFSETFORMAT: (
/// 		'Z'
/// 		| ('+' | '-') [0-9][0-9]':' [0-9][0-9]
/// 	);
final Parser<String> TIMEZONEOFFSETFORMAT = (char('Z') |
        (pattern('+-') &
            pattern('0-9').times(2) &
            char(':') &
            pattern('0-9').times(2)))
    .flatten();

/// IDENTIFIER: ([A-Za-z] | '_') ([A-Za-z0-9] | '_')*
/// 		; // Added _ to support CQL (FHIR could constrain it out)
final Parser<String> IDENTIFIER = (pattern('A-Za-z') | char('_'))
    .seq((pattern('A-Za-z0-9') | char('_')).star())
    .flatten();

/// DELIMITEDIDENTIFIER: '`' (ESC | .)*? '`';
final Parser<String> DELIMITEDIDENTIFIER =
    (char('`') & (ESC | char('`').neg()).star() & char('`'))
        .flatten()
        .map((value) =>
            // Remove the backticks from the parsed value
            value.substring(1, value.length - 1));

/// STRING: '\'' (ESC | .)*? '\'';
final Parser<StringParser> STRING =
    (char("'") & (ESC | char("'").neg()).star() & char("'"))
        .flatten()
        .map((value) {
  // Remove the quotes from the parsed value
  final contentWithoutQuotes = value.substring(1, value.length - 1);
  return StringParser(contentWithoutQuotes);
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

/// allow \`, \', \\, \/, \f, etc. and \uXXX
final Parser<String> ESC =
    char('\\').seq(pattern('`\'\\/fnrt')).or(UNICODE).flatten();

final Parser<String> UNICODE =
    string('u').seq(HEX).seq(HEX).seq(HEX).seq(HEX).flatten();

final Parser<String> HEX = pattern('0-9a-fA-F');

final Parser functions = string('union(') |
    string('combine(') |
    string('toQuantity(') |
    string('convertsToQuantity(') |
    string('exists(') |
    string('all(') |
    string('subsetOf(') |
    string('supersetOf(') |
    string('where(') |
    string('select(') |
    string('repeat(') |
    string('ofType(') |
    string('extension(') |
    string('log(') |
    string('power(') |
    string('round(') |
    string('indexOf(') |
    string('substring(') |
    string('startsWith(') |
    string('endsWith(') |
    string('contains(') |
    string('replace(') |
    string('matches(') |
    string('replaceMatches(') |
    string('skip(') |
    string('take(') |
    string('intersect(') |
    string('exclude(') |
    string('trace(') |
    string('aggregate(') |
    string('iif(') |
    string('as(') |
    string('as(') |
    string('sum()') |
    string('min()') |
    string('max()') |
    string('avg()') |
    string('answers()') |
    string('ordinal()') |
    string('toBoolean()') |
    string('convertsToBoolean()') |
    string('toInteger()') |
    string('convertsToInteger()') |
    string('toDate()') |
    string('convertsToDate()') |
    string('toDateTime()') |
    string('convertsToDateTime()') |
    string('toDecimal()') |
    string('convertsToDecimal()') |
    string('toString()') |
    string('convertsToString()') |
    string('toTime()') |
    string('convertsToTime()') |
    string('hasValue()') |
    string('empty()') |
    string('allTrue()') |
    string('anyTrue()') |
    string('allFalse()') |
    string('anyFalse()') |
    string('count()') |
    string('distinct()') |
    string('isDistinct()') |
    string('abs()') |
    string('ceiling()') |
    string('exp()') |
    string('floor()') |
    string('ln()') |
    string('sqrt()') |
    string('truncate()') |
    string('upper()') |
    string('lower()') |
    string('length()') |
    string('toChars()') |
    string('single()') |
    string('first()') |
    string('laexecutedAfter.firstst()') |
    string('tail()') |
    string('children()') |
    string('descendants()') |
    string('not()') |
    string('now()') |
    string('timeOfDay()') |
    string('today()');

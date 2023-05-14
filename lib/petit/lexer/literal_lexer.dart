// ignore_for_file: avoid_dynamic_calls

// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:petitparser/petitparser.dart';

// Project imports:
import '../petit_fhir_path.dart';

/******************************************************************************
 *  Most of these Lexers specify basic literals as defined in the FHIRPath
 * grammar that can be seen here: http://hl7.org/fhirpath/grammar.html
 * ***************************************************************************/

/// White Space
final Parser<WhiteSpaceParser> whiteSpaceLexer =
    ((string('\r') | string('\n') | string('\t') | char(' ')).plus())
        .flatten()
        .map((String value) => WhiteSpaceParser(value));

/// Single Line Comment
final Parser<WhiteSpaceParser> lineCommentLexer =
    (string('//') & (string('\r') | string('\n')).neg().star())
        .flatten()
        .map((String value) => WhiteSpaceParser(value));

/// Multiline Comment
final Parser<WhiteSpaceParser> multiLineCommentLexer =
    (string('/*') & any().star().and() & string('*/'))
        .flatten()
        .map((String value) => WhiteSpaceParser(value));

/// Finds strings 'true' or 'false' (without quotes)
final Parser<BooleanParser> booleanLexer = (string('true') | string('false'))
    .flatten()
    .map((String value) => BooleanParser(value));

/// Allows environmental variables to be passed to FHIRPath
final Parser<EnvVariableParser> envVariableLexer =
    (char('%') & (identifierLexer | delimitedIdentifierLexer))
        .flatten()
        .map((String value) => EnvVariableParser(value));

final Parser<QuantityParser> quantityLexer =
    (numberLexer & char(' ') & (durationLexer | stringLexer))
        .flatten()
        .map((String value) => QuantityParser(value));

final ChoiceParser<dynamic> numberLexer = decimalLexer | integerLexer;

final Parser<DecimalParser> decimalLexer =
    (digit().plus() & char('.') & digit().plus())
        .flatten()
        .map((String value) => DecimalParser(value));

final Parser<IntegerParser> integerLexer =
    digit().plus().flatten().map((String value) => IntegerParser(value));

/// A String is signified by single quotes (') on either end
final Parser<StringParser> stringLexer =
    (char("'") & (escLexer | char("'").neg()).star() & char("'"))
        .map((List<dynamic> value) {
  final dynamic middleValue = value[1]
      .map((dynamic e) => e is Token
          ? e.value.contains('u') as bool
              ? utf8.decode(<int>[
                  int.parse(e.value.split('u').last as String, radix: 16)
                ])
              : e.value.replaceAll(r"\', r'\")
          : e == r'\'
              ? ''
              : e)
      .join('');
  return StringParser('${value[0]}$middleValue${value[2]}');
});

/// An Identifier has no quotes
final Parser<IdentifierParser> identifierLexer =
    ((pattern('A-Za-z') | char('_')) &
            (pattern('A-Za-z0-9') | char('_')).star())
        .flatten()
        .map((String value) => IdentifierParser(value));

/// DelimitedIdentifier is signified by a backquote (`) on either end
final Parser<DelimitedIdentifierParser> delimitedIdentifierLexer =
    (char('`') & (escLexer | char('`').neg()).star() & char('`'))
        .map((dynamic value) {
  final dynamic middleValue = value[1]
      .map((dynamic e) => e is Token
          ? e.value.contains('u') as bool
              ? utf8.decode(<int>[
                  int.parse(e.value.split('u').last as String, radix: 16)
                ])
              : e.value.replaceAll(r"\', r'\")
          : e == r'\'
              ? ''
              : e)
      .join('');
  return DelimitedIdentifierParser('${value[0]}$middleValue${value[2]}');
});

final Parser<Token<String>> escLexer = (char(r'\') &
        (char('`') |
            char("'") |
            char(r'"') |
            char(r'\') |
            char('/') |
            char('f') |
            char('n') |
            char('r') |
            char('t') |
            unicodeLexer))
    .flatten()
    .token();

final Parser<Token<String>> unicodeLexer =
    (char('u') & hexLexer & hexLexer & hexLexer & hexLexer).flatten().token();

final Parser<Token<String>> hexLexer = pattern('0-9a-fA-F').flatten().token();

/// Follows DateTime format specified in FHIRPath (I have also updated the FHIR)
/// package to follow many of these guidelines
final Parser<DateTimeParser> dateTimeLexer = (char('@') &
        dateFormatLexer &
        char('T') &
        (timeFormatLexer & timeZoneOffsetFormatLexer.optional()).optional())
    .flatten()
    .map((String value) => DateTimeParser(value));

/// Follows Date format specified in FHIRPath
final Parser<DateParser> dateLexer = (char('@') & dateFormatLexer)
    .flatten()
    .map((String value) => DateParser(value));

/// Follows Time format specified in FHIRPath
final Parser<TimeParser> timeLexer = (char('@') & char('T') & timeFormatLexer)
    .flatten()
    .map((String value) => TimeParser(value));

final Parser<Token<String>> dateFormatLexer = (digit() &
        digit() &
        digit() &
        digit() &
        (char('-') &
                digit() &
                digit() &
                (char('-') & digit() & digit()).optional())
            .optional())
    .flatten()
    .token();

final Parser<Token<String>> timeFormatLexer = (digit() &
        digit() &
        (char(':') &
                digit() &
                digit() &
                (char(':') &
                        digit() &
                        digit() &
                        (char('.') & digit().plus()).optional())
                    .optional())
            .optional())
    .flatten()
    .token();

final Parser<Token<String>> timeZoneOffsetFormatLexer = (char('Z') |
        ((char('+') | char('-')) &
            digit() &
            digit() &
            char(':') &
            digit() &
            digit()))
    .flatten()
    .token();

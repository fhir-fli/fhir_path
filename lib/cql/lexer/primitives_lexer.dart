// Dart imports:
import 'dart:convert';

import 'package:petitparser/petitparser.dart';

import '../../fhir_path.dart';
import '../parser/parser.dart';
import 'lexer.dart';

final Parser<TypeNameIdentifierParser> typeNameIdentifierLexer =
    (string('Code') | string('Concept') | string('date') | string('time'))
        .map((value) => TypeNameIdentifierParser(value));

final referentialIdentifierLexer = cqlIdentifierLexer |
    keywordIdentifierLexer.map((value) {
      return value;
    });

final referentialOrTypeNameIdentifierLexer = referentialIdentifierLexer |
    typeNameIdentifierLexer.map((value) {
      return value;
    });

final identifierOrFunctionIdentifierLexer = cqlIdentifierLexer |
    functionIdentifierLexer.map((value) {
      return value;
    });

final cqlIdentifierLexer =
    identifierLexer | delimitedIdentifierLexer | quotedIdentifierLexer;

/// QuotedIdentifier is signified by a double quote (") on either end
final Parser<QuotedIdentifierParser> quotedIdentifierLexer =
    (char('"') & (escLexer | char('"').neg()).star() & char('"')).map((value) {
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
  final newValue = '${value[0]}$middleValue${value[2]}';
  return QuotedIdentifierParser(newValue.substring(1, newValue.length - 1));
});

final Parser<CqlDateTimeParser> cqlDateTimeLexer = (char('@') &
        dateFormatLexer &
        char('T') &
        timeFormatLexer.optional() &
        timeZoneOffsetFormatLexer.optional())
    .flatten()
    .map((value) => CqlDateTimeParser(value));

final Parser<LongNumberParser> longNumberLexer = (digit().plus() & char('L'))
    .flatten()
    .map((value) => LongNumberParser(value));

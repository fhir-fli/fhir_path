// ignore_for_file: avoid_dynamic_calls
import 'package:petitparser/petitparser.dart';

import 'lexer.dart';

/// Primary lexing function for this library
Parser typeSpecifierLexer() {
  print('TYPESPECIFIERLEXER');
  final typeSpecifierLexer = undefined();
  final listTypeSpecifierLexer = undefined();
  final intervalTypeSpecifierLexer = undefined();
  final tupeElementDefintionLexer = undefined();
  final tupleTypeSpecifierLexer = undefined();
  final choiceTypeSpecifierLexer = undefined();

  final typeSpecifierLexerPart = namedTypeSpecifierLexer |
      listTypeSpecifierLexer |
      intervalTypeSpecifierLexer |
      tupleTypeSpecifierLexer |
      choiceTypeSpecifierLexer;

  final listTypeSpecifierLexerPart =
      string('list') & char('<') & typeSpecifierLexerPart & char('>');

  final intervalTypeSpecifierLexerPart =
      string('Interval') & char('<') & typeSpecifierLexerPart & char('>');

  final tupleElementDefintionLexerPart =
      referentialIdentifierLexer & typeSpecifierLexerPart;

  final tupleTypeSpecifierLexerPart = string('Tuple') &
      char('{') &
      tupleElementDefintionLexerPart &
      (char(',') & tupleElementDefintionLexerPart).star() &
      char('}');

  final choiceTypeSpecifierLexerPart = string('Choice') &
      char('<') &
      typeSpecifierLexerPart &
      (char(',') & typeSpecifierLexerPart).star() &
      char('>');

  typeSpecifierLexer.set(typeSpecifierLexerPart);
  listTypeSpecifierLexer.set(listTypeSpecifierLexerPart);
  intervalTypeSpecifierLexer.set(intervalTypeSpecifierLexerPart);
  tupeElementDefintionLexer.set(tupleElementDefintionLexerPart);
  tupleTypeSpecifierLexer.set(tupleTypeSpecifierLexerPart);
  choiceTypeSpecifierLexer.set(choiceTypeSpecifierLexerPart);

  return typeSpecifierLexer;
}

final namedTypeSpecifierLexer = (cqlIdentifierLexer & char('.')).optional() &
    referentialOrTypeNameIdentifierLexer;

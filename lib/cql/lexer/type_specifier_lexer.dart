// ignore_for_file: avoid_dynamic_calls
import 'package:petitparser/petitparser.dart';

import 'lexer.dart';

/// Primary lexing function for this library
Parser typeSpecifierLexer() {
  print('TYPESPECIFIERLEXER');
  final typeSpecifierLexer = undefined();
  final listTypeSpecifierLexer = undefined();
  final intervalTypeSpecifierLexer = undefined();
  final tupleElementDefinitionLexer = undefined();
  final tupleTypeSpecifierLexer = undefined();
  final choiceTypeSpecifierLexer = undefined();

  final typeSpecifierLexerPart = namedTypeSpecifierLexer |
      listTypeSpecifierLexer |
      intervalTypeSpecifierLexer |
      tupleTypeSpecifierLexer |
      choiceTypeSpecifierLexer;

  final listTypeSpecifierLexerPart =
      string('list') & char('<') & typeSpecifierLexer & char('>');

  final intervalTypeSpecifierLexerPart =
      string('Interval') & char('<') & typeSpecifierLexer & char('>');

  final tupleElementDefintionLexerPart =
      referentialIdentifierLexer & typeSpecifierLexer;

  final tupleTypeSpecifierLexerPart = string('Tuple') &
      char('{') &
      tupleElementDefinitionLexer &
      (char(',') & tupleElementDefinitionLexer).star() &
      char('}');

  final choiceTypeSpecifierLexerPart = string('Choice') &
      char('<') &
      typeSpecifierLexer &
      (char(',') & typeSpecifierLexer).star() &
      char('>');

  typeSpecifierLexer.set(typeSpecifierLexerPart);
  listTypeSpecifierLexer.set(listTypeSpecifierLexerPart);
  intervalTypeSpecifierLexer.set(intervalTypeSpecifierLexerPart);
  tupleElementDefinitionLexer.set(tupleElementDefintionLexerPart);
  tupleTypeSpecifierLexer.set(tupleTypeSpecifierLexerPart);
  choiceTypeSpecifierLexer.set(choiceTypeSpecifierLexerPart);

  return typeSpecifierLexer;
}

final namedTypeSpecifierLexer = (cqlIdentifierLexer & char('.')).optional() &
    referentialOrTypeNameIdentifierLexer;

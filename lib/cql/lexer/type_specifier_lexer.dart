// ignore_for_file: avoid_dynamic_calls
import 'package:petitparser/petitparser.dart';

import 'lexer.dart';

/// Primary lexing function for this library
Parser typeSpecifierLexer() {
  final typeSpecifierLexer = undefined();
  final listTypeSpecifierLexer = undefined();
  final intervalTypeSpecifierLexer = undefined();
  final tupleElementDefinitionLexer = undefined();
  final tupleTypeSpecifierLexer = undefined();
  final choiceTypeSpecifierLexer = undefined();

  final typeSpecifierLexerPart = listTypeSpecifierLexer |
      intervalTypeSpecifierLexer |
      tupleTypeSpecifierLexer |
      choiceTypeSpecifierLexer |
      namedTypeSpecifierLexer;
  typeSpecifierLexer.set(typeSpecifierLexerPart);

  final listTypeSpecifierLexerPart =
      string('list') & char('<') & typeSpecifierLexer & char('>');
  listTypeSpecifierLexer.set(listTypeSpecifierLexerPart);

  final intervalTypeSpecifierLexerPart =
      string('Interval') & char('<') & typeSpecifierLexer & char('>');
  intervalTypeSpecifierLexer.set(intervalTypeSpecifierLexerPart);

  final tupleElementDefintionLexerPart =
      referentialIdentifierLexer & typeSpecifierLexer;
  tupleElementDefinitionLexer.set(tupleElementDefintionLexerPart);

  final tupleTypeSpecifierLexerPart = string('Tuple') &
      char('{') &
      tupleElementDefinitionLexer &
      (char(',') & tupleElementDefinitionLexer).star() &
      char('}');
  tupleTypeSpecifierLexer.set(tupleTypeSpecifierLexerPart);

  final choiceTypeSpecifierLexerPart = string('Choice') &
      char('<') &
      typeSpecifierLexer &
      (char(',') & typeSpecifierLexer).star() &
      char('>');
  choiceTypeSpecifierLexer.set(choiceTypeSpecifierLexerPart);

  return typeSpecifierLexer;
}

final namedTypeSpecifierLexer = (cqlIdentifierLexer & char('.')).optional() &
    referentialOrTypeNameIdentifierLexer;

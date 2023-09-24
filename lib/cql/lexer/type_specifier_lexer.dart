// ignore_for_file: avoid_dynamic_calls
import 'package:petitparser/petitparser.dart';

import 'lexer.dart';

/// Primary lexing function for this library
Parser typeSpecifierLexer() {
  final typeSpecifierLexer = undefined();
  final typeSpecifierLexerPart = namedTypeSpecifierLexer |
      listTypeSpecifierLexer |
      intervalTypeSpecifierLexer |
      tupleTypeSpecifierLexer |
      choiceTypeSpecifierLexer;

  typeSpecifierLexer.set(typeSpecifierLexerPart);
  return typeSpecifierLexer;
}

final namedTypeSpecifierLexer = (qualifierLexer & char('.')).optional() &
    referentialOrTypeNameIdentifierLexer;

final modelIdentifierLexer = cqlIdentifierLexer;

final listTypeSpecifierLexer =
    string('list') & char('<') & typeSpecifierLexer() & char('>');

final intervalTypeSpecifierLexer =
    string('Interval') & char('<') & typeSpecifierLexer() & char('>');

final tupleElementDefintionLexer =
    referentialIdentifierLexer & typeSpecifierLexer();

final tupleTypeSpecifierLexer = string('Tuple') &
    char('{') &
    tupleElementDefintionLexer &
    (char(',') & tupleElementDefintionLexer).star() &
    char('}');

final choiceTypeSpecifierLexer = string('Choice') &
    char('<') &
    typeSpecifierLexer() &
    (char(',') & typeSpecifierLexer()).star() &
    char('>');

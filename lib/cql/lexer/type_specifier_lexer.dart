// ignore_for_file: avoid_dynamic_calls
import 'package:petitparser/petitparser.dart';

import 'lexer.dart';

final typeSpecifierLexer = namedTypeSpecifierLexer |
    listTypeSpecifierLexer |
    intervalTypeSpecifierLexer |
    tupleTypeSpecifierLexer |
    choiceTypeSpecifierLexer;

final namedTypeSpecifierLexer = (qualifierLexer & char('.')).optional() &
    referentialOrTypeNameIdentifierLexer;

final modelIdentifierLexer = cqlIdentifierLexer;

final listTypeSpecifierLexer =
    string('list') & char('<') & typeSpecifierLexer & char('>');

final intervalTypeSpecifierLexer =
    string('Interval') & char('<') & typeSpecifierLexer & char('>');

final tupleTypeSpecifierLexer = string('Tuple') &
    char('{') &
    tupleElementDefintionLexer &
    (char(',') & tupleElementDefintionLexer).star() &
    char('}');

final tupleElementDefintionLexer =
    referentialIdentifierLexer & typeSpecifierLexer;

final choiceTypeSpecifierLexer = string('Choice') &
    char('<') &
    typeSpecifierLexer &
    (char(',') & typeSpecifierLexer).star() &
    char('>');

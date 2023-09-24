import 'package:petitparser/petitparser.dart';

import 'lexer.dart';

final statementLexer = expressionDefinitionLexer |
    contextDefinitionLexer |
    functionDefinitionLexer;

final expressionDefinitionLexer = string('define') &
    accessModifierLexer.optional() &
    cqlIdentifierLexer &
    char(':') &
    cqlExpressionLexer();

final contextDefinitionLexer = string('context') &
    (typeSpecifierLexer() & char('.')).optional() &
    cqlIdentifierLexer;

final functionDefinitionLexer = string('define') &
    accessModifierLexer.optional() &
    string('fluent').optional() &
    string('function') &
    identifierOrFunctionIdentifierLexer &
    char('(') &
    (operandDefinitionLexer & (char(',') & operandDefinitionLexer).star())
        .optional() &
    char(')') &
    (string('returns') & typeSpecifierLexer()).optional() &
    char(':') &
    (functionBodyLexer | string('external'));

final operandDefinitionLexer =
    referentialIdentifierLexer & typeSpecifierLexer();

final functionBodyLexer = cqlExpressionLexer();

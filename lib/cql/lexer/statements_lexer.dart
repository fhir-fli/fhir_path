import 'package:fhir_path/cql/lexer/lexer.dart';
import 'package:petitparser/petitparser.dart';

final statementLexer = expressionDefinitionLexer |
    contextDefinitionLexer |
    functionDefinitionLexer;

final expressionDefinitionLexer = string('define') &
    accessModifierLexer.optional() &
    cqlIdentifierLexer &
    char(':') &
    expressionLexer;

final contextDefinitionLexer = string('context') &
    (modelIdentifierLexer & char('.')).optional() &
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
    (string('returns') & typeSpecifierLexer).optional() &
    char(':') &
    (functionBodyLexer | string('external'));

final operandDefinitionLexer = referentialIdentifierLexer & typeSpecifierLexer;

final functionBodyLexer = expressionLexer;

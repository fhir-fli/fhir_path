import 'package:petitparser/petitparser.dart';

import '../../fhir_path.dart';
import 'lexer.dart';

final statementLexer = expressionDefinitionLexer |
    contextDefinitionLexer |
    functionDefinitionLexer;

final expressionDefinitionLexer = string('define') &
    (whiteSpaceLexer & accessModifierLexer).optional() &
    whiteSpaceLexer &
    cqlIdentifierLexer &
    whiteSpaceLexer.optional() &
    char(':') &
    whiteSpaceLexer.optional() &
    cqlExpressionLexer();

final contextDefinitionLexer = string('context') &
    whiteSpaceLexer &
    (modelIdentifierLexer & char('.')).optional() &
    cqlIdentifierLexer;

final functionDefinitionLexer = string('define') &
    (whiteSpaceLexer & accessModifierLexer).optional() &
    (whiteSpaceLexer & string('fluent')).optional() &
    whiteSpaceLexer &
    string('function') &
    whiteSpaceLexer &
    cqlIdentifierLexer &
    whiteSpaceLexer.optional() &
    char('(') &
    whiteSpaceLexer.optional() &
    (operandDefinitionLexer &
            (whiteSpaceLexer.optional() &
                    char(',') &
                    whiteSpaceLexer.optional() &
                    operandDefinitionLexer)
                .star())
        .optional() &
    whiteSpaceLexer.optional() &
    char(')') &
    whiteSpaceLexer.optional() &
    (string('returns') & whiteSpaceLexer & typeSpecifierLexer()).optional() &
    whiteSpaceLexer.optional() &
    char(':') &
    whiteSpaceLexer.optional() &
    (functionBodyLexer | string('external'));

final operandDefinitionLexer =
    referentialIdentifierLexer & whiteSpaceLexer & typeSpecifierLexer();

final functionBodyLexer = cqlExpressionLexer();

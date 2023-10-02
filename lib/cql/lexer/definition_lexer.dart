import 'package:petitparser/petitparser.dart';

import '../../fhir_path.dart';
import 'lexer.dart';

final definitionLexer = usingDefinitionLexer |
    includeDefinitionLexer |
    codesystemDefinitionLexer |
    valuesetDefinitionLexer |
    codeDefinitionLexer |
    conceptDefinitionLexer |
    parameterDefinitionLexer;

final usingDefinitionLexer = string('using') &
    whiteSpaceLexer &
    modelIdentifierLexer &
    (whiteSpaceLexer &
            string('version') &
            whiteSpaceLexer &
            versionSpecifierLexer)
        .optional();

final modelIdentifierLexer = cqlIdentifierLexer;

final includeDefinitionLexer = string('include') &
    whiteSpaceLexer &
    qualifiedIdentifierLexer &
    (whiteSpaceLexer &
            string('version') &
            whiteSpaceLexer &
            versionSpecifierLexer)
        .optional() &
    (whiteSpaceLexer &
            string('called') &
            whiteSpaceLexer &
            localIdentifierLexer)
        .optional();

final localIdentifierLexer = cqlIdentifierLexer;

final codesystemDefinitionLexer =
    (accessModifierLexer & whiteSpaceLexer).optional() &
        string('codesystem') &
        whiteSpaceLexer &
        cqlIdentifierLexer &
        whiteSpaceLexer.optional() &
        char(':') &
        whiteSpaceLexer.optional() &
        codesystemIdLexer &
        (whiteSpaceLexer &
                string('version') &
                whiteSpaceLexer &
                versionSpecifierLexer)
            .optional();

final accessModifierLexer = string('public') | string('private');

final codesystemIdLexer = stringLexer;

final valuesetDefinitionLexer =
    (accessModifierLexer & whiteSpaceLexer).optional() &
        string('valueset') &
        whiteSpaceLexer &
        cqlIdentifierLexer &
        whiteSpaceLexer.optional() &
        char(':') &
        whiteSpaceLexer.optional() &
        valuesetIdLexer &
        (whiteSpaceLexer &
                string('version') &
                whiteSpaceLexer &
                versionSpecifierLexer)
            .optional() &
        (whiteSpaceLexer & codesystemsLexer).optional();

final valuesetIdLexer = stringLexer;

final codesystemsLexer = string('codesystems') &
    whiteSpaceLexer.optional() &
    char('{') &
    whiteSpaceLexer.optional() &
    codesystemIdentifierLexer &
    (whiteSpaceLexer.optional() &
            char(',') &
            whiteSpaceLexer.optional() &
            codesystemIdentifierLexer)
        .star() &
    whiteSpaceLexer.optional() &
    char('}');

final codesystemIdentifierLexer =
    (libraryIdentifierLexer & char('.')).optional() & cqlIdentifierLexer;

final libraryIdentifierLexer = cqlIdentifierLexer;

final codeDefinitionLexer = (accessModifierLexer & whiteSpaceLexer).optional() &
    string('code') &
    whiteSpaceLexer &
    cqlIdentifierLexer &
    whiteSpaceLexer.optional() &
    char(':') &
    whiteSpaceLexer.optional() &
    char('{') &
    whiteSpaceLexer.optional() &
    codeIdentifierLexer &
    (whiteSpaceLexer.optional() &
            char(',') &
            whiteSpaceLexer.optional() &
            codeIdentifierLexer)
        .star() &
    whiteSpaceLexer.optional() &
    char('}') &
    whiteSpaceLexer.optional() &
    displayClauseLexer.optional();

final codeIdentifierLexer =
    (libraryIdentifierLexer & char('.')).optional() & cqlIdentifierLexer;

final displayClauseLexer = string('display') & whiteSpaceLexer & stringLexer;

final conceptDefinitionLexer =
    (accessModifierLexer & whiteSpaceLexer).optional() &
        string('concept') &
        whiteSpaceLexer &
        cqlIdentifierLexer &
        whiteSpaceLexer.optional() &
        char(':') &
        whiteSpaceLexer.optional() &
        char('{') &
        whiteSpaceLexer.optional() &
        codeIdentifierLexer &
        (whiteSpaceLexer.optional() &
                char(',') &
                whiteSpaceLexer.optional() &
                codeIdentifierLexer)
            .star() &
        whiteSpaceLexer.optional() &
        char('}') &
        whiteSpaceLexer.optional() &
        displayClauseLexer.optional();

final parameterDefinitionLexer =
    (accessModifierLexer & whiteSpaceLexer).optional() &
        string('parameter') &
        whiteSpaceLexer &
        cqlIdentifierLexer &
        // (whiteSpaceLexer & typeSpecifierLexer('default'))
        //     .optional()
        //     .flatten()
        //     .map((value) => print('TS: $value')) &
        (whiteSpaceLexer & string('default') & whiteSpaceLexer
            // &
            // intervalSelectorPart
            // cqlExpressionLexer()
            )
            .optional();

final intervalSelectorPart =

    /// TODO: Consider this as an alternative syntax for intervals... (would need to be moved up to
    /// expression to make it work) expression ( '..' | '*.' | '.*' | '**' ) expression;
    string('Interval') &
        whiteSpaceLexer.optional() &
        (char('[') | char('(')) &
        whiteSpaceLexer.optional() &
        any().star() &
        // cqlExpression &
        whiteSpaceLexer.optional() &
        char(',') &
        whiteSpaceLexer.optional() &
        any().star() &
        // cqlExpression &
        whiteSpaceLexer.optional() &
        (char(']') | char(')'));

import 'package:fhir_path/cql/lexer/lexer.dart';
import 'package:petitparser/petitparser.dart';

import '../../fhir_path.dart';
import '../parser/parser.dart';

final Parser<LibraryDefinitionParser> libraryDefinitionLexer =
    (string('library') &
            qualifiedIdentifierLexer &
            (string('version') & versionSpecifierLexer).optional())
        .map((value) => LibraryDefinitionParser(value[1].toString(),
            value.length > 2 ? value[3].toString() : null));

final Parser<UsingDefinitionParser> usingDefinitionLexer = (string('library') &
        qualifiedIdentifierLexer &
        (string('version') & versionSpecifierLexer).optional())
    .map((value) => UsingDefinitionParser(
        value[1].toString(), value.length > 2 ? value[3].toString() : null));

final Parser<IncludeDefinitionParser> includeDefinitionLexer =
    (string('include') &
            qualifiedIdentifierLexer &
            (string('version') & versionSpecifierLexer).optional() &
            (string('called') & localIdentifierLexer).optional())
        .map((value) => IncludeDefinitionParser(
            value[1].toString(),
            value.length > 2 && value[2].toString() == 'version'
                ? value[3].toString()
                : null,
            value.length > 2 && value[2].toString() == 'called'
                ? value[3].toString()
                : value.length > 4 && value[4].toString() == 'called'
                    ? value[5].toString()
                    : null));

final localIdentifierLexer = cqlIdentifierLexer;

final Parser<AccessModifierParser> accessModifierLexer =
    (string('private') | string('public'))
        .map((value) => AccessModifierParser(value.toString()));

final Parser<ParameterDefinitionParser> parameterDefinitionLexer =
    (accessModifierLexer.optional() &
            string('parameter') &
            cqlIdentifierLexer &
            typeSpecifierLexer().optional() &
            (string('default') & cqlExpressionLexer()).optional())
        .map((value) => ParameterDefinitionParser(
              value[0].toString(),
              value[2].toString(),
              value[3].toString(),
              value[4].toString(),
            ));

final codesystemDefinitionLexer = accessModifierLexer.optional() &
    string('codesystem') &
    cqlIdentifierLexer &
    char(':') &
    codesystemIdLexer &
    (string('version') & versionSpecifierLexer).optional();

final valuesetDefinitionLexer = accessModifierLexer.optional() &
    string('valueset') &
    cqlIdentifierLexer &
    char(':') &
    valuesetIdLexer &
    (string('version') & versionSpecifierLexer).optional() &
    codesystemsLexer.optional();

final codesystemsLexer = string('codesystems') &
    char('{') &
    codesystemIdentifierLexer &
    (char(',') & codesystemIdentifierLexer).star() &
    char('}');

final codesystemIdentifierLexer =
    ((libraryIdentifierLexer & char('.')).optional() & cqlIdentifierLexer)
        .map((value) => null);

final libraryIdentifierLexer = cqlIdentifierLexer;

final codeDefinitionLexer = accessModifierLexer.optional() &
    string('code') &
    cqlIdentifierLexer &
    char(':') &
    codeIdLexer &
    string('from') &
    codesystemIdentifierLexer &
    displayClauseLexer.optional();

final conceptDefinitionLexer = accessModifierLexer.optional() &
    string('concept') &
    cqlIdentifierLexer &
    char(':') &
    char('{') &
    codeIdentifierLexer &
    (char(',') & codeIdentifierLexer).star() &
    char('}') &
    displayClauseLexer.optional();

final codeIdentifierLexer =
    ((libraryIdentifierLexer & char('.')).optional() & cqlIdentifierLexer)
        .map((value) => null);

final codesystemIdLexer = stringLexer;

final valuesetIdLexer = stringLexer;

final versionSpecifierLexer = stringLexer;

final codeIdLexer = stringLexer;

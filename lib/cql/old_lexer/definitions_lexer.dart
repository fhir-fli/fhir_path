import 'package:fhir_path/cql/old_lexer/lexer.dart';
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
    .map((value) {
  print('UsingDefinitionParser: $value');
  return UsingDefinitionParser(
      value[1].toString(), value.length > 2 ? value[3].toString() : null);
});

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

final Parser<QualifiedIdentifierParser> qualifiedIdentifierLexer =
    ((qualifierLexer & char('.')).star() & cqlIdentifierLexer).map((value) =>
        QualifiedIdentifierParser(
            value.length == 1 ? null : value[0].toString(),
            value.last.toString()));

final qualifierLexer = cqlIdentifierLexer;

final Parser<AccessModifierParser> accessModifierLexer =
    (string('private') | string('public'))
        .map((value) => AccessModifierParser(value.toString()));

final codesystemDefinitionLexer = accessModifierLexer.optional() &
    string('codesystem') &
    cqlIdentifierLexer &
    char(':') &
    codesystemIdLexer &
    (string('version') & versionSpecifierLexer).optional().map((value) {
      print(value);
      return value;
    });

final valuesetDefinitionLexer = accessModifierLexer.optional() &
    string('valueset') &
    cqlIdentifierLexer &
    char(':') &
    valuesetIdLexer &
    (string('version') & versionSpecifierLexer).optional() &
    codesystemsLexer.optional().map((value) {
      print(value);
      return value;
    });

final codesystemsLexer = string('codesystems') &
    char('{') &
    codesystemIdentifierLexer &
    (char(',') & codesystemIdentifierLexer).star() &
    char('}').map((value) {
      print(value);
      return value;
    });

final codesystemIdentifierLexer =
    ((libraryIdentifierLexer & char('.')).optional() & cqlIdentifierLexer)
        .map((value) => null)
        .map((value) {
  print(value);
  return value;
});

final libraryIdentifierLexer = cqlIdentifierLexer.map((value) {
  print(value);
  return value;
});

final codeDefinitionLexer = accessModifierLexer.optional() &
    string('code') &
    cqlIdentifierLexer &
    char(':') &
    codeIdLexer &
    string('from') &
    codesystemIdentifierLexer &
    displayClauseLexer.optional().map((value) {
      print(value);
      return value;
    });

final conceptDefinitionLexer = accessModifierLexer.optional() &
    string('concept') &
    cqlIdentifierLexer &
    char(':') &
    char('{') &
    codeIdentifierLexer &
    (char(',') & codeIdentifierLexer).star() &
    char('}') &
    displayClauseLexer.optional().map((value) {
      print(value);
      return value;
    });

final codeIdentifierLexer =
    ((libraryIdentifierLexer & char('.')).optional() & cqlIdentifierLexer)
        .map((value) => null)
        .map((value) {
  print(value);
  return value;
});

final codesystemIdLexer = stringLexer.map((value) {
  print(value);
  return value;
});

final valuesetIdLexer = stringLexer.map((value) {
  print(value);
  return value;
});

final versionSpecifierLexer = stringLexer.map((value) {
  print(value);
  return value;
});

final codeIdLexer = stringLexer.map((value) {
  print(value);
  return value;
});

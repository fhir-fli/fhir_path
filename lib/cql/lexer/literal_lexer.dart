// Dart imports:
import 'dart:convert';

import 'package:petitparser/petitparser.dart';

import '../../fhir_path.dart';
import '../parser/parser.dart';

final Parser<IncludeDefinitionParser> includeDefinitionLexer =
    (string('include') &
            qualifiedIdentifierLexer &
            (string('version') & versionLexer).optional() &
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

final Parser<UsingDefinitionParser> usingDefinitionLexer = (string('using') &
        modelIdentifierLexer &
        (string('version') & versionLexer).optional())
    .map((value) => UsingDefinitionParser(
        value[1].toString(), value.length > 2 ? value[3].toString() : null));

final modelIdentifierLexer = cqlIdentifierLexer;

final Parser<LibraryDefinitionParser> libraryDefinitionLexer =
    (string('library') &
            qualifiedIdentifierLexer &
            (string('version') & versionLexer).optional())
        .map((value) => LibraryDefinitionParser(value[1].toString(),
            value.length > 2 ? value[3].toString() : null));

final versionLexer = stringLexer;

final Parser<QualifiedIdentifierParser> qualifiedIdentifierLexer =
    ((qualifierLexer & char('.')).star() & cqlIdentifierLexer).map((value) =>
        QualifiedIdentifierParser(
            value.length == 1 ? null : value[0].toString(),
            value.last.toString()));

final qualifierLexer = cqlIdentifierLexer;

final identifierOrFunctionIdentifierLexer = cqlIdentifierLexer
// TODO(Dokotela)  | functionIdentifierLexer
    ;

/// Just a reminder, identifierLexer are numbers, letters, or underscores.
/// delimitedIdentifierLexer are identifiers surrounded by backticks (`).
/// quotedIdentifierLexer are identifiers surrounded by double quotes (").
/// However, we remove them when we identify them, so if they're used in other
/// places, these should be removed.
final cqlIdentifierLexer =
    identifierLexer | delimitedIdentifierLexer | quotedIdentifierLexer;

/// QuotedIdentifier is signified by a double quote (") on either end
final Parser<QuotedIdentifierParser> quotedIdentifierLexer =
    (char('"') & (escLexer | char('"').neg()).star() & char('"')).map((value) {
  final middleValue = value[1]
      .map((e) => e is Token
          ? e.value.contains('u') as bool
              ? utf8.decode(
                  [int.parse(e.value.split('u').last as String, radix: 16)])
              : e.value.replaceAll(r'\\', r'\')
          : e == r'\'
              ? ''
              : e)
      .join('');
  final newValue = '${value[0]}$middleValue${value[2]}';
  return QuotedIdentifierParser(newValue.substring(1, newValue.length - 1));
});

final Parser<CqlDateTimeParser> cqlDateTimeLexer = (char('@') &
        dateFormatLexer &
        char('T') &
        timeFormatLexer.optional() &
        timeZoneOffsetFormatLexer.optional())
    .flatten()
    .map((value) => CqlDateTimeParser(value));

final Parser<LongNumberParser> longNumberLexer = (digit().plus() & char('L'))
    .flatten()
    .map((value) => LongNumberParser(value));

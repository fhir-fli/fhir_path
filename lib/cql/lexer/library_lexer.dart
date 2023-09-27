import 'package:petitparser/petitparser.dart';

import '../../fhir_path.dart';
import 'lexer.dart';

final libraryDefinitionLexer = string('library') &
    whiteSpaceLexer &
    qualifiedIdentifierLexer &
    (whiteSpaceLexer &
            string('version') &
            whiteSpaceLexer &
            versionSpecifierLexer)
        .optional();

final qualifiedIdentifierLexer =
    (qualifierLexer & char('.')).star() & cqlIdentifierLexer;

final qualifierLexer = cqlIdentifierLexer;

final versionSpecifierLexer = stringLexer;

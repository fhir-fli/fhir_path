// Dart imports:
import 'package:petitparser/petitparser.dart';

import '../parser/parser.dart';
import 'lexer.dart';

final Parser<QualifiedIdentifierParser> qualifiedIdentifierLexer =
    ((qualifierLexer & char('.')).star() & cqlIdentifierLexer).map((value) =>
        QualifiedIdentifierParser(
            value.length == 1 ? null : value[0].toString(),
            value.last.toString()));

final qualifierLexer = cqlIdentifierLexer;

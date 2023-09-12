// Package imports:
import 'package:petitparser/petitparser.dart';
import 'package:fhir_path/cql/lexer/lexer.dart';

/// Lexers identifying special formatting of certain types of data
final literalLexer = cqlIdentifierLexer | cqlDateTimeLexer | longNumberLexer;

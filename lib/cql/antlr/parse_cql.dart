// Package imports:
import 'package:antlr4/antlr4.dart';

// Project imports:
import 'antlr_cql.dart';

/// Parse a FHIRPath for repeated use with different inputs later.
LibraryContext parseCql(String cqlExpression) {
  try {
    final input = InputStream.fromString(cqlExpression);
    final lexer = cqlLexer(input);
    final tokens = CommonTokenStream(lexer);
    final parser = cqlParser(tokens);
    parser.buildParseTree = true;
    final tree = parser.library_();
    return tree;
  } catch (error) {
    // print(error.runtimeType);
    // if (error is ParserException) {
    //   throw FhirPathInvalidExpressionException(
    //     'Expression could not be parsed: ${error.message}',
    //     pathExpression: pathExpression,
    //     offset: error.offset,
    //     cause: error,
    //   );
    // } else {
    rethrow;
    // }
  }
}

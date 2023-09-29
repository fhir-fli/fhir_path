// ignore_for_file: avoid_dynamic_calls

import 'package:petitparser/petitparser.dart';

import '../../fhir_path.dart';
import 'lexer.dart';

/// Primary lexing function for this library
Parser<FhirPathParser> cqlLexer() {
  return (libraryDefinitionLexer.optional() &
          (whiteSpaceLexer & ignoredLexer & definitionLexer).star()

          // (whiteSpaceLexer & ignoredLexer & statementLexer).star()
          &
          ignoredLexer)
      .end()
      .map((value) {
    value.forEach((element) {
      if (element is List && element.isNotEmpty) {
        final lastElement = element.last;
        if (lastElement is List) {
          final lastElementSquared = lastElement.last;
          // print(lastElementSquared);
        }
      }
    });
    return ParserList([]);
  });
}

final ignoredLexer =
    (whiteSpaceLexer | lineCommentLexer | multiLineCommentLexer).star();

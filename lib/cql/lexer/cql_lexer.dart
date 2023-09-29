// ignore_for_file: avoid_dynamic_calls

import 'package:petitparser/petitparser.dart';

import '../../fhir_path.dart';
import 'lexer.dart';

/// Primary lexing function for this library
Parser<FhirPathParser> cqlLexer() {
  return (libraryDefinitionLexer.optional() &
          (whiteSpaceLexer & ignoredLexer & definitionLexer).star() &
          (whiteSpaceLexer & ignoredLexer & statementLexer).star() &
          whiteSpaceLexer.optional())
      // .end()
      .map((value) {
    value.forEach((element) {
      if (element is List) {
        final lastElement = element.last;
        if (lastElement is List) {
          final lastElementSquared = lastElement.last;
          print(lastElementSquared);
        }
      }
    });
    return ParserList([]);
  });
}

final ignoredLexer =
    (whiteSpaceLexer | lineCommentLexer | multiLineCommentLexer).star();

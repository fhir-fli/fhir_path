// ignore_for_file: avoid_dynamic_calls

// Package imports:
import 'package:petitparser/petitparser.dart';

import '../../fhir_path.dart';
import 'lexer.dart';

/// Primary lexing function for this library
Parser<FhirPathParser> lexer() {
  final definitionLexer = undefined();

  /// The order of lexing is important, and if/when updated, needs
  /// to be taken into account in order for petiteparser to find
  /// patterns in the correct order
  final definition = usingDefinitionLexer |
      includeDefinitionLexer |
      codesystemDefinitionLexer |
      valuesetDefinitionLexer |
      codeDefinitionLexer |
      conceptDefinitionLexer |
      parameterDefinitionLexer;

  final libraryLexer = (libraryDefinitionLexer.optional() &
          definitionLexer.star() &
          statementLexer.star())
      .plus()
      .end();

  definitionLexer.set(definition);

  /// Complete the lexing and again, passes to operatorValues
  return definitionLexer.plus().end().map((value) => ParserList([]));
}

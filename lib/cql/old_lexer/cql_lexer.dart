// ignore_for_file: avoid_dynamic_calls

// Package imports:
import 'package:petitparser/petitparser.dart';

import '../../fhir_path.dart';

/// Primary lexing function for this library
Parser<FhirPathParser> cqlLexer() {
  ///
  /// Setup all of the lexers that will be used in this function and may be
  /// recursive and so will throw a Stack Overflow exception if we don't manage
  /// them properly
  ///
}

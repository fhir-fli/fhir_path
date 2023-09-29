import 'dart:io';

import 'package:fhir_path/cql/lexer/lexer.dart';
import 'package:petitparser/debug.dart';

import 'cql_lexer.dart';

Future<void> main() async {
  final pathExpression = await File('../examples/chlamydia.cql').readAsString();
  cqlLexer().parse(pathExpression).value;
  // progress(cqlLexer()).parse(pathExpression).value;
  // trace(cqlLexer()).parse(pathExpression).value;
  // cqlExpressionLexer().parse('AgeInYears() >= 16');
}

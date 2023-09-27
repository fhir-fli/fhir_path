import 'dart:io';

import 'package:petitparser/debug.dart';

import 'cql_lexer.dart';

Future<void> main() async {
  final pathExpression = await File('../examples/chlamydia.cql').readAsString();
  print(pathExpression);
  // progress(cqlLexer()).parse(pathExpression).value;
  trace(cqlLexer()).parse(pathExpression).value;
}

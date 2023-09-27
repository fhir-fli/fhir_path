import 'dart:io';

import 'old_cql_lexer.dart';

Future<void> main() async {
  final pathExpression = await File('../examples/chlamydia.cql').readAsString();
  final ast = cqlLexer().parse(pathExpression).value;
}

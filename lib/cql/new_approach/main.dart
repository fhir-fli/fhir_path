import 'dart:io';

import 'package:fhir_path/cql/new_approach/cql_grammar_definition.dart';

Future<void> main() async {
  final librariesDir = Directory('../libraries');
  final librariesFiles = librariesDir.listSync();
  for (final file in librariesFiles) {
    if (file is File) {
      print(file.path);
      final pathExpression = await file.readAsString();
      cqlLexer.parse(pathExpression).value;
    }
  }
  final definitionsDir = Directory('../definitions');
  final definitionsFiles = definitionsDir.listSync();
  int i = 0;
  for (final file in definitionsFiles) {
    if (file is File) {
      print('$i: ${file.path}');
      i++;
      final pathExpression = await file.readAsString();
      cqlLexer.parse(pathExpression).value;
    }
  }
  // final librariesAndDefinitionsDir = Directory('../libraries_and_definitions');
  // final librariesAndDefinitionsFi les = librariesAndDefinitionsDir.listSync();
  // for (final file in librariesAndDef initionsFiles) {
  //   if (file is File) {
  //     print(file.path);
  //     final pathExpression = await file.readAsString();
  //     cqlLexer().parse(pathExpression).value;
  //   }
  // }
  // final pathExpression =
  //     await File('../libraries_and_definitions/CMS55v1_NQF0495.cql')
  //         .readAsString();
  // cqlLexer().parse(pathExpression).value;
  // progress(cqlLexer()).parse(pathExpression).value;
  // trace(cqlLexer()).parse(pathExpression).value;
  // cqlExpressionLexer().parse('AgeInYears() >= 16');
}

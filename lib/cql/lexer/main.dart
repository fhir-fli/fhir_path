import 'dart:io';

import 'package:fhir_path/cql/lexer/lexer.dart';
import 'package:petitparser/petitparser.dart';

import '../../fhir_path.dart';

Future<void> main() async {
  final librariesDir = Directory('../libraries');
  final librariesFiles = librariesDir.listSync();
  for (final file in librariesFiles) {
    if (file is File) {
      print(file.path);
      final pathExpression = await file.readAsString();
      cqlLexer().parse(pathExpression).value;
    }
  }
  final definitionsDir = Directory('../definitions');
  final definitionsFiles = definitionsDir.listSync();
  for (final file in definitionsFiles) {
    if (file is File) {
      print(file.path);
      final pathExpression = await file.readAsString();
      (whiteSpaceLexer & ignoredLexer & definitionLexer)
          .star()
          .parse(pathExpression)
          .value;
    }
  }
  final librariesAndDefinitionsDir = Directory('../libraries_and_definitions');
  final librariesAndDefinitionsFiles = librariesAndDefinitionsDir.listSync();
  for (final file in librariesAndDefinitionsFiles) {
    if (file is File) {
      print(file.path);
      final pathExpression = await file.readAsString();
      cqlLexer().parse(pathExpression).value;
    }
  }
  // final pathExpression =
  //     await File('../libraries_and_definitions/CMS55v1_NQF0495.cql')
  //         .readAsString();
  // cqlLexer().parse(pathExpression).value;
  // progress(cqlLexer()).parse(pathExpression).value;
  // trace(cqlLexer()).parse(pathExpression).value;
  // cqlExpressionLexer().parse('AgeInYears() >= 16');
}

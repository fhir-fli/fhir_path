import 'dart:io';

import 'package:fhir_path/cql/antlr/antlr_cql.dart';

Future<void> main() async {
  final dir = Directory('examples');
  final files = await dir.listSync();
  for (final file in files) {
    print(file.path);
    final cqlFile = await File(file.path).readAsString();
    final tree = parseCql(cqlFile);
    print(tree);
  }
}

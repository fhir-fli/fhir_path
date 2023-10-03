import 'dart:io';

Future<void> main() async {
  final librariesDir = Directory('cooking_with_cql');
  final librariesFiles = librariesDir.listSync();
  for (final file in librariesFiles) {
    if (file is File) {
      // print(file.path);
      final pathExpression = await file.readAsString();
      final pathExpressionLists = pathExpression.split('\n');
      final librariesList = <String>[];
      bool record = false;
      for (final line in pathExpressionLists) {
        if (file.path == 'cooking_with_cql/CalendarVsUCUM.cql') {
          print(line);
        }
        if (record) {
          if (line.startsWith('define') || line.startsWith('context')) {
            await File(file.path.replaceAll('cooking_with_cql', 'definitions'))
                .writeAsString(librariesList.join('\n'));
            break;
          } else {
            librariesList.add(line);
          }
        } else if (line.startsWith('library')) {
          record = true;
        }
      }
    }
  }
}

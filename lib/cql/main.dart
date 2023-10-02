import 'dart:io';

Future<void> main() async {
  final librariesDir = Directory('cooking_with_cql');
  final librariesFiles = librariesDir.listSync();
  for (final file in librariesFiles) {
    if (file is File) {
      print(file.path);
      final pathExpression = await file.readAsString();
      final pathExpressionLists = pathExpression.split('\n');
      final librariesList = <String>[];
      for (final line in pathExpressionLists) {
        if (line.startsWith('library')) {
          librariesList.add(line);
          await File(file.path.replaceAll('cooking_with_cql', 'libraries'))
              .writeAsString(librariesList.join('\n'));
        } else {
          librariesList.add(line);
        }
      }
    }
  }
}

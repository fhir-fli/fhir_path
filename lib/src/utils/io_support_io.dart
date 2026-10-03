import 'dart:io';

/// Creates the file at [path] (and any missing parent directories) if it
/// does not exist yet.
void ensureFileExists(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    file.createSync(recursive: true);
  }
}

/// Appends [content] to the file at [path].
void appendToFile(String path, String content) {
  File(path).writeAsStringSync(content, mode: FileMode.append);
}

/// Writes [content] to the file at [path], replacing any existing content.
void writeFileAsString(String path, String content) {
  File(path).writeAsStringSync(content);
}

/// Reads every regular file directly inside [folder], returning a map of
/// file name (without directory) to file content. Returns an empty map if
/// the directory does not exist.
Map<String, String> listFilesWithContents(String folder) {
  final directory = Directory(folder);
  if (!directory.existsSync()) return {};
  final result = <String, String>{};
  for (final file in directory.listSync().whereType<File>()) {
    result[file.uri.pathSegments.last] = file.readAsStringSync();
  }
  return result;
}

/// Writes [line] to stdout.
void consoleOut(String line) => stdout.writeln(line);

/// Writes [line] to stderr.
void consoleErr(String line) => stderr.writeln(line);

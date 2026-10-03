// ignore_for_file: avoid_print

/// Stub variant of the file-system helpers for platforms without `dart:io`
/// (web, WASM). The real implementation lives in `io_support_io.dart` and is
/// selected by conditional import.
library;

Never _unsupported() => throw UnsupportedError(
      'File access requires dart:io, which is not available on this '
      'platform.',
    );

/// File creation is unavailable on this platform.
void ensureFileExists(String path) => _unsupported();

/// File writing is unavailable on this platform.
void appendToFile(String path, String content) => _unsupported();

/// File writing is unavailable on this platform.
void writeFileAsString(String path, String content) => _unsupported();

/// Directory reading is unavailable on this platform.
Map<String, String> listFilesWithContents(String folder) => _unsupported();

/// Writes [line] to the console.
void consoleOut(String line) => print(line);

/// Writes [line] to the console.
void consoleErr(String line) => print(line);

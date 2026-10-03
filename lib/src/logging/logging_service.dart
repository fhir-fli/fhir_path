import 'package:fhir_path/fhir_path.dart';

// ignore_for_file: avoid_print

/// LoggingService
class LoggingService {
  /// Constructor with optional [debug] parameter. Defaults to `false`.
  LoggingService({this.debug = false});

  /// Whether debugging is enabled.
  final bool debug;

  /// Logs a standard message (always displayed).
  void logMessage(String message) {
    print(message);
  }

  /// Logs a debug message if debugging is enabled.
  void logDebugMessage(LogCategory category, String message) {
    if (debug) {
      print(' -${category.name.toLowerCase()}: $message');
    }
  }

  /// Checks if debugging is enabled.
  bool isDebugLogging() => debug;
}

/// A logger class to handle client requests and responses in different formats.

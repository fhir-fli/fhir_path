import 'dart:convert';

import 'package:fhir_path/src/utils/io_support_stub.dart'
    if (dart.library.io) 'package:fhir_path/src/utils/io_support_io.dart';

/// Logging Class for Client
class ClientLogger {
  /// Constructor
  ClientLogger({
    this.logFilePath,
    this.isHtmlFormat = false,
    this.isTextFormat = false,
  }) {
    if (logFilePath != null) {
      ensureFileExists(logFilePath!);
    }
  }

  /// Path of the log file to write the logs to.
  final String? logFilePath;

  /// Whether to log in HTML format.
  final bool isHtmlFormat;

  /// Whether to log in text format.
  final bool isTextFormat;
  int _requestId = 0;
  String? _lastId;

  /// Number of requests logged.
  int requests = 0;

  /// Logs a request to the server.
  void logRequest(
    String method,
    String url,
    List<String>? headers,
    List<int>? body,
  ) {
    requests++;
    _requestId++;
    _lastId = _requestId.toString();
    final logContent = StringBuffer();

    if (isHtmlFormat) {
      logContent
        ..writeln('<hr/><a name="l$_lastId"> </a><pre>')
        ..writeln('$method $url HTTP/1.0');
      headers?.forEach((header) {
        logContent.writeln(_escapeHtml(header));
      });
      if (body != null) {
        logContent
          ..writeln()
          ..writeln(_escapeHtml(utf8.decode(body)));
      }
      logContent.writeln('</pre>');
    } else if (isTextFormat) {
      logContent
        ..writeln('\r\n--- $_lastId -----------------\r\nRequest: \r\n')
        ..writeln('$method $url HTTP/1.0');
      headers?.forEach((header) {
        if (header.startsWith('Api-Key')) {
          logContent.writeln('Api-Key: xxxxxxxxxxxxxxxx');
        } else {
          logContent.writeln(header);
        }
      });
      if (body != null) {
        logContent
          ..writeln()
          ..writeln(utf8.decode(body));
      }
    } else {
      // Default console log for unexpected requests.
      consoleOut('Unexpected request to server:');
      consoleOut('Method: $method');
      consoleOut('URL: $url');
      headers?.forEach((header) => consoleOut('Header: $header'));
      if (body != null) {
        consoleOut('Body:');
        consoleOut('----');
        consoleOut(utf8.decode(body));
      }
    }

    _writeToLogFile(logContent.toString());
  }

  /// Logs a response from the server.
  void logResponse(
    String outcome,
    List<String>? headers,
    List<int>? body,
    int durationMillis,
  ) {
    final logContent = StringBuffer();

    if (isHtmlFormat) {
      logContent
        ..writeln('<pre>')
        ..writeln(outcome);
      headers?.forEach((header) {
        logContent.writeln(_escapeHtml(header));
      });
      if (body != null) {
        logContent
          ..writeln()
          ..writeln(_escapeHtml(utf8.decode(body)));
      }
      logContent.writeln('</pre>');
    } else if (isTextFormat) {
      logContent
        ..writeln('\r\n\r\nResponse (${durationMillis}ms): \r\n')
        ..writeln(outcome);
      headers?.forEach(logContent.writeln);
      if (body != null) {
        logContent
          ..writeln()
          ..writeln(utf8.decode(body));
      }
    } else {
      consoleOut('Response logged:');
      consoleOut('Outcome: $outcome');
      headers?.forEach((header) => consoleOut('Header: $header'));
      if (body != null) {
        consoleOut('Body:');
        consoleOut('----');
        consoleOut(utf8.decode(body));
      }
    }

    _writeToLogFile(logContent.toString());
  }

  /// Returns the last logged request ID.
  String? getLastId() => _lastId;

  /// Clears the last logged request ID.
  void clearLastId() {
    _lastId = null;
  }

  /// Verifies if no requests were made.
  bool verifyHasNoRequests({bool rebuildCache = false}) {
    if (rebuildCache) return true;
    if (requests != 0) {
      consoleErr('$requests unexpected requests logged.');
      return false;
    }
    return true;
  }

  /// Escapes HTML content for logging in HTML format.
  String _escapeHtml(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }

  /// Writes the content to the log file if available.
  void _writeToLogFile(String content) {
    if (logFilePath != null) {
      appendToFile(logFilePath!, content);
    }
  }
}

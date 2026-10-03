import 'dart:convert';

import 'package:http/http.dart';

/// The two terminology-server calls the worker context makes, over plain
/// JSON (the Parameters resource in and out as maps).
class FhirToolingClient {
  /// A client for [baseUri] (hapi.fhir.org's R4 server by default).
  FhirToolingClient({Uri? baseUri, this.userAgent = 'FHIR Tooling Client'})
      : baseUri = baseUri ?? Uri.parse('https://hapi.fhir.org/baseR4') {
    headers['User-Agent'] = userAgent;
    headers['Accept'] = 'application/fhir+json';
    headers['Content-Type'] = 'application/fhir+json';
  }

  /// The base URI of the FHIR server.
  final Uri baseUri;

  /// The user agent string to include in the HTTP headers.
  final String userAgent;

  /// The HTTP headers to include in the request.
  final Map<String, String> headers = {};

  /// The server's address.
  String getAddress() => baseUri.toString();

  /// CodeSystem/\$validate-code with [input], a Parameters resource.
  Future<Map<String, dynamic>> validateCS(Map<String, dynamic> input) =>
      _post(Uri.parse('$baseUri/CodeSystem/\$validate-code'), input);

  /// ValueSet/\$validate-code with [input], a Parameters resource.
  Future<Map<String, dynamic>> validateVS(Map<String, dynamic> input) =>
      _post(Uri.parse('$baseUri/ValueSet/\$validate-code'), input);

  Future<Map<String, dynamic>> _post(
    Uri endpoint,
    Map<String, dynamic> body,
  ) async {
    final client = Client();
    try {
      final response =
          await client.post(endpoint, headers: headers, body: jsonEncode(body));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw TerminologyServerException(
          'Failed to validate: ${response.statusCode} - ${response.body}',
        );
      }
      final json = jsonDecode(response.body);
      if (json is! Map<String, dynamic>) {
        throw TerminologyServerException('The server did not answer JSON');
      }
      return json;
    } on FormatException catch (e) {
      throw TerminologyServerException('The server answered non-JSON: $e');
    } on ClientException catch (e) {
      throw TerminologyServerException('HTTP request error: $e');
    } finally {
      client.close();
    }
  }
}

/// A terminology server call that did not answer.
class TerminologyServerException implements Exception {
  /// What happened.
  TerminologyServerException(this.message);

  /// What happened.
  final String message;

  @override
  String toString() => 'TerminologyServerException: $message';
}

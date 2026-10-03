/// Exception thrown when a terminology service is not available.
class NoTerminologyServiceException implements Exception {
  /// Constructor for [NoTerminologyServiceException] with optional [message]
  /// and [cause].
  NoTerminologyServiceException({this.message, this.cause});

  /// Constructor for [NoTerminologyServiceException] with optional [message].
  NoTerminologyServiceException.message({this.message}) : cause = null;

  /// Constructor for [NoTerminologyServiceException] with optional [cause].
  NoTerminologyServiceException.cause({this.cause}) : message = null;

  /// The exception message.
  final String? message;

  /// The cause of the exception.
  final Object? cause;
}

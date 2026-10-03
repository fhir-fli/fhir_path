/// Exception for when a ValueSet is too costly to expand
class ETooCostly implements Exception {
  /// Create an ETooCostly exception
  ETooCostly(this.message);

  /// The message to display
  final String message;

  @override
  String toString() => 'ETooCostly: $message';
}

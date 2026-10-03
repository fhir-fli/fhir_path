/// CodeInValueSetResult
class CodeInValueSetResult {
  /// Create a new code in value set result
  CodeInValueSetResult({required this.errors, required this.warnings});

  /// The errors
  final List<String> errors;

  /// The warnings
  final List<String> warnings;
}

/// Extension for WorkerContext to handle ValueSet expansion

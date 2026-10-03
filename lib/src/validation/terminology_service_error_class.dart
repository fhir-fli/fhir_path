/// Why a terminology operation could not answer. Was a FHIR code type in the
/// per-version bindings (TerminologyServiceErrorClass extends FhirCodeEnum,
/// with a generated copyWith); it is never serialised as FHIR, so a Dart
/// enum says the same thing.
enum TerminologyServiceErrorClass {
  /// Unknown error type.
  unknown,

  /// No terminology service is available.
  noservice,

  /// The server failed.
  serverError,

  /// The value set is unsupported.
  valueSetUnsupported,

  /// The code system is unsupported.
  codeSystemUnsupported,

  /// The operation is blocked by the validation options.
  blockedByOptions;

  /// Whether the error is the infrastructure's, not the code's.
  bool isInfrastructure() =>
      this == noservice || this == serverError || this == valueSetUnsupported;
}

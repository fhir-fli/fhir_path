import 'package:fhir_path/fhir_path.dart';

/// How loud a validation answer is. Mirrors OperationOutcome.issue.severity
/// without a version's IssueSeverity type.
enum ValidationSeverity {
  /// The code is fine; the message, if any, is a note.
  information,

  /// The code is accepted with a reservation.
  warning,

  /// The code is not valid.
  error,
}

/// The answer to "is this code valid (in this value set)?".
class ValidationResult implements IValidationOutcome {
  /// A result.
  ValidationResult({
    this.system,
    this.definition,
    this.display,
    this.severity,
    this.message,
    this.errorClass,
    this.txLink,
  });

  /// An error.
  ValidationResult.error({required this.message, this.errorClass})
      : severity = ValidationSeverity.error;

  /// A success.
  ValidationResult.success({
    this.system,
    this.definition,
    this.message,
    this.txLink,
  }) : severity = ValidationSeverity.information;

  /// The concept the code resolved to, when a code system defined it.
  ConceptDefinition? definition;

  /// The code system.
  String? system;

  /// The display the code system gives the code.
  String? display;

  /// How loud.
  ValidationSeverity? severity;

  /// What was found.
  String? message;

  /// Why the service could not answer, when it could not.
  TerminologyServiceErrorClass? errorClass;

  /// The terminology server transaction, when one was used.
  String? txLink;

  @override
  bool get isOk =>
      severity == null ||
      severity == ValidationSeverity.information ||
      severity == ValidationSeverity.warning;

  /// The resolved concept's display.
  String? getDisplay() => definition?.display;

  /// The resolved concept's code.
  String? getCode() => definition?.code;

  /// The resolved concept's definition text.
  String? getDefinition() => definition?.definition;

  /// The resolved concept.
  ConceptDefinition? asConceptDefinition() => definition;

  /// Whether the failure was the absence of a terminology service.
  bool isNoService() => errorClass == TerminologyServiceErrorClass.noservice;

  /// The validated code as a Coding, when it resolved.
  CodingValue? asCoding() {
    if (isOk && definition != null) {
      return CodingValue(
        system: system,
        code: definition!.code,
        display: definition!.display,
      );
    }
    return null;
  }

  @override
  String toString() =>
      'ValidationResult [definition=$definition, system=$system, '
      'severity=$severity, message=$message, errorClass=$errorClass, '
      'txLink=$txLink]';
}

import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/fhir_path.dart';

/// The result of a ValueSet expansion.
class ValueSetExpansionOutcome {
  /// An expansion that worked: [valueSet] carries the expansion.
  ValueSetExpansionOutcome(this.valueSet)
      : error = null,
        errorClass = null;

  /// An expansion that failed.
  ValueSetExpansionOutcome.withError(
    this.valueSet,
    this.error,
    this.errorClass,
  ) {
    if (error != null) allErrors.add(error!);
  }

  /// A service failure.
  ValueSetExpansionOutcome.fromService(this.error, this.errorClass)
      : valueSet = null {
    if (error != null) allErrors.add(error!);
  }

  /// A failure with several messages.
  ValueSetExpansionOutcome.fromErrorList(
    this.error,
    this.errorClass,
    List<String> errors,
  ) : valueSet = null {
    allErrors.addAll(errors);
    if (error != null && !allErrors.contains(error)) allErrors.add(error!);
  }

  /// The expanded ValueSet node.
  final FhirNode? valueSet;

  /// The error message.
  final String? error;

  /// The error class.
  final TerminologyServiceErrorClass? errorClass;

  /// The terminology server transaction, when one was used.
  String? txLink;

  /// Every error.
  final List<String> allErrors = [];

  /// Whether the expansion worked.
  bool get isOk => allErrors.isEmpty && error == null;
}

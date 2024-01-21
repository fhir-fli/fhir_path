// ignore_for_file: annotate_overrides, overridden_fields

// Project imports:
import '../../fhir_path.dart';

/// DEPRECATED
/// The as() function is defined for backwards compatibility with previous implementations
/// of FHIRPath. However, we have chosen not to support it.
/// DEPRECATED
class AsFunctionParser extends ValueParser<ParserList> {
  AsFunctionParser([FhirPathParser? nextParser])
      : super(ParserList([]), nextParser);

  AsFunctionParser copyWithNextParser(FhirPathParser nextParser) =>
      AsFunctionParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    throw FhirPathDeprecatedExpressionException(
        'The FHIRPath expression that was supplied includes "as(type : type specifier)" '
        ' which has been deprecated. Please instead use the "as type specifer". '
        'Official explanation can be read here: https://hl7.org/fhirpath/#as-type-specifier');
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}AsFunctionParser (Deprecated)\n${value.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) =>
      '.as(Deprecated)(\n${"  " * indent}${value.prettyPrint(indent + 1)}\n'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

/// DEPRECATED
/// The as() function is defined for backwards compatibility with previous implementations
/// of FHIRPath. However, we have chosen not to support it.
/// DEPRECATED
class IsFunctionParser extends ValueParser<ParserList> {
  IsFunctionParser([FhirPathParser? nextParser])
      : super(ParserList([]), nextParser);

  IsFunctionParser copyWithNextParser(FhirPathParser nextParser) =>
      IsFunctionParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    throw FhirPathDeprecatedExpressionException(
        'The FHIRPath expression that was supplied includes "is(type : type specifier)" '
        ' which has been deprecated. Please instead use the "is type specifer". '
        'Official explanation can be read here: https://hl7.org/fhirpath/#as-type-specifier');
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}IsFunctionParser (Deprecated)\n${value.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) =>
      '.is(Deprecated)(\n${"  " * indent}${value.prettyPrint(indent + 1)}\n'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

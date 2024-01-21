// ignore_for_file: annotate_overrides, overridden_fields, noop_primitive_operations, unnecessary_this

// Package imports:
import 'package:fhir/primitive_types/primitive_types.dart';
import 'package:ucum/ucum.dart';

// Project imports:
import '../../fhir_path.dart';

class EqualsParser extends OperatorParser {
  EqualsParser([FhirPathParser? nextParser]) : super(nextParser);

  EqualsParser copyWithNextParser(FhirPathParser nextParser) =>
      EqualsParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final lhs = results;
    final rhs = nextParser == null ? [] : nextParser!.execute([], passed);

    if (lhs.isEmpty || rhs is EmptyParser) {
      return [];
    } else if (lhs.length != rhs.length) {
      return [false];
    } else {
      /// for each entry in lhs and rhs (we checked above to ensure they
      /// were the same length)
      for (var i = 0; i < lhs.length; i++) {
        /// we check to see if any of the values are DateTimes
        if (lhs[i] is FhirDateTime ||
            lhs[i] is FhirDate ||
            rhs[i] is FhirDateTime ||
            rhs[i] is FhirDate) {
          /// As long as one is, we convert them both to strings then back
          /// to DateTimes
          final lhsDateTime = FhirDateTime(lhs[i].toString());
          final rhsDateTime = FhirDateTime(rhs[i].toString());

          /// As long as they are both valid we try and compare them
          if (lhsDateTime.isValid && rhsDateTime.isValid) {
            if (lhsDateTime != rhsDateTime) {
              return <dynamic>[false];
            }
          }
        }

        /// If they aren't dateTimes we can just compare them as usual
        else {
          if (lhs[i] is ValidatedQuantity || rhs[i] is ValidatedQuantity) {
            print(lhs[i]);
            if (lhs[i] is ValidatedQuantity) {
              print(rhs[i]);
              return <dynamic>[lhs[i] == rhs[i]];
            } else {
              return <dynamic>[rhs[i] == lhs[i]];
            }
          }
          if (lhs[i] != rhs[i] || rhs[i] != lhs[i]) {
            return <dynamic>[false];
          }
        }
      }
      return [true];
    }
  }
}

// TODO(Dokotela): write test
class EquivalentParser extends OperatorParser {
  EquivalentParser([FhirPathParser? nextParser]) : super(nextParser);

  EquivalentParser copyWithNextParser(FhirPathParser nextParser) =>
      EquivalentParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final lhs = results;
    final rhs = nextParser == null ? [] : nextParser!.execute([], passed);

    if (lhs.isEmpty) {
      if (rhs.isEmpty) {
        return [true];
      } else {
        return [false];
      }
    } else if (lhs.length != rhs.length) {
      return [false];
    } else {
      lhs.removeWhere((lhsElement) =>
          rhs.indexWhere((rhsElement) {
            if (lhsElement is FhirDateTime ||
                lhsElement is FhirDate ||
                rhsElement is FhirDateTime ||
                rhsElement is FhirDate) {
              /// As long as one is, we convert them both to strings then back
              /// to DateTimes
              final lhsDateTime = FhirDateTime(lhsElement.toString());
              final rhsDateTime = FhirDateTime(rhsElement.toString());

              /// As long as they are both valid we try and compare them
              if (lhsDateTime.isValid && rhsDateTime.isValid) {
                return lhsDateTime == rhsDateTime;
              } else {
                return false;
              }
            } else if (lhsElement is ValidatedQuantity ||
                rhsElement is ValidatedQuantity) {
              if (lhsElement is ValidatedQuantity) {
                return lhsElement.value.equivalent(rhsElement as Object);
              } else {
                return (rhsElement as ValidatedQuantity)
                    .equivalent(lhsElement as Object);
              }
            } else if (lhsElement is num || rhsElement is num) {
              final sigDigsLhs = num.tryParse(lhsElement.toString())
                  ?.toStringAsExponential()
                  .split('e');
              final sigDigsRhs = num.tryParse(rhsElement.toString())
                  ?.toStringAsExponential()
                  .split('e');
              if (sigDigsLhs == null || sigDigsRhs == null) {
                return false;
              } else {
                if (sigDigsLhs.first.length < sigDigsRhs.first.length) {
                  return num.parse('${sigDigsLhs.first}e${sigDigsLhs.last}') ==
                      num.parse(
                          '${sigDigsRhs.first.toString().substring(0, sigDigsLhs.first.length)}'
                          'e${sigDigsRhs.last}');
                } else {
                  return num.parse(
                          '${sigDigsLhs.first.toString().substring(0, sigDigsRhs.first.length)}'
                          'e${sigDigsLhs.last}') ==
                      num.parse('${sigDigsRhs.first}e${sigDigsRhs.last}');
                }
              }
            } else if (lhsElement is String || rhsElement is String) {
              return lhsElement.toString().toLowerCase() ==
                  rhsElement.toString().toLowerCase();
            } else {
              return lhsElement == rhsElement || rhsElement == lhsElement;
            }
          }) !=
          -1);
      return [lhs.isEmpty];
    }
  }
}

/// https://hl7.org/fhirpath/#not-equals
///
/// A != B is short-hand for (A = B).not()
class NotEqualsParser extends OperatorParser {
  NotEqualsParser([FhirPathParser? nextParser]) : super(nextParser);

  NotEqualsParser copyWithNextParser(FhirPathParser nextParser) =>
      NotEqualsParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final equality = EqualsParser(nextParser!).execute(results, passed);
    return FpNotParser().execute(equality, passed);
  }
}

class NotEquivalentParser extends OperatorParser {
  NotEquivalentParser([FhirPathParser? nextParser]) : super(nextParser);

  NotEquivalentParser copyWithNextParser(FhirPathParser nextParser) =>
      NotEquivalentParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final equality = EquivalentParser(nextParser!).execute(results, passed);
    return FpNotParser().execute(equality, passed);
  }
}

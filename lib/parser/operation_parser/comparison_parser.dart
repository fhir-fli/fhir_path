// ignore_for_file: annotate_overrides, overridden_fields, avoid_dynamic_calls, avoid_bool_literals_in_conditional_expressions

// Package imports:
import 'package:fhir/primitive_types/primitive_types.dart';
import 'package:ucum/ucum.dart';

// Project imports:
import '../../fhir_path.dart';

class GreaterParser extends OperatorParser {
  GreaterParser([FhirPathParser? super.nextParser]);

  GreaterParser copyWithNextParser(FhirPathParser nextParser) =>
      GreaterParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) =>
      executeComparisons(results, nextParser, passed, Comparator.gt);
}

class LessParser extends OperatorParser {
  LessParser([FhirPathParser? super.nextParser]);

  LessParser copyWithNextParser(FhirPathParser nextParser) =>
      LessParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) =>
      executeComparisons(results, nextParser, passed, Comparator.lt);
}

class GreaterEqualParser extends OperatorParser {
  GreaterEqualParser([FhirPathParser? super.nextParser]);

  GreaterEqualParser copyWithNextParser(FhirPathParser nextParser) =>
      GreaterEqualParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    return executeComparisons(results, nextParser, passed, Comparator.gte);
  }
}

class LessEqualParser extends OperatorParser {
  LessEqualParser([FhirPathParser? super.nextParser]);

  LessEqualParser copyWithNextParser(FhirPathParser nextParser) =>
      LessEqualParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) =>
      executeComparisons(results, nextParser, passed, Comparator.lte);
}

enum Comparator { gt, gte, lt, lte }

List executeComparisons(List results, FhirPathParser? nextParser,
    Map<String, dynamic> passed, Comparator comparator,
    {bool where = false}) {
  bool stringGt(String param1, String param2) {
    final runes1 = param1.runes.toList();
    final runes2 = param2.runes.toList();
    if (runes1.length < runes2.length) {
      return false;
    }
    for (var i = 0; i < runes1.length; i++) {
      if (runes2[i] > runes1[i]) {
        return false;
      } else if (runes2[i] < runes1[i]) {
        return true;
      }
    }
    return false;
  }

  bool? makeComparison(Comparator comparator, dynamic param1, dynamic param2) {
    if (param1 is FhirDateTimeBase) {
      if (param2 is! FhirDateTimeBase) {
        param2 = FhirDateTime.fromString(param2.toString());
      }
      if (!param1.precision.isEquallyPrecise(param2.precision)) {
        return null;
      }
    }

    try {
      switch (comparator) {
        case Comparator.gt:
          return param1 > param2 as bool;
        case Comparator.gte:
          return param1 >= param2 as bool;
        case Comparator.lt:
          return param1 < param2 as bool;
        case Comparator.lte:
          return param1 <= param2 as bool;
      }
    } catch (e) {
      if (e is UnequalPrecision) {
        return null;
      } else {
        rethrow;
      }
    }
  }

  Exception cannotCompareException(dynamic param1, dynamic param2) =>
      FhirPathEvaluationException(
          'The comparator $comparator was not passed types that can be '
          'compared.\n'
          'Param1: $param1 - ${param1.runtimeType}\n'
          'Param1: $param2 - ${param2.runtimeType}\n');

  Exception invalidException(dynamic param1, dynamic param2) =>
      FhirPathEvaluationException(
          'The comparator $comparator was not passed two valid types.\n'
          'Param1: $param1 - ${param1.runtimeType} - Valid? ${param1.isValid}\n'
          'Param1: $param2 - ${param2.runtimeType} - Valid? ${param2.isValid}\n');

  bool? compare(Comparator comparator, dynamic lhs, dynamic rhs) {
    switch (lhs.runtimeType) {
      case num:
        return rhs is num
            ? makeComparison(comparator, lhs, rhs)
            : rhs is FhirNumber && rhs.isValid
                ? makeComparison(comparator, lhs, rhs.valueNumber)
                : rhs is String && num.tryParse(rhs) != null
                    ? makeComparison(comparator, lhs, num.parse(rhs))
                    : throw cannotCompareException(lhs, rhs);
      case int:
        return rhs is num
            ? makeComparison(comparator, lhs, rhs)
            : rhs is FhirNumber && rhs.isValid
                ? makeComparison(comparator, lhs, rhs.valueNumber)
                : rhs is String && num.tryParse(rhs) != null
                    ? makeComparison(comparator, lhs, num.parse(rhs))
                    : throw cannotCompareException(lhs, rhs);
      case double:
        return rhs is num
            ? makeComparison(comparator, lhs, rhs)
            : rhs is FhirNumber && rhs.isValid
                ? makeComparison(comparator, lhs, rhs.valueNumber)
                : rhs is String && num.tryParse(rhs) != null
                    ? makeComparison(comparator, lhs, num.parse(rhs))
                    : throw cannotCompareException(lhs, rhs);
      case FhirDate:
        return rhs is FhirDateTimeBase
            ? (lhs as FhirDate).isValid && rhs.isValid
                ? makeComparison(comparator, lhs, rhs)
                : throw invalidException(lhs, rhs)
            : rhs is String && FhirDateTime.fromString(rhs).isValid
                ? makeComparison(comparator, lhs, rhs)
                : throw cannotCompareException(lhs, rhs);
      case DateTime:
        return (rhs is FhirDateTimeBase && rhs.isValid)
            ? makeComparison(comparator, FhirDateTime.fromDateTime(lhs), rhs)
            : rhs is DateTime
                ? makeComparison(comparator, FhirDateTime.fromDateTime(lhs),
                    FhirDateTime.fromDateTime(rhs))
                : rhs is String && FhirDateTime.fromString(rhs).isValid
                    ? makeComparison(comparator, FhirDateTime.fromDateTime(lhs),
                        FhirDateTime.fromString(rhs))
                    : throw cannotCompareException(lhs, rhs);
      case FhirDateTime:
        return rhs is FhirDateTimeBase
            ? (lhs as FhirDateTime).isValid && rhs.isValid
                ? makeComparison(comparator, lhs, rhs)
                : throw invalidException(lhs, rhs)
            : rhs is String && FhirDateTime.fromString(rhs).isValid
                ? makeComparison(comparator, lhs, FhirDateTime.fromString(rhs))
                : throw cannotCompareException(lhs, rhs);
      case FhirTime:
        return rhs is FhirTime
            ? (lhs as FhirTime).isValid && rhs.isValid
                ? makeComparison(comparator, lhs, rhs)
                : throw invalidException(lhs, rhs)
            : rhs is String && FhirTime(rhs).isValid
                ? makeComparison(comparator, lhs, FhirTime(rhs))
                : throw cannotCompareException(lhs, rhs);
      case ValidatedQuantity:
        return rhs is ValidatedQuantity
            ? makeComparison(comparator, lhs, rhs)
            : rhs is String
                ? makeComparison(
                    comparator, lhs, ValidatedQuantity.fromString(rhs))
                : throw cannotCompareException(lhs, rhs);

      /// Default should be when lhs is a String
      default:
        {
          if (lhs is String && rhs is String) {
            return (comparator == Comparator.gt || comparator == Comparator.lt)
                ? lhs == rhs
                    ? false
                    : comparator == Comparator.gt
                        ? stringGt(lhs, rhs)
                        : !stringGt(lhs, rhs)
                : lhs == rhs
                    ? true
                    : comparator == Comparator.gte
                        ? stringGt(lhs, rhs)
                        : !stringGt(lhs, rhs);
          } else if (rhs is FhirTime && FhirTime(lhs).isValid) {
            return makeComparison(comparator, FhirTime(lhs), rhs);
          } else if ((rhs is FhirDate || rhs is FhirDateTime) &&
              // TODO(Dokotela): can I just force lhs to be a string?
              FhirDateTime.fromString(lhs.toString()).isValid) {
            return makeComparison(
                comparator, FhirDateTime.fromString(lhs), rhs);
          }
          throw FhirPathEvaluationException(
            'Can only compare Strings to other Strings',
            operation: '$comparator',
            arguments: [lhs, rhs],
          );
        }
    }
  }

  final lhs = comparisonValue(results.toList(),
      name: 'left-hand side',
      operation: comparator.toString(),
      collection: results);
  final rhs = comparisonValue(nextParser?.execute([], passed) ?? [],
      name: 'right-hand side',
      operation: comparator.toString(),
      collection: results);

  if (lhs.isEmpty || rhs.isEmpty) {
    return [];
  } else if (lhs.length != 1 || rhs.length != 1) {
    throw _wrongArgLength(
      comparator.toString(),
      ['Left-hand side: $lhs', 'Right-hand side: $rhs'],
    );
  }
  {
    if (!_allowedTypes.contains(lhs.first.runtimeType) ||
        !_allowedTypes.contains(rhs.first.runtimeType)) {
      final functionName = comparator == Comparator.gt
          ? '>'
          : comparator == Comparator.gte
              ? '>='
              : comparator == Comparator.lt
                  ? '<'
                  : '<=';
      throw FhirPathEvaluationException(
          'The comparator $functionName cannot work with the types '
          'passed.\n'
          'LHS: $lhs\n'
          'RHS: $rhs',
          operation: functionName);
    } else if (where) {
      results.retainWhere((element) =>
          compare(comparator, element[lhs.first], rhs.first) ?? false);
      return results;
    } else {
      final newResult = compare(comparator, lhs.first, rhs.first);
      return newResult == null ? [] : [newResult];
    }
  }
}

const _allowedTypes = [
  String,
  num,
  int,
  double,
  FhirDate,
  FhirDateTime,
  FhirTime,
  ValidatedQuantity,
];

Exception _wrongArgLength(String functionName, List value) =>
    FhirPathEvaluationException(
        'The function $functionName must have an argument that '
        'evaluates to 0 or 1 item.',
        operation: functionName,
        arguments: value);

List<dynamic> comparisonValue(
  List<dynamic> input, {
  String? name,
  String? operation,
  List<dynamic>? collection,
}) {
  if (input.isEmpty) {
    return [];
  }

  if (input.length > 1) {
    throw FhirPathEvaluationException(
        'The $name is required to be '
        'either an empty value, or a single value. Instead it evaluated to: $input.',
        operation: operation,
        collection: collection);
  }

  final item = input.first;
  if (item is Map) {
    if (item['value'] != null && item['code'] != null) {
      return [
        ValidatedQuantity(
            value: Decimal.fromString(
                ((item['value']).value ?? double.nan).toString()),
            code: item['code'] as String)
      ];
    }
  }

  return input;
}

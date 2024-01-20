// ignore_for_file: annotate_overrides, overridden_fields, prefer_if_elements_to_conditional_expressions

// Package imports:
import 'package:fhir/primitive_types/primitive_types.dart';
import 'package:ucum/ucum.dart';

// Project imports:
import '../../../fhir_path.dart';

/// http://hl7.org/fhirpath/#iifcriterion-expression-true-result-collection-otherwise-result-collection-collection
///The iif function in FHIRPath is an immediate if, also known as a conditional operator (such as C’s ? : operator).
/// The criterion expression is expected to evaluate to a Boolean.
/// See: http://hl7.org/fhirpath/#singleton-evaluation-of-collections for rules of Boolean evaluation.
/// Any collection with a single non-boolean item is true.
///
/// If criterion is true, the function returns the value of the true-result argument.
/// If criterion is false or an empty collection, the function returns otherwise-result, unless the optional otherwise-result is not given, in which case the function returns an empty collection.
/// Note that short-circuit behavior is expected in this function. In other words, true-result should only be evaluated if the criterion evaluates to true, and otherwise-result should only be evaluated otherwise. For implementations, this means delaying evaluation of the arguments.
class IifParser extends FunctionParser {
  IifParser([FhirPathParser? nextParser]) : super(ParserList([]), nextParser);

  IifParser copyWithNextParser(FhirPathParser nextParser) =>
      IifParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    // The regular .execute method on CommaParser does not implement the
    // short-circuit logic. Bespoke execution path required.
    if (value.first is! CommaParser) {
      // While this happens at eval time, it is due to incorrect syntax
      throw FhirPathInvalidExpressionException(
        'The function iif must have a criterion expression, followed by '
        ' a true-result collection, and an optional other-wise-result. '
        'Instead it has: ${value.first}',
      );
    }

    final criterionResultParser = value.first as CommaParser;
    final List<dynamic> criterionCollection = [];
    if (criterionResultParser.before.first is CommaParser) {
      criterionCollection.addAll(
          (criterionResultParser.before.first as CommaParser)
              .before
              .execute([], passed));
    } else {
      criterionCollection
          .addAll(criterionResultParser.before.execute([], passed));
    }

    final criterion = SingletonEvaluation.toBool(criterionCollection,
        name: 'criterion expression', operation: 'iif', collection: results);

    // Short-circuit: Only evaluate what matches the criterion.
    if (criterion == true) {
      final trueResultParser = criterionResultParser.before.first is CommaParser
          ? (criterionResultParser.before.first as CommaParser).after
          : (criterionResultParser.after.first is CommaParser)
              ? (criterionResultParser.after.first as CommaParser).before
              : criterionResultParser.after.first;

      final trueResult = trueResultParser.execute([], passed);

      return trueResult;
    } else {
      final otherwiseResultParser =
          (criterionResultParser.after.first is CommaParser)
              ? (criterionResultParser.after.first as CommaParser).after
              : criterionResultParser.before.first is CommaParser
                  ? criterionResultParser.after
                  : EmptySetParser();

      final otherwiseResult = otherwiseResultParser.execute([], passed);

      return otherwiseResult;
    }
  }

  @override
  String toString() => 'IifParser: $value';

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}IifParser\n${value.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) =>
      '.iif(\n${"  " * indent}${value.prettyPrint(indent + 1)}\n'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

/// http://hl7.org/fhirpath/#toboolean-boolean
/// If the input collection contains a single item, this function will return a single boolean if:
/// the item is a Boolean
/// the item is an Integer and is equal to one of the possible integer representations of Boolean values
/// the item is a Decimal that is equal to one of the possible decimal representations of Boolean values
/// the item is a String that is equal to one of the possible string representations of Boolean values
/// If the item is not one the above types, or the item is a String, Integer, or Decimal, but is not equal to one of the possible values convertible to a Boolean, the result is empty.
class ToBooleanParser extends FhirPathParser {
  const ToBooleanParser([FhirPathParser? super.nextParser]);

  FhirPathParser copyWithNextParser(FhirPathParser nextParser) =>
      ToBooleanParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    List newResults() => results.isEmpty
        ? []
        : results.length > 1
            ? throw _conversionException('.toBoolean()', results)
            : _isNotAcceptedType(results)
                ? []
                : results.first == true ||
                        results.first == 1 ||
                        ['true', 't', 'yes', 'y', '1', '1.0'].indexWhere(
                                (element) =>
                                    element ==
                                    results.first.toString().toLowerCase()) !=
                            -1
                    ? [true]
                    : results.first == false ||
                            results.first == 0 ||
                            [
                                  'false',
                                  'f',
                                  'no',
                                  'n',
                                  '0',
                                  '0.0'
                                ].indexWhere((element) =>
                                    element ==
                                    results.first.toString().toLowerCase()) !=
                                -1
                        ? [false]
                        : [];
    return nextParser != null
        ? nextParser!.execute(newResults(), passed)
        : newResults();
  }

  @override
  String prettyPrint([int indent = 2]) => '.toBoolean()';
}

/// http://hl7.org/fhirpath/#convertstoboolean-boolean
/// If the input collection contains a single item, this function will return true if:
/// the item is a Boolean
/// the item is an Integer that is equal to one of the possible integer representations of Boolean values
/// the item is a Decimal that is equal to one of the possible decimal representations of Boolean values
/// the item is a String that is equal to one of the possible string representations of Boolean values
class ConvertsToBooleanParser extends FhirPathParser {
  const ConvertsToBooleanParser([FhirPathParser? super.nextParser]);

  FhirPathParser copyWithNextParser(FhirPathParser nextParser) =>
      ConvertsToBooleanParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    List newResults() => results.isEmpty
        ? []
        : results.length > 1
            ? throw _conversionException('.convertsToBoolean()', results)
            : _isNotAcceptedType(results)
                ? [false]
                : results.first is bool ||
                        results.first == 1 ||
                        results.first == 0 ||
                        [
                              'true',
                              't',
                              'yes',
                              'y',
                              '1',
                              '1.0',
                              'false',
                              'f',
                              'no',
                              'n',
                              '0',
                              '0.0'
                            ].indexWhere((element) =>
                                element ==
                                results.first.toString().toLowerCase()) !=
                            -1
                    ? [true]
                    : [false];
    if (nextParser != null) {
      return nextParser!.execute(newResults(), passed);
    } else {
      return newResults();
    }
  }

  @override
  String prettyPrint([int indent = 2]) => '.convertsToBoolean()';
}

/// Converts input to an [Integer] if possible
class ToIntegerParser extends FhirPathParser {
  const ToIntegerParser([FhirPathParser? super.nextParser]);

  FhirPathParser copyWithNextParser(FhirPathParser nextParser) =>
      ToIntegerParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    List newResults() => results.isEmpty
        ? []
        : results.length > 1
            ? throw _conversionException('.toInteger()', results)
            : _isNotAcceptedType(results)
                ? [false]
                : results.first is bool
                    ? [results.first == true ? 1 : 0]
                    : results.first is num
                        ? [(results.first as num).toInt()]
                        : int.tryParse(results.first as String) != null
                            ? [int.parse(results.first as String)]
                            : [];
    if (nextParser != null) {
      return nextParser!.execute(newResults(), passed);
    } else {
      return newResults();
    }
  }

  @override
  String prettyPrint([int indent = 2]) => '.toInteger()';
}

/// Checks if input can be converted to an [Integer]
class ConvertsToIntegerParser extends FhirPathParser {
  const ConvertsToIntegerParser([FhirPathParser? super.nextParser]);

  FhirPathParser copyWithNextParser(FhirPathParser nextParser) =>
      ConvertsToIntegerParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    List newResults() => results.isEmpty
        ? []
        : results.length > 1
            ? throw _conversionException('.convertsToInteger()', results)
            : _isNotAcceptedType(results)
                ? []
                : results.first is bool
                    ? [true]
                    : results.first is num
                        ? [true]
                        : int.tryParse(results.first as String) != null
                            ? [true]
                            : [false];
    if (nextParser != null) {
      return nextParser!.execute(newResults(), passed);
    } else {
      return newResults();
    }
  }

  @override
  String prettyPrint([int indent = 2]) => '.convertsToInteger()';
}

/// Converts input to an [Date] if possible
class ToDateParser extends FhirPathParser {
  const ToDateParser([FhirPathParser? super.nextParser]);

  FhirPathParser copyWithNextParser(FhirPathParser nextParser) =>
      ToDateParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    List newResults() => results.isEmpty
        ? []
        : results.length > 1
            ? throw _conversionException('.toDate()', results)
            : FhirDate(results.first.toString()).isValid
                ? [FhirDate(results.first.toString())]
                : [];
    if (nextParser != null) {
      return nextParser!.execute(newResults(), passed);
    } else {
      return newResults();
    }
  }

  @override
  String prettyPrint([int indent = 2]) => '.toDate()';
}

/// Checks if input can be converted to a [Date]
class ConvertsToDateParser extends FhirPathParser {
  const ConvertsToDateParser([FhirPathParser? super.nextParser]);

  FhirPathParser copyWithNextParser(FhirPathParser nextParser) =>
      ConvertsToDateParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    List newResults() => results.isEmpty
        ? []
        : results.length > 1
            ? throw _conversionException('.convertsToDate()', results)
            : [FhirDate(results.first.toString()).isValid];
    if (nextParser != null) {
      return nextParser!.execute(newResults(), passed);
    } else {
      return newResults();
    }
  }

  @override
  String prettyPrint([int indent = 2]) => '.convertsToDate()';
}

/// Converts input to [FhirDateTime] if possible
class ToDateTimeParser extends FhirPathParser {
  const ToDateTimeParser([FhirPathParser? super.nextParser]);

  FhirPathParser copyWithNextParser(FhirPathParser nextParser) =>
      ToDateTimeParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    List newResults() => results.isEmpty
        ? []
        : results.length > 1
            ? throw _conversionException('.toDateTime()', results)
            : FhirDateTime(results.first.toString()).isValid
                ? [FhirDateTime(results.first.toString())]
                : [];
    if (nextParser != null) {
      return nextParser!.execute(newResults(), passed);
    } else {
      return newResults();
    }
  }

  @override
  String prettyPrint([int indent = 2]) => '.toDateTime()';
}

/// Checks if input can be converted to a [FhirDateTime]
class ConvertsToDateTimeParser extends FhirPathParser {
  const ConvertsToDateTimeParser([FhirPathParser? super.nextParser]);

  FhirPathParser copyWithNextParser(FhirPathParser nextParser) =>
      ConvertsToDateTimeParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    List newResults() => results.isEmpty
        ? []
        : results.length > 1
            ? throw _conversionException('.convertsToDateTime()', results)
            : FhirDateTime(results.first.toString()).isValid
                ? [FhirDateTime(results.first.toString()).isValid]
                : [];
    if (nextParser != null) {
      return nextParser!.execute(newResults(), passed);
    } else {
      return newResults();
    }
  }

  @override
  String prettyPrint([int indent = 2]) => '.convertsToDateTime()';
}

/// Converts input to a [Decimal] if possible
class ToDecimalParser extends FhirPathParser {
  const ToDecimalParser([FhirPathParser? super.nextParser]);

  FhirPathParser copyWithNextParser(FhirPathParser nextParser) =>
      ToDecimalParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    List newResults() => results.isEmpty
        ? []
        : results.length > 1
            ? throw _conversionException('.toDecimal()', results)
            : _isNotAcceptedType(results)
                ? [false]
                : results.first is bool
                    ? [results.first == true ? 1 : 0]
                    : results.first is num
                        ? [(results.first as num).toDouble()]
                        : double.tryParse(results.first as String) != null
                            ? [double.parse(results.first as String)]
                            : [];
    if (nextParser != null) {
      return nextParser!.execute(newResults(), passed);
    } else {
      return newResults();
    }
  }

  @override
  String prettyPrint([int indent = 2]) => '.toDecimal()';
}

/// Checks if input can be converted into a [Decimal]
class ConvertsToDecimalParser extends FhirPathParser {
  const ConvertsToDecimalParser([FhirPathParser? super.nextParser]);

  FhirPathParser copyWithNextParser(FhirPathParser nextParser) =>
      ConvertsToDecimalParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    List newResults() => results.isEmpty
        ? []
        : results.length > 1
            ? throw _conversionException('.convertsToDecimal()', results)
            : _isNotAcceptedType(results)
                ? []
                : results.first is bool
                    ? [true]
                    : results.first is num
                        ? [true]
                        : double.tryParse(results.first as String) != null
                            ? [true]
                            : [false];
    if (nextParser != null) {
      return nextParser!.execute(newResults(), passed);
    } else {
      return newResults();
    }
  }

  @override
  String prettyPrint([int indent = 2]) => '.convertsToDecimal()';
}

/// Converts input to a [String] if possible
class ToStringParser extends FhirPathParser {
  const ToStringParser([FhirPathParser? super.nextParser]);

  FhirPathParser copyWithNextParser(FhirPathParser nextParser) =>
      ToStringParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    print(results.first);
    print(results.first.runtimeType);
    List newResults() => results.isEmpty
        ? []
        : results.length > 1
            ? throw _conversionException('.toString()', results)
            : _isAllTypes(results)
                ? [false]
                : [results.first.toString()];
    if (nextParser != null) {
      return nextParser!.execute(newResults(), passed);
    } else {
      return newResults();
    }
  }

  @override
  String prettyPrint([int indent = 2]) => '.toString()';
}

/// Checks if input can be converted to a [String]
class ConvertsToStringParser extends FhirPathParser {
  const ConvertsToStringParser([FhirPathParser? super.nextParser]);

  FhirPathParser copyWithNextParser(FhirPathParser nextParser) =>
      ConvertsToStringParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    List newResults() => results.isEmpty
        ? []
        : results.length > 1
            ? throw _conversionException('.convertsToString()', results)
            : _isAllTypes(results)
                ? [false]
                : [true];
    if (nextParser != null) {
      return nextParser!.execute(newResults(), passed);
    } else {
      return newResults();
    }
  }

  @override
  String prettyPrint([int indent = 2]) => '.convertsToString()';
}

/// Converts input to a [Time] if possible
class ToTimeParser extends FhirPathParser {
  const ToTimeParser([FhirPathParser? super.nextParser]);

  FhirPathParser copyWithNextParser(FhirPathParser nextParser) =>
      ToTimeParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    List newResults() => results.isEmpty
        ? []
        : results.length > 1
            ? throw _conversionException('.toTime()', results)
            : results.first is FhirTime
                ? [results.first]
                : results.first is String && FhirTime(results.first).isValid
                    ? [FhirTime(results.first)]
                    : [];
    if (nextParser != null) {
      return nextParser!.execute(newResults(), passed);
    } else {
      return newResults();
    }
  }

  @override
  String prettyPrint([int indent = 2]) => '.toTime()';
}

/// Checks if input can be converted to a [Time]
class ConvertsToTimeParser extends FhirPathParser {
  const ConvertsToTimeParser([FhirPathParser? super.nextParser]);

  FhirPathParser copyWithNextParser(FhirPathParser nextParser) =>
      ConvertsToTimeParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    List newResults() => results.isEmpty
        ? []
        : results.length > 1
            ? throw _conversionException('.convertsToTime()', results)
            : results.first is FhirTime ||
                    (results.first is String && FhirTime(results.first).isValid)
                ? [true]
                : [false];
    if (nextParser != null) {
      return nextParser!.execute(newResults(), passed);
    } else {
      return newResults();
    }
  }

  @override
  String prettyPrint([int indent = 2]) => '.convertsToTime()';
}

/// Converts input to a [Quantity] if possible
class ToQuantityParser extends FhirPathParser {
  const ToQuantityParser([FhirPathParser? super.nextParser]);

  FhirPathParser copyWithNextParser(FhirPathParser nextParser) =>
      ToQuantityParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    List newResults() => results.isEmpty
        ? []
        : results.length > 1
            ? throw _conversionException('.toQuantity()', results)
            : results.first is ValidatedQuantity
                ? [results.first]
                : results.first is num
                    ? [
                        ValidatedQuantity(
                            value: Decimal.fromString(results.first.toString()),
                            code: '1')
                      ]
                    : results.first is String
                        ? [
                            ValidatedQuantity.fromString(
                                results.first as String)
                          ]
                        : [];
    if (nextParser != null) {
      return nextParser!.execute(newResults(), passed);
    } else {
      return newResults();
    }
  }

  @override
  String prettyPrint([int indent = 2]) => '.toQuantity()';
}

/// Checks if input can be converted to a [Quantity]
class ConvertsToQuantityParser extends FhirPathParser {
  const ConvertsToQuantityParser([FhirPathParser? super.nextParser]);

  FhirPathParser copyWithNextParser(FhirPathParser nextParser) =>
      ConvertsToQuantityParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    List newResults() {
      if (results.isEmpty) {
        return [];
      } else {
        /// if there's more than 1 item in context, throw exception
        if (results.length > 1) {
          throw _conversionException('.convertsToQuantity()', results);
        }

        /// otherwise if the first item is a Quantity already, a num or a
        /// bool, this is considered true
        else if (results.first is ValidatedQuantity ||
            results.first is num ||
            results.first is bool) {
          return [true];
        }

        /// If it's a string & convertible to a Quantity using the Regex
        /// TODO(Dokotela): this is kind of the cheap way out, for now
        else if (results.first is String &&
            ucumUnitCodes
                .contains(ValidatedQuantity.fromString(results.first))) {
          return [true];
        }

        /// Otherwise it's definitely false
        else {
          return [false];
        }
      }
    }

    if (nextParser != null) {
      return nextParser!.execute(newResults(), passed);
    } else {
      return newResults();
    }
  }

  @override
  String prettyPrint([int indent = 2]) => '.convertsToQuantity()';
}

bool _isNotAcceptedType(List results) =>
    results.first is! bool && results.first is! num && results.first is! String;

bool _isAllTypes(List results) =>
    results.first is! bool &&
    results.first is! num &&
    results.first is! String &&
    results.first is! FhirDate &&
    results.first is! FhirDateTime &&
    results.first is! FhirTime &&
    results.first is! DateTime &&
    results.first is! ValidatedQuantity;

Exception _conversionException(String function, List results) =>
    FhirPathEvaluationException(
        'The function $function only accepts lists with 0 or 1 items.',
        operation: function,
        collection: results);

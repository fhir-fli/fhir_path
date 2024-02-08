// ignore_for_file: annotate_overrides, overridden_fields, avoid_dynamic_calls

// Package imports:
import 'package:fhir/primitive_types/primitive_types.dart';
import 'package:fhir/r4.dart';
import 'package:ucum/ucum.dart';

// Project imports:
import '../../fhir_path.dart';

class UnaryNegateParser extends OperatorParser {
  UnaryNegateParser();

  ParserList before = ParserList([]);
  ParserList after = ParserList([]);

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedAfter = after.execute(results.toList(), passed);

    if (executedAfter.isEmpty) {
      return [];
    }
    if (executedAfter.length != 1) {
      throw FhirPathInvalidExpressionException(
          'Unary negate needs to be applied on a single item. Found instead: $executedAfter');
    }
    if (executedAfter.first is num) {
      return [-(executedAfter.first as num)];
    }
    if (executedAfter.first is ValidatedQuantity) {
      return [(executedAfter.first as ValidatedQuantity) * -1];
    } else {
      throw FhirPathInvalidExpressionException(
          'Unary negate needs to be followed by an integer, a decimal, or a quantity. Found instead: ${executedAfter.first}');
    }
  }

  /// To print the entire parsed FHIRPath expression, this includes ALL
  /// of the Parsers that are used in this package by the names used in
  /// this package. These are not always synonymous with the FHIRPath
  /// specification (although they usually are), and include some parser
  /// classes that were created for ease of evaluation but are not included
  /// at all as objects in the official spec. I'm generally going to recommend
  /// that you use [prettyPrint] instead
  @override
  String verbosePrint(int indent) => '${"  " * indent}UnaryNegativeParser'
      '\n${before.verbosePrint(indent + 1)}'
      '\n${after.verbosePrint(indent + 1)}';

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) =>
      '${"  " * (indent - 1)}-${after.prettyPrint(indent + 1)}';
}

class UnaryPlusParser extends OperatorParser {
  UnaryPlusParser();

  ParserList before = ParserList([]);
  ParserList after = ParserList([]);

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedAfter = after.execute(results.toList(), passed);

    return executedAfter;
  }

  /// To print the entire parsed FHIRPath expression, this includes ALL
  /// of the Parsers that are used in this package by the names used in
  /// this package. These are not always synonymous with the FHIRPath
  /// specification (although they usually are), and include some parser
  /// classes that were created for ease of evaluation but are not included
  /// at all as objects in the official spec. I'm generally going to recommend
  /// that you use [prettyPrint] instead
  @override
  String verbosePrint(int indent) => '${"  " * indent}UnaryPlusParser'
      '\n${before.verbosePrint(indent + 1)}'
      '\n${after.verbosePrint(indent + 1)}';

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) =>
      '${"  " * (indent - 1)}+${after.prettyPrint(indent + 1)}';
}

class StarParser extends OperatorParser {
  StarParser();
  ParserList before = ParserList([]);
  ParserList after = ParserList([]);

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedBefore = before.execute(results.toList(), passed);
    final executedAfter = after.execute(results.toList(), passed);
    if (executedBefore.isEmpty || executedAfter.isEmpty) {
      return [];
    } else if (executedBefore.length != 1 || executedAfter.length != 1) {
      throw FhirPathEvaluationException(
          'Math Operators require each operand to result in a '
          'single object. The "*" operator was passed the following:\n'
          'Operand 1: $executedBefore\n'
          'Operand 2: $executedAfter',
          operation: '*',
          collection: results);
    } else if (executedBefore.first is num && executedAfter.first is num) {
      return [(executedBefore.first as num) * (executedAfter.first as num)];
    } else if (executedBefore.first is ValidatedQuantity &&
        executedAfter.first is ValidatedQuantity) {
      return [
        (executedBefore.first as ValidatedQuantity) *
            (executedAfter.first as ValidatedQuantity)
      ];
    } else {
      throw FhirPathEvaluationException(
          'The "*" operator only accepts Integers, Decimals and '
          'Quantities, but was passed the following:\n'
          'Operand 1: ${executedBefore.first} (${executedBefore.first.runtimeType})\n'
          'Operand 2: ${executedAfter.first} (${executedAfter.first.runtimeType})',
          operation: '*',
          collection: results);
    }
  }

  /// To print the entire parsed FHIRPath expression, this includes ALL
  /// of the Parsers that are used in this package by the names used in
  /// this package. These are not always synonymous with the FHIRPath
  /// specification (although they usually are), and include some parser
  /// classes that were created for ease of evaluation but are not included
  /// at all as objects in the official spec. I'm generally going to recommend
  /// that you use [prettyPrint] instead
  @override
  String verbosePrint(int indent) => '${"  " * indent}StarParser'
      '\n${before.verbosePrint(indent + 1)}'
      '\n${after.verbosePrint(indent + 1)}';

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) => '*'
      '\n${"  " * indent}${before.prettyPrint(indent + 1)}'
      '\n${"  " * indent}${after.prettyPrint(indent + 1)}';
}

/// Divides the left operand by the right operand (supported for Integer, Decimal, and Quantity).
/// The result of a division is always Decimal, even if the inputs are both Integer. For integer division, use the div operator.

/// If an attempt is made to divide by zero, the result is empty.
class DivSignParser extends OperatorParser {
  DivSignParser();
  ParserList before = ParserList([]);
  ParserList after = ParserList([]);

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedBefore = before.execute(results.toList(), passed);
    final executedAfter = after.execute(results.toList(), passed);
    if (executedBefore.isEmpty || executedAfter.isEmpty) {
      return [];
    } else if (executedBefore.length != 1 || executedAfter.length != 1) {
      throw FhirPathEvaluationException(
          'Math Operators require each operand to result in a '
          'single object. The "/" operator was passed the following:\n'
          'Operand 1: $executedBefore\n'
          'Operand 2: $executedAfter',
          operation: '/',
          collection: results);
    } else if (executedBefore.first is num && executedAfter.first is num) {
      return (executedAfter.first != 0)
          ? [executedBefore.first / executedAfter.first]
          : [];
    } else if (executedBefore.first is ValidatedQuantity &&
        executedAfter.first is ValidatedQuantity) {
      return ((executedAfter.first as ValidatedQuantity) != 0)
          ? [
              (executedBefore.first as ValidatedQuantity) /
                  (executedAfter.first as ValidatedQuantity)
            ]
          : [];
    } else {
      throw FhirPathEvaluationException(
          'The "/" operator only accepts Integers, Decimals and '
          'Quantities, but was passed the following:\n'
          'Operand 1: ${executedBefore.first} (${executedBefore.first.runtimeType})\n'
          'Operand 2: ${executedAfter.first} (${executedAfter.first.runtimeType})',
          operation: '/',
          collection: results);
    }
  }

  /// To print the entire parsed FHIRPath expression, this includes ALL
  /// of the Parsers that are used in this package by the names used in
  /// this package. These are not always synonymous with the FHIRPath
  /// specification (although they usually are), and include some parser
  /// classes that were created for ease of evaluation but are not included
  /// at all as objects in the official spec. I'm generally going to recommend
  /// that you use [prettyPrint] instead
  @override
  String verbosePrint(int indent) => '${"  " * indent}DivSignParser'
      '\n${before.verbosePrint(indent + 1)}'
      '\n${after.verbosePrint(indent + 1)}';

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) => '/'
      '\n${"  " * indent}${before.prettyPrint(indent + 1)}'
      '\n${"  " * indent}${after.prettyPrint(indent + 1)}';
}

class DivStringParser extends OperatorParser {
  DivStringParser();
  ParserList before = ParserList([]);
  ParserList after = ParserList([]);

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedBefore = before.execute(results.toList(), passed);
    final executedAfter = after.execute(results.toList(), passed);
    if (executedBefore.isEmpty || executedAfter.isEmpty) {
      return [];
    } else if (executedBefore.length != 1 || executedAfter.length != 1) {
      throw FhirPathEvaluationException(
          'Math Operators require each operand to result in a '
          'single object. The "div" operator was passed the following:\n'
          'Operand 1: $executedBefore\n'
          'Operand 2: $executedAfter',
          operation: 'div',
          collection: results);
    } else if (executedBefore.first is num && executedAfter.first is num) {
      return (executedAfter.first != 0)
          ? [executedBefore.first ~/ executedAfter.first]
          : [];
    } else {
      throw FhirPathEvaluationException(
          'The "div" operator only accepts Integers, and Decimals, '
          'but was passed the following:\n'
          'Operand 1: ${executedBefore.first} (${executedBefore.first.runtimeType})\n'
          'Operand 2: ${executedAfter.first} (${executedAfter.first.runtimeType})',
          operation: 'div',
          collection: results);
    }
  }

  /// To print the entire parsed FHIRPath expression, this includes ALL
  /// of the Parsers that are used in this package by the names used in
  /// this package. These are not always synonymous with the FHIRPath
  /// specification (although they usually are), and include some parser
  /// classes that were created for ease of evaluation but are not included
  /// at all as objects in the official spec. I'm generally going to recommend
  /// that you use [prettyPrint] instead
  @override
  String verbosePrint(int indent) => '${"  " * indent}DivStringParser'
      '\n${before.verbosePrint(indent + 1)}'
      '\n${after.verbosePrint(indent + 1)}';

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) => 'div'
      '\n${"  " * indent}${before.prettyPrint(indent + 1)}'
      '\n${"  " * indent}${after.prettyPrint(indent + 1)}';
}

class ModParser extends OperatorParser {
  ModParser();
  ParserList before = ParserList([]);
  ParserList after = ParserList([]);

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedBefore = before.execute(results.toList(), passed);
    final executedAfter = after.execute(results.toList(), passed);
    if (executedBefore.isEmpty || executedAfter.isEmpty) {
      return [];
    } else if (executedBefore.length != 1 || executedAfter.length != 1) {
      throw FhirPathEvaluationException(
          'Math Operators require each operand to result in a '
          'single object. The "mod" operator was passed the following:\n'
          'Operand 1: $executedBefore\n'
          'Operand 2: $executedAfter',
          operation: 'mod',
          collection: results);
    } else if (executedAfter.first is num && executedAfter.first == 0) {
      return [];
    } else if (executedBefore.first is num && executedAfter.first is num) {
      return [executedBefore.first % executedAfter.first];
    } else if (executedBefore.first is ValidatedQuantity &&
        executedAfter.first is ValidatedQuantity) {
      return [
        (executedBefore.first as ValidatedQuantity) %
            (executedAfter.first as ValidatedQuantity)
      ];
    } else {
      throw FhirPathEvaluationException(
          'The "mod" operator only accepts Integers, Decimals and '
          'Quantities, but was passed the following:\n'
          'Operand 1: ${executedBefore.first} (${executedBefore.first.runtimeType})\n'
          'Operand 2: ${executedAfter.first} (${executedAfter.first.runtimeType})',
          operation: 'mod',
          collection: results);
    }
  }

  /// To print the entire parsed FHIRPath expression, this includes ALL
  /// of the Parsers that are used in this package by the names used in
  /// this package. These are not always synonymous with the FHIRPath
  /// specification (although they usually are), and include some parser
  /// classes that were created for ease of evaluation but are not included
  /// at all as objects in the official spec. I'm generally going to recommend
  /// that you use [prettyPrint] instead
  @override
  String verbosePrint(int indent) => '${"  " * indent}ModParser'
      '\n${before.verbosePrint(indent + 1)}'
      '\n${after.verbosePrint(indent + 1)}';

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) => '%'
      '\n${"  " * indent}${before.prettyPrint(indent + 1)}'
      '\n${"  " * indent}${after.prettyPrint(indent + 1)}';
}

class PlusParser extends OperatorParser {
  PlusParser();
  ParserList before = ParserList([]);
  ParserList after = ParserList([]);

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedBefore = before.execute(results.toList(), passed);
    final executedAfter = after.execute(results.toList(), passed);

    if (executedBefore.isEmpty || executedAfter.isEmpty) {
      return [];
    } else if (executedBefore.length != 1 || executedAfter.length != 1) {
      throw FhirPathEvaluationException(
          'Math Operators require each operand to result in a '
          'single object. The "+" operator was passed the following:\n'
          'Operand 1: $executedBefore\n'
          'Operand 2: $executedAfter',
          operation: '+',
          collection: results);
    } else {
      switch (executedBefore.first.runtimeType) {
        case int:
          {
            if (executedAfter.first is num) {
              return [executedBefore.first + executedAfter.first];
            }
            break;
          }
        case double:
          {
            if (executedAfter.first is num) {
              return [executedBefore.first + executedAfter.first];
            }
            break;
          }
        case ValidatedQuantity:
          {
            if (executedAfter.first is ValidatedQuantity) {
              return [
                (executedBefore.first as ValidatedQuantity) +
                    (executedAfter.first as ValidatedQuantity)
              ];
            } else if (executedAfter.first is FhirDateTimeBase) {
              if ((executedBefore.first as ValidatedQuantity).isDuration) {
                return [
                  executedAfter.first +
                      extendedDurationFromValidatedQuantity(
                          executedBefore.first)
                ];
              }
            }
            break;
          }
        case FhirDateTime:
          {
            if (executedAfter.first is ValidatedQuantity &&
                (executedAfter.first as ValidatedQuantity).isDuration) {
              return [
                (executedBefore.first +
                        extendedDurationFromValidatedQuantity(
                            executedAfter.first as ValidatedQuantity))
                    .toString()
              ];
            }
            break;
          }
        case FhirDate:
          {
            if (executedAfter.first is ValidatedQuantity &&
                (executedAfter.first as ValidatedQuantity).isDuration) {
              return [
                (executedBefore.first +
                        extendedDurationFromValidatedQuantity(
                            executedAfter.first as ValidatedQuantity))
                    .toString()
              ];
            }
            break;
          }
        case FhirTime:
          {
            if (executedAfter.first is ValidatedQuantity &&
                (executedAfter.first as ValidatedQuantity).isDuration) {
              return [
                (addToFhirTime(executedBefore.first,
                        (executedAfter.first as ValidatedQuantity)))
                    .toString()
              ];
            }
            break;
          }
        case String:
          {
            if (executedAfter.first is String) {
              return [executedBefore.first + executedAfter.first];
            } else if (executedAfter.first is ValidatedQuantity &&
                (executedAfter.first as ValidatedQuantity).isDuration) {
              if (FhirDateTime(executedBefore.first).isValid) {
                return [
                  (FhirDateTime(executedBefore.first) +
                          extendedDurationFromValidatedQuantity(
                              executedAfter.first))
                      .toString()
                ];
              } else if (FhirTime(executedBefore.first).isValid) {
                return [
                  addToFhirTime(FhirTime(executedBefore.first),
                          executedAfter.first as ValidatedQuantity)
                      .toString()
                ];
              }
            }
            break;
          }
        default:
          break;
      }
    }
    throw FhirPathEvaluationException(
        'The "+" operator only accepts (FHIR) Integers, '
        'Decimals, Quantities, String or (Dart) int, double, num, '
        'or Strings, but was passed the following:\n'
        'Operand 1: ${executedBefore.first} (${executedBefore.first.runtimeType})\n'
        'Operand 2: ${executedAfter.first} (${executedAfter.first.runtimeType})',
        operation: '+',
        collection: results);
  }

  /// To print the entire parsed FHIRPath expression, this includes ALL
  /// of the Parsers that are used in this package by the names used in
  /// this package. These are not always synonymous with the FHIRPath
  /// specification (although they usually are), and include some parser
  /// classes that were created for ease of evaluation but are not included
  /// at all as objects in the official spec. I'm generally going to recommend
  /// that you use [prettyPrint] instead
  @override
  String verbosePrint(int indent) => '${"  " * indent}PlusParser'
      '\n${before.verbosePrint(indent + 1)}'
      '\n${after.verbosePrint(indent + 1)}';

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) => '+'
      '\n${"  " * indent}${before.prettyPrint(indent + 1)}'
      '\n${"  " * indent}${after.prettyPrint(indent + 1)}';
}

class MinusParser extends OperatorParser {
  MinusParser();
  ParserList before = ParserList([]);
  ParserList after = ParserList([]);

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedBefore = before.execute(results.toList(), passed);
    final executedAfter = after.execute(results.toList(), passed);
    if (executedBefore.isEmpty || executedAfter.isEmpty) {
      return [];
    } else if (executedBefore.length != 1 || executedAfter.length != 1) {
      throw FhirPathEvaluationException(
          'Math Operators require each operand to result in a '
          'single object. The "-" operator was passed the following:\n'
          'Operand 1: $executedBefore\n'
          'Operand 2: $executedAfter',
          operation: '-',
          collection: results);
    } else {
      switch (executedBefore.first.runtimeType) {
        case int:
          {
            if (executedAfter.first is num) {
              return [
                (executedBefore.first as int) - (executedAfter.first as num)
              ];
            }
            break;
          }
        case double:
          {
            if (executedAfter.first is num) {
              return [
                (executedBefore.first as double) - (executedAfter.first as num)
              ];
            }
            break;
          }
        case ValidatedQuantity:
          {
            if (executedAfter.first is ValidatedQuantity) {
              return [
                (executedBefore.first as ValidatedQuantity) -
                    (executedAfter.first as ValidatedQuantity)
              ];
            }
            break;
          }
        case FhirDateTime:
          {
            if (executedAfter.first is ValidatedQuantity &&
                (executedAfter.first as ValidatedQuantity).isDuration) {
              return [
                (executedBefore.first -
                        extendedDurationFromValidatedQuantity(
                            executedAfter.first as ValidatedQuantity))
                    .toString()
              ];
            }
            break;
          }
        case FhirDate:
          {
            if (executedAfter.first is ValidatedQuantity &&
                (executedAfter.first as ValidatedQuantity).isDuration) {
              return [
                (executedBefore.first -
                        extendedDurationFromValidatedQuantity(
                            executedAfter.first as ValidatedQuantity))
                    .toString()
              ];
            }
            break;
          }
        case FhirTime:
          {
            if (executedAfter.first is ValidatedQuantity &&
                (executedAfter.first as ValidatedQuantity).isDuration) {
              return [
                subtractFromFhirTime(executedBefore.first,
                        (executedAfter.first as ValidatedQuantity))
                    .toString()
              ];
            }
            break;
          }
        case String:
          {
            if (executedAfter.first is ValidatedQuantity &&
                (executedAfter.first as ValidatedQuantity).isDuration) {
              if (FhirDateTime(executedBefore.first).isValid) {
                return [
                  (FhirDateTime(executedBefore.first) -
                          extendedDurationFromValidatedQuantity(
                              executedAfter.first))
                      .toString()
                ];
              } else if (FhirTime(executedBefore.first).isValid) {
                return [
                  subtractFromFhirTime(FhirTime(executedBefore.first),
                          executedAfter.first as ValidatedQuantity)
                      .toString()
                ];
              }
            }
            break;
          }
        default:
          break;
      }
      throw FhirPathEvaluationException(
          'The "-" operator only accepts Integers, Decimals and '
          'Quantities, but was passed the following:\n'
          'Operand 1: ${executedBefore.first} (${executedBefore.first.runtimeType})\n'
          'Operand 2: ${executedAfter.first} (${executedAfter.first.runtimeType})',
          operation: '-',
          collection: results);
    }
  }

  @override
  String toString() {
    return 'MinusParser: $before MINUS $after';
  }

  /// To print the entire parsed FHIRPath expression, this includes ALL
  /// of the Parsers that are used in this package by the names used in
  /// this package. These are not always synonymous with the FHIRPath
  /// specification (although they usually are), and include some parser
  /// classes that were created for ease of evaluation but are not included
  /// at all as objects in the official spec. I'm generally going to recommend
  /// that you use [prettyPrint] instead
  @override
  String verbosePrint(int indent) => '${"  " * indent}MinusParser'
      '\n${before.verbosePrint(indent + 1)}'
      '\n${after.verbosePrint(indent + 1)}';

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) => before.isEmpty
      ? '-${after.prettyPrint(indent + 1)}'
      : '-'
          '\n${"  " * indent}${before.prettyPrint(indent + 1)}'
          '\n${"  " * indent}${after.prettyPrint(indent + 1)}';
}

class StringConcatenationParser extends OperatorParser {
  StringConcatenationParser();
  ParserList before = ParserList([]);
  ParserList after = ParserList([]);

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedBefore = before.execute(results.toList(), passed);
    final executedAfter = after.execute(results.toList(), passed);

    if (executedBefore.length > 1 || executedAfter.length > 1) {
      throw FhirPathEvaluationException(
          'String concatenation operates on 2 single items. '
          'The "&" operator was passed the following:\n'
          'Operand 1: $executedBefore\n'
          'Operand 2: $executedAfter',
          operation: '&',
          collection: results);
    }

    if (executedBefore.isEmpty && executedAfter.isEmpty) {
      return [''];
    } else if (executedBefore.isNotEmpty &&
        executedBefore.first is String &&
        executedAfter.isEmpty) {
      return [(executedBefore.first as String)];
    } else if (executedBefore.isEmpty &&
        executedAfter.isNotEmpty &&
        executedAfter.first is String) {
      return [(executedAfter.first as String)];
    } else if (executedBefore.first is String &&
        executedAfter.first is String) {
      return [
        (executedBefore.first as String) + (executedAfter.first as String)
      ];
    } else {
      throw FhirPathEvaluationException(
          'The "&" operator only accepts Strings, but was passed '
          'the following:\n'
          'Operand 1: ${executedBefore.first} (${executedBefore.first.runtimeType})\n'
          'Operand 2: ${executedAfter.first} (${executedAfter.first.runtimeType})',
          operation: '&',
          collection: results);
    }
  }

  /// To print the entire parsed FHIRPath expression, this includes ALL
  /// of the Parsers that are used in this package by the names used in
  /// this package. These are not always synonymous with the FHIRPath
  /// specification (although they usually are), and include some parser
  /// classes that were created for ease of evaluation but are not included
  /// at all as objects in the official spec. I'm generally going to recommend
  /// that you use [prettyPrint] instead
  @override
  String verbosePrint(int indent) => '${"  " * indent}StringConcatenationParser'
      '\n${before.verbosePrint(indent + 1)}'
      '\n${after.verbosePrint(indent + 1)}';

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) => 'stringConcatenation('
      '\n${"  " * indent}${before.prettyPrint(indent + 1)}'
      '\n${"  " * indent}${after.prettyPrint(indent + 1)}\n'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

ExtendedDuration extendedDurationFromValidatedQuantity(
  ValidatedQuantity validatedQuantity,
) =>
    ExtendedDuration(
      years: validatedQuantity.years?.toInt() ?? 0,
      months: validatedQuantity.months?.toInt() ?? 0,
      days: validatedQuantity.days?.toInt() ?? 0,
      hours: validatedQuantity.hours?.toInt() ?? 0,
      minutes: validatedQuantity.minutes?.toInt() ?? 0,
      seconds: validatedQuantity.seconds?.toInt() ?? 0,
      milliseconds: validatedQuantity.milliseconds?.toInt() ?? 0,
    );

FhirTime addToFhirTime(
  FhirTime fhirTime,
  ValidatedQuantity validatedQuantity,
) =>
    fhirTime.plus(
      hours: validatedQuantity.hours?.toInt() ?? 0,
      minutes: validatedQuantity.minutes?.toInt() ?? 0,
      seconds: validatedQuantity.seconds?.toInt() ?? 0,
      milliseconds: validatedQuantity.milliseconds?.toInt() ?? 0,
    );

FhirTime subtractFromFhirTime(
  FhirTime fhirTime,
  ValidatedQuantity validatedQuantity,
) =>
    fhirTime.subtract(
      hours: validatedQuantity.hours?.toInt() ?? 0,
      minutes: validatedQuantity.minutes?.toInt() ?? 0,
      seconds: validatedQuantity.seconds?.toInt() ?? 0,
      milliseconds: validatedQuantity.milliseconds?.toInt() ?? 0,
    );

// ignore_for_file: annotate_overrides, overridden_fields, avoid_function_literals_in_foreach_calls

// Project imports:
import '../../fhir_path.dart';

class UnionOperatorParser extends OperatorParser {
  const UnionOperatorParser(super.before, super.after);
  UnionOperatorParser copyWith(ParserList before, ParserList after) =>
      UnionOperatorParser(before, after);

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedBefore = before.execute(results.toList(), passed);
    final executedAfter = after.execute(results.toList(), passed);
    executedBefore.forEach((e) {
      if (notFoundInList(executedAfter, e)) {
        executedAfter.add(e);
      }
    });
    return executedAfter;
  }

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) => '${"  " * indent}unionOperator('
      '\n${before.prettyPrint(indent + 1)}'
      '\n${after.prettyPrint(indent + 1)}\n'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

// http://hl7.org/fhirpath/#contains-containership
class ContainsOperatorParser extends OperatorParser {
  const ContainsOperatorParser(super.before, super.after);
  ContainsOperatorParser copyWith(ParserList before, ParserList after) =>
      ContainsOperatorParser(before, after);

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    final leftOperand = before.execute(results.toList(), passed);
    final rightOperand = after.execute(results.toList(), passed);

    if (leftOperand.isEmpty) {
      return [false];
    }

    if (rightOperand.isEmpty) {
      return [];
    }

    if (rightOperand.length > 1) {
      throw FhirPathEvaluationException(
          "The 'contains' operator is expecting a single item on its right side. Found $rightOperand",
          operation: 'contains',
          collection: results);
    }

    final rightItem = rightOperand.first.toString();

    return [
      leftOperand.firstWhere((leftItem) => leftItem.toString() == rightItem,
              orElse: () => null) !=
          null
    ];
  }

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) => '${"  " * indent}containsOperator('
      '\n${before.prettyPrint(indent + 1)}'
      '\n${after.prettyPrint(indent + 1)}\n'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

/// http://hl7.org/fhirpath/N1/#in-membership
class InParser extends OperatorParser {
  const InParser(super.before, super.after);
  InParser copyWith(ParserList before, ParserList after) =>
      InParser(before, after);

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedBefore = before.execute(results.toList(), passed);
    final executedAfter = after.execute(results.toList(), passed);

    if (executedBefore.isEmpty) {
      return (executedAfter.isEmpty) ? [] : [false];
    }

    if (executedBefore.length > 1) {
      throw FhirPathEvaluationException(
          "The 'in' operator is expecting a single item on its left side. Found $executedBefore",
          operation: 'in',
          collection: results);
    }

    final leftItem = executedBefore.first.toString();
    return [
      executedAfter.firstWhere((rightItem) => rightItem.toString() == leftItem,
              orElse: () => null) !=
          null
    ];
  }

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) => '${"  " * indent}in('
      '\n${before.prettyPrint(indent + 1)}'
      '\n${after.prettyPrint(indent + 1)}\n'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

class CommaParser extends OperatorParser {
  const CommaParser(super.before, super.after);
  CommaParser copyWith(ParserList before, ParserList after) =>
      CommaParser(before, after);

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    final beforeResults = results.toList();
    final afterResults = results.toList();
    final beforeList = before.execute(beforeResults, passed);
    final afterList = after.execute(afterResults, passed);

    final outcome = [];
    if (beforeList.isEmpty) {
      outcome.add([]);
    } else {
      outcome.addAll(beforeList);
    }

    if (afterList.isEmpty) {
      outcome.add([]);
    } else {
      outcome.addAll(afterList);
    }

    return outcome;
  }

  @override
  String toString() {
    return 'CommaParser - $before COMMA $after';
  }

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) =>
      '${"  " * indent},${super.prettyPrint(indent)}';
}

// ignore_for_file: overridden_fields, annotate_overrides

// Project imports:
import '../../fhir_path.dart';

class AndStringParser extends OperatorParser {
  const AndStringParser(super.before, super.after);
  AndStringParser copyWith(ParserList before, ParserList after) =>
      AndStringParser(before, after);

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedBefore = before.execute(results.toList(), passed);
    final executedAfter = after.execute(results.toList(), passed);

    final beforeBool = SingletonEvaluation.toBool(executedBefore,
        name: "parameter before 'and'", operation: 'and', collection: results);
    final afterBool = SingletonEvaluation.toBool(executedAfter,
        name: "parameter after 'and'", operation: 'and', collection: results);

    if (beforeBool == true && afterBool == true) {
      return [true];
    }

    if (beforeBool == false || afterBool == false) {
      return [false];
    }

    return [];
  }

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) =>
      '${"  " * indent}and${super.prettyPrint(indent)}';
}

class XorParser extends OperatorParser {
  const XorParser(super.before, super.after);
  XorParser copyWith(ParserList before, ParserList after) =>
      XorParser(before, after);

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedBefore = before.execute(results.toList(), passed);
    final executedAfter = after.execute(results.toList(), passed);

    final beforeBool = SingletonEvaluation.toBool(executedBefore,
        name: "parameter before 'xor'", operation: 'xor', collection: results);
    final afterBool = SingletonEvaluation.toBool(executedAfter,
        name: "parameter after 'xor'", operation: 'xor', collection: results);

    if (beforeBool == null || afterBool == null) {
      return [];
    }

    if (beforeBool == false && afterBool == false) {
      return [false];
    }

    if (beforeBool == true && afterBool == true) {
      return [false];
    }

    return [true];
  }

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) =>
      '${"  " * indent}xor${super.prettyPrint(indent)}';
}

class OrStringParser extends OperatorParser {
  const OrStringParser(super.before, super.after);
  OrStringParser copyWith(ParserList before, ParserList after) =>
      OrStringParser(before, after);

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedBefore = before.execute(results.toList(), passed);
    final executedAfter = after.execute(results.toList(), passed);

    final beforeBool = SingletonEvaluation.toBool(executedBefore,
        name: "parameter before 'or'", operation: 'or', collection: results);
    final afterBool = SingletonEvaluation.toBool(executedAfter,
        name: "parameter after 'or'", operation: 'or', collection: results);

    if (beforeBool == true || afterBool == true) {
      return [true];
    }

    if (beforeBool == null || afterBool == null) {
      return [];
    }

    return [false];
  }

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) =>
      '${"  " * indent}or${super.prettyPrint(indent)}';
}

class ImpliesParser extends OperatorParser {
  const ImpliesParser(super.before, super.after);
  ImpliesParser copyWith(ParserList before, ParserList after) =>
      ImpliesParser(before, after);

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedBefore = before.execute(results.toList(), passed);
    final executedAfter = after.execute(results.toList(), passed);

    final beforeBool = SingletonEvaluation.toBool(executedBefore,
        name: "parameter before 'implies'",
        operation: 'implies',
        collection: results);
    final afterBool = SingletonEvaluation.toBool(executedAfter,
        name: "parameter after 'implies'",
        operation: 'implies',
        collection: results);

    if (beforeBool == true) {
      return afterBool != null ? [afterBool] : [];
    }

    if (beforeBool == false) {
      return [true];
    }

    if (afterBool == true) {
      return [true];
    }

    return [];
  }

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) => '${"  " * indent}implies('
      '\n${"  " * indent}${before.prettyPrint(indent + 1)}'
      '\n${"  " * indent}${after.prettyPrint(indent + 1)}\n'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

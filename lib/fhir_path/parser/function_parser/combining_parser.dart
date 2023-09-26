// ignore_for_file: annotate_overrides, overridden_fields

import '../../fhir_path.dart';

/// Merge the two collections into a single collection,
/// eliminating any duplicate values (using = (Equals) (=) to
/// determine equality). There is no expectation of order in
/// the resulting collection.
class UnionFunctionParser extends FunctionParser {
  const UnionFunctionParser(super.value);
  UnionFunctionParser copyWith(ParserList valueList) =>
      UnionFunctionParser(valueList);

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedValue = value.execute(results.toList(), passed);
    final finalResults = [];
    finalResults
      ..addAll(results.where((r) => notFoundInList(finalResults, r)))
      ..addAll(executedValue.where((v) => notFoundInList(finalResults, v)));
    return finalResults;
  }

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) => value.isEmpty
      ? '${"  " * indent}.union()'
      : '${"  " * indent}.union(\n${"  " * indent}${value.prettyPrint(indent + 1)}\n'
          '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

/// Merge the input and other collections into a single collection
/// without eliminating duplicate values. Combining an empty collection
/// with a non-empty collection will return the non-empty collection.
/// There is no expectation of order in the resulting collection.
class CombineParser extends FunctionParser {
  const CombineParser(super.value);
  CombineParser copyWith(ParserList valueList) => CombineParser(valueList);

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    if (value.isEmpty) {
      return results;
    } else {
      final executedValue = value.execute(results.toList(), passed);
      executedValue.addAll(results);
      return executedValue;
    }
  }

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) => value.isEmpty
      ? '${"  " * indent}.combine()'
      : '${"  " * indent}.combine(\n${"  " * indent}${value.prettyPrint(indent + 1)}\n'
          '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

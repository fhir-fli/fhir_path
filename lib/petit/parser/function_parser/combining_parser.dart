// ignore_for_file: annotate_overrides, overridden_fields

// Project imports:
import '../../petit_fhir_path.dart';

/// Merge the two collections into a single collection,
/// eliminating any duplicate values (using = (Equals) (=) to
/// determine equality). There is no expectation of order in
/// the resulting collection.
class UnionFunctionParser extends FunctionParser {
  UnionFunctionParser([FhirPathParser? nextParser])
      : super(ParserList([]), nextParser);

  UnionFunctionParser copyWithNextParser(FhirPathParser nextParser) =>
      UnionFunctionParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedValue = value.execute(results.toList(), passed);
    final finalResults = [];
    finalResults
      ..addAll(results.where((r) => notFoundInList(finalResults, r)))
      ..addAll(executedValue.where((v) => notFoundInList(finalResults, v)));
    return finalResults;
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}UnionParser\n${value.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) => value.isEmpty
      ? '.union()'
      : '.union(\n${"  " * indent}${value.prettyPrint(indent + 1)}\n'
          '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

/// Merge the input and other collections into a single collection
/// without eliminating duplicate values. Combining an empty collection
/// with a non-empty collection will return the non-empty collection.
/// There is no expectation of order in the resulting collection.
class CombineParser extends FunctionParser {
  CombineParser([FhirPathParser? nextParser])
      : super(ParserList([]), nextParser);

  CombineParser copyWithNextParser(FhirPathParser nextParser) =>
      CombineParser(nextParser);

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

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}CombineParser\n${value.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) => value.isEmpty
      ? '.combine()'
      : '.combine(\n${"  " * indent}${value.prettyPrint(indent + 1)}\n'
          '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

// ignore_for_file: annotate_overrides, overridden_fields

// Package imports:
import 'package:collection/collection.dart';

// Project imports:
import '../../petit_fhir_path.dart';

class SingleParser extends FhirPathParser {
  SingleParser([FhirPathParser? super.nextParser]);

  SingleParser copyWithNextParser(FhirPathParser nextParser) =>
      SingleParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => results.length == 1
      ? results
      : results.isEmpty
          ? []
          : throw FhirPathEvaluationException(
              'The List $results is only allowed to contain one '
              'item if evaluated using the .single() function',
              operation: '.single()',
              collection: results);

  @override
  String verbosePrint(int indent) => '${"  " * indent}SingleParser';

  @override
  String prettyPrint([int indent = 2]) => '.single()';
}

class FirstParser extends FhirPathParser {
  FirstParser([FhirPathParser? super.nextParser]);

  FirstParser copyWithNextParser(FhirPathParser nextParser) =>
      FirstParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) =>
      results.isEmpty ? [] : [results.first];

  @override
  String prettyPrint([int indent = 2]) => '.first()';
}

class LastParser extends FhirPathParser {
  LastParser([FhirPathParser? super.nextParser]);

  LastParser copyWithNextParser(FhirPathParser nextParser) =>
      LastParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) =>
      results.isEmpty ? [] : [results.last];

  @override
  String prettyPrint([int indent = 2]) => '.last()';
}

class TailParser extends FhirPathParser {
  TailParser([FhirPathParser? super.nextParser]);

  TailParser copyWithNextParser(FhirPathParser nextParser) =>
      TailParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    if (results.length < 2) {
      return [];
    } else {
      results.removeAt(0);
      return results;
    }
  }

  @override
  String prettyPrint([int indent = 2]) => '.tail()';
}

class FpSkipParser extends FunctionParser {
  FpSkipParser([FhirPathParser? nextParser])
      : super(ParserList([]), nextParser);

  FpSkipParser copyWithNextParser(FhirPathParser nextParser) =>
      FpSkipParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedValue = value.execute(results.toList(), passed);
    return executedValue.length != 1 || executedValue.first is! int
        ? throw FhirPathEvaluationException(
            'The argument passed to the .skip() function was not valid.',
            operation: '.skip()',
            arguments: value)
        : executedValue.first == null
            ? throw FhirPathEvaluationException(
                'The value for .skip() was not a number: ${executedValue.first}',
                operation: '.skip()',
                arguments: executedValue.first)
            : (executedValue.first as int) <= 0
                ? results
                : results.isEmpty ||
                        (executedValue.first as int) >= results.length
                    ? []
                    : results.sublist(executedValue.first as int);
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}SkipParser\n${value.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) =>
      '.skip(\n${"  " * indent}${value.prettyPrint(indent + 1)}\n'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

class TakeParser extends FunctionParser {
  TakeParser([FhirPathParser? nextParser]) : super(ParserList([]), nextParser);

  TakeParser copyWithNextParser(FhirPathParser nextParser) =>
      TakeParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedValue = value.execute(results.toList(), passed);
    final newResults = value.length != 1 || value.first is! IntegerParser
        ? throw FhirPathEvaluationException(
            'The argument passed to the .take() function was not valid:',
            operation: '.take()',
            arguments: value)
        : executedValue.first is! int
            ? throw FhirPathEvaluationException(
                'The value for .take() was not a number: $value',
                operation: '.take()',
                arguments: value)
            : (executedValue.first as int) <= 0 || results.isEmpty
                ? []
                : (executedValue.first as int) >= results.length
                    ? results
                    : results.sublist(0, executedValue.first as int);
    return newResults;
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}TakeParser\n${value.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) =>
      '.take(\n${"  " * indent}${value.prettyPrint(indent + 1)}\n'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

class IntersectParser extends ValueParser<ParserList> {
  IntersectParser([FhirPathParser? nextParser])
      : super(ParserList([]), nextParser);

  IntersectParser copyWithNextParser(FhirPathParser nextParser) =>
      IntersectParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final other = value.execute(results.toList(), passed);
    final inBag = [...results];

    // Eliminate duplicates in input
    final outBag = [];
    for (final item in inBag) {
      if (outBag.indexWhere((otherItem) =>
              const DeepCollectionEquality().equals(item, otherItem)) ==
          -1) {
        outBag.add(item);
      }
    }

    // Intersect
    outBag.removeWhere((e) =>
        other.indexWhere(
            (element) => const DeepCollectionEquality().equals(e, element)) ==
        -1);

    return outBag;
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}IntersectParser\n${value.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) =>
      '.intersect(\n${"  " * indent}${value.prettyPrint(indent + 1)}\n'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

class ExcludeParser extends ValueParser<ParserList> {
  ExcludeParser([FhirPathParser? nextParser])
      : super(ParserList([]), nextParser);

  ExcludeParser copyWithNextParser(FhirPathParser nextParser) =>
      ExcludeParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedValue = value.execute(results.toList(), passed);
    results.removeWhere((e) =>
        executedValue.indexWhere(
            (element) => const DeepCollectionEquality().equals(e, element)) !=
        -1);
    return results;
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}ExcludeParser\n${value.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) =>
      '.exclude(\n${"  " * indent}${value.prettyPrint(indent + 1)}\n'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

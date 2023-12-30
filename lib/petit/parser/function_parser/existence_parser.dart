// ignore_for_file: annotate_overrides, overridden_fields, avoid_dynamic_calls

// Package imports:
import 'package:collection/collection.dart';

// Project imports:
import '../../petit_fhir_path.dart';

/// Returns true if the input collection is empty ({ }) and false otherwise.
class EmptyParser extends FhirPathParser {
  const EmptyParser([FhirPathParser? super.nextParser]);

  EmptyParser copyWithNextParser(FhirPathParser nextParser) =>
      EmptyParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => nextParser != null
      ? nextParser!.execute(results.isEmpty ? [true] : [false], passed)
      : results.isEmpty
          ? [true]
          : [false];

  @override
  String prettyPrint([int indent = 2]) => '.empty()';
}

class HasValueParser extends ValueParser<ParserList> {
  HasValueParser([FhirPathParser? nextParser])
      : super(ParserList([]), nextParser);

  HasValueParser copyWithNextParser(FhirPathParser nextParser) =>
      HasValueParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    // Returns true if the input collection contains a single value which is a FHIR primitive,...
    if (results.length != 1) {
      return [false];
    }

    final element = results.first;

    if (element == null) {
      return [false];
    }

    // ...and it has a primitive value
    // (e.g. as opposed to not having a value and just having extensions).

    if (element is Map<String, dynamic>) {
      // element is a Map, most likely an answer. Introspect further...
      return [
        element.entries.any((mapEntry) =>
            mapEntry.key.startsWith('value') && mapEntry.value != null)
      ];
    } else {
      // element is a Dart primitive
      return [true];
    }
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}HasValueParser\n${value.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) =>
      '.hasValue(\n${"  " * indent}${value.prettyPrint(indent + 1)}\n'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

/// Returns true if the collection has any elements, and false otherwise.
/// This is the opposite of empty(), and as such is a shorthand for
/// empty().not(). If the input collection is empty ({ }), the result is false.
/// The function can also take an optional criteria to be applied to the
/// collection prior to the determination of the exists. In this case, the
/// function is shorthand for where(criteria).exists().
/// Note that a common term for this function is any.
class ExistsParser extends FunctionParser {
  ExistsParser([FhirPathParser? nextParser])
      : super(ParserList([]), nextParser);

  ExistsParser copyWithNextParser(FhirPathParser nextParser) =>
      ExistsParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final returnList =
        IterationContext.withIterationContext((iterationContext) {
      final iterationResult = [];
      results.forEachIndexed((i, element) {
        iterationContext.indexValue = i;
        iterationContext.thisValue = element;
        final newResult = value.execute([element], passed);
        if (newResult.isNotEmpty) {
          if (!(newResult.length == 1 && newResult.first == false)) {
            iterationResult.add(element);
          }
        }
      });
      return iterationResult;
    }, passed);

    return [returnList.isNotEmpty];
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}ExistsParser\n${value.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) =>
      '.exists(${value.isEmpty ? "" : "\n${"  " * indent}${value.prettyPrint(indent + 1)}\n"}'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

class AllParser extends ValueParser<ParserList> {
  AllParser([FhirPathParser? nextParser]) : super(ParserList([]), nextParser);

  AllParser copyWithNextParser(FhirPathParser nextParser) =>
      AllParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    if (results.isEmpty) {
      return [true];
    }
    return IterationContext.withIterationContext((iterationContext) {
      bool allResult = true;
      results.forEachIndexed((i, r) {
        iterationContext.thisValue = r;
        iterationContext.indexValue = i;
        final executedValue = value.execute([r], passed);
        if (SingletonEvaluation.toBool(executedValue,
                name: 'expression in all()', operation: 'all') !=
            true) {
          allResult = false;
          return;
        }
      });
      return [allResult];
    }, passed);
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}AllParser\n${value.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) {
    if (value.isEmpty) {
      return '.all()';
    }
    return '.all(\n${"  " * indent}${value.prettyPrint(indent + 1)}\n'
        '${indent <= 0 ? "" : "  " * (indent - 1)})';
  }
}

/// Takes a collection of Boolean values and returns true if all the items are true.
/// If any items are false, the result is false. If the input is empty ({ }), the result is true.
class AllTrueParser extends FhirPathParser {
  AllTrueParser([FhirPathParser? super.nextParser]);

  AllTrueParser copyWithNextParser(FhirPathParser nextParser) =>
      AllTrueParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    if (results.isEmpty) {
      return nextParser != null ? nextParser!.execute([true], passed) : [true];
    }
    results.removeWhere((element) => element == true);
    return nextParser != null
        ? nextParser!.execute([results.isEmpty], passed)
        : [results.isEmpty];
  }

  @override
  String prettyPrint([int indent = 2]) => '.allTrue()';
}

/// Takes a collection of Boolean values and returns true if any of the items are true.
/// If all the items are false, or if the input is empty ({ }), the result is false.
class AnyTrueParser extends FhirPathParser {
  AnyTrueParser([FhirPathParser? super.nextParser]);

  AnyTrueParser copyWithNextParser(FhirPathParser nextParser) =>
      AnyTrueParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    if (results.isEmpty) {
      return nextParser != null
          ? nextParser!.execute([false], passed)
          : [false];
    }
    results.retainWhere((element) => element == true);
    return nextParser != null
        ? nextParser!.execute([results.isNotEmpty], passed)
        : [results.isNotEmpty];
  }

  @override
  String prettyPrint([int indent = 2]) => '.anyTrue()';
}

/// Takes a collection of Boolean values and returns true if all the items are false.
/// If any items are true, the result is false. If the input is empty ({ }), the result is true.
class AllFalseParser extends FhirPathParser {
  AllFalseParser([FhirPathParser? super.nextParser]);

  AllFalseParser copyWithNextParser(FhirPathParser nextParser) =>
      AllFalseParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    if (results.isEmpty) {
      return [true];
    }
    results.removeWhere((element) => element == false);
    return [results.isEmpty];
  }

  @override
  String prettyPrint([int indent = 2]) => '.allFalse()';
}

/// Takes a collection of Boolean values and returns true if any of the items are false.
/// If all the items are true, or if the input is empty ({ }), the result is false.
class AnyFalseParser extends FhirPathParser {
  AnyFalseParser([FhirPathParser? super.nextParser]);

  AnyFalseParser copyWithNextParser(FhirPathParser nextParser) =>
      AnyFalseParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    if (results.isEmpty) {
      return [false];
    }
    results.retainWhere((element) => element == false);
    return [results.isNotEmpty];
  }

  @override
  String prettyPrint([int indent = 2]) => '.anyFalse()';
}

class SubsetOfParser extends ValueParser<ParserList> {
  SubsetOfParser([FhirPathParser? nextParser])
      : super(ParserList([]), nextParser);

  SubsetOfParser copyWithNextParser(FhirPathParser nextParser) =>
      SubsetOfParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    if (results.isEmpty) {
      return [true];
    } else {
      final executedValue = value.execute(results.toList(), passed);
      for (final r in results) {
        if (notFoundInList(executedValue, r)) {
          return [false];
        }
      }
      return [true];
    }
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}SubsetOfParser\n${value.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) =>
      '.subsetOf(\n${"  " * indent}${value.prettyPrint(indent + 1)}\n'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

class SupersetOfParser extends ValueParser {
  SupersetOfParser(super.value, [FhirPathParser? super.nextParser]);

  SupersetOfParser copyWithNextParser(FhirPathParser nextParser) =>
      SupersetOfParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    if (results.isEmpty) {
      return [false];
    } else {
      final executedValue = value.execute(results.toList(), passed);
      for (final v in executedValue) {
        if (notFoundInList(results, v)) {
          return [false];
        }
      }
      return [true];
    }
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}SupersetOfParser\n${value.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) =>
      '.supersetOf(\n${"  " * indent}${value.prettyPrint(indent + 1)}\n'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

class CountParser extends FhirPathParser {
  CountParser([FhirPathParser? super.nextParser]);

  CountParser copyWithNextParser(FhirPathParser nextParser) =>
      CountParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => [results.length];

  @override
  String prettyPrint([int indent = 2]) => '.count()';
}

class DistinctParser extends FhirPathParser {
  DistinctParser([FhirPathParser? super.nextParser]);

  DistinctParser copyWithNextParser(FhirPathParser nextParser) =>
      DistinctParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final resultsList = [];
    for (final r in results) {
      if (notFoundInList(resultsList, r)) {
        resultsList.add(r);
      }
    }
    return resultsList;
  }

  @override
  String prettyPrint([int indent = 2]) => '.distinct()';
}

class IsDistinctParser extends FhirPathParser {
  IsDistinctParser([FhirPathParser? super.nextParser]);

  IsDistinctParser copyWithNextParser(FhirPathParser nextParser) =>
      IsDistinctParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final resultsList = [];
    for (final r in results) {
      if (notFoundInList(resultsList, r)) {
        resultsList.add(r);
      }
    }
    return [resultsList.length == results.length];
  }

  @override
  String prettyPrint([int indent = 2]) => '.isDistinct()';
}

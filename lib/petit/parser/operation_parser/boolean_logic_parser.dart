// ignore_for_file: overridden_fields, annotate_overrides

// Project imports:
import '../../petit_fhir_path.dart';

class AndStringParser extends OperatorParser {
  AndStringParser([FhirPathParser? super.nextParser]);

  AndStringParser copyWithNextParser(FhirPathParser nextParser) =>
      AndStringParser(nextParser);
  ParserList before = ParserList([]);
  ParserList after = ParserList([]);

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

  @override
  String verbosePrint(int indent) => '${"  " * indent}AndStringParser'
      '\n${before.verbosePrint(indent + 1)}'
      '\n${after.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) => 'and'
      '\n${"  " * indent}${before.prettyPrint(indent + 1)}'
      '\n${"  " * indent}${after.prettyPrint(indent + 1)}';
}

class XorParser extends OperatorParser {
  XorParser([FhirPathParser? super.nextParser]);

  XorParser copyWithNextParser(FhirPathParser nextParser) =>
      XorParser(nextParser);
  ParserList before = ParserList([]);
  ParserList after = ParserList([]);

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

  @override
  String verbosePrint(int indent) => '${"  " * indent}XorParser'
      '\n${before.verbosePrint(indent + 1)}'
      '\n${after.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) => 'xor'
      '\n${"  " * indent}${before.prettyPrint(indent + 1)}'
      '\n${"  " * indent}${after.prettyPrint(indent + 1)}';
}

class OrStringParser extends OperatorParser {
  OrStringParser([FhirPathParser? super.nextParser]);

  OrStringParser copyWithNextParser(FhirPathParser nextParser) =>
      OrStringParser(nextParser);
  ParserList before = ParserList([]);
  ParserList after = ParserList([]);

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

  @override
  String verbosePrint(int indent) => '${"  " * indent}OrStringParser'
      '\n${before.verbosePrint(indent + 1)}'
      '\n${after.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) => 'or'
      '\n${"  " * indent}${before.prettyPrint(indent + 1)}'
      '\n${"  " * indent}${after.prettyPrint(indent + 1)}';
}

class ImpliesParser extends OperatorParser {
  ImpliesParser([FhirPathParser? super.nextParser]);

  ImpliesParser copyWithNextParser(FhirPathParser nextParser) =>
      ImpliesParser(nextParser);
  ParserList before = ParserList([]);
  ParserList after = ParserList([]);

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

  @override
  String verbosePrint(int indent) => '${"  " * indent}ImpliesParser'
      '\n${before.verbosePrint(indent + 1)}'
      '\n${after.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) => 'implies('
      '\n${"  " * indent}${before.prettyPrint(indent + 1)}'
      '\n${"  " * indent}${after.prettyPrint(indent + 1)}\n'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

// ignore_for_file: annotate_overrides, overridden_fields, avoid_dynamic_calls, prefer_if_elements_to_conditional_expressions

// Dart imports:
import 'dart:math';

// Project imports:
import '../../petit_fhir_path.dart';

class AbsParser extends FhirPathParser {
  AbsParser([FhirPathParser? super.nextParser]);

  AbsParser copyWithNextParser(FhirPathParser nextParser) =>
      AbsParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => results.isEmpty
      ? []
      : results.length > 1
          ? throw _wrongLength('.abs()', results)
          : results.first is num
              ? (results.first as num).abs().isNaN
                  ? []
                  : [(results.first as num).abs()]
              : results.first is FhirPathQuantity
                  ? (results.first as FhirPathQuantity).abs().isNaN
                      ? []
                      : [(results.first as FhirPathQuantity).abs()]
                  : throw _wrongTypes('.abs()', results, 'none');

  @override
  String verbosePrint(int indent) => '${"  " * indent}AbsParser';

  @override
  String prettyPrint([int indent = 2]) => '.abs()';
}

class CeilingParser extends FhirPathParser {
  CeilingParser([FhirPathParser? super.nextParser]);

  CeilingParser copyWithNextParser(FhirPathParser nextParser) =>
      CeilingParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => results.isEmpty
      ? []
      : results.length > 1
          ? throw _wrongLength('.ceiling()', results)
          : results.first is num
              ? [(results.first as num).ceil()]
              : throw _wrongTypes('.ceiling()', results, 'none');

  @override
  String verbosePrint(int indent) => '${"  " * indent}CeilingParser';

  @override
  String prettyPrint([int indent = 2]) => '.ceiling()';
}

class ExpParser extends FhirPathParser {
  ExpParser([FhirPathParser? super.nextParser]);

  ExpParser copyWithNextParser(FhirPathParser nextParser) =>
      ExpParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => results.isEmpty
      ? []
      : results.length > 1
          ? throw _wrongLength('.exp()', results)
          : results.first is num
              ? [exp(results.first as num)]
              : throw _wrongTypes('.exp()', results, 'none');

  @override
  String verbosePrint(int indent) => '${"  " * indent}ExpParser';

  @override
  String prettyPrint([int indent = 2]) => '.exp()';
}

class FloorParser extends FhirPathParser {
  FloorParser([FhirPathParser? super.nextParser]);

  FloorParser copyWithNextParser(FhirPathParser nextParser) =>
      FloorParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => results.isEmpty
      ? []
      : results.length > 1
          ? throw _wrongLength('.floor()', results)
          : results.first is num
              ? [(results.first as num).floor()]
              : throw _wrongTypes('.floor()', results, 'none');

  @override
  String verbosePrint(int indent) => '${"  " * indent}FloorParser';

  @override
  String prettyPrint([int indent = 2]) => '.floor()';
}

class LnParser extends FhirPathParser {
  LnParser([FhirPathParser? super.nextParser]);

  LnParser copyWithNextParser(FhirPathParser nextParser) =>
      LnParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => results.isEmpty
      ? []
      : results.length > 1
          ? throw _wrongLength('.ln()', results)
          : results.first is num
              ? [log(results.first as num)]
              : throw _wrongTypes('.ln()', results, 'none');

  @override
  String verbosePrint(int indent) => '${"  " * indent}LnParser';

  @override
  String prettyPrint([int indent = 2]) => '.ln()';
}

class LogParser extends ValueParser<ParserList> {
  LogParser([FhirPathParser? nextParser]) : super(ParserList([]), nextParser);

  LogParser copyWithNextParser(FhirPathParser nextParser) =>
      LogParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedValue = value.execute(results.toList(), passed);
    return results.isEmpty
        ? []
        : results.length > 1
            ? throw _wrongLength('.log()', results)
            : executedValue.length > 1
                ? throw _wrongArgLength('log()', executedValue)
                : executedValue.first is num && results.first is num
                    ? [
                        log(results.first as num) /
                            log(executedValue.first as num)
                      ]
                    : throw _wrongTypes('log()', results, executedValue);
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}LogParser\n${value.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) =>
      '.log(\n${"  " * indent}${value.prettyPrint(indent + 1)}\n'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

class PowerParser extends ValueParser<ParserList> {
  PowerParser([FhirPathParser? nextParser]) : super(ParserList([]), nextParser);

  PowerParser copyWithNextParser(FhirPathParser nextParser) =>
      PowerParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedValue = value.execute(results.toList(), passed);
    if (results.isEmpty || executedValue.isEmpty) {
      return [];
    } else if (results.length > 1) {
      throw _wrongLength('.power()', results);
    } else if (executedValue.length > 1) {
      throw _wrongArgLength('.power()', executedValue);
    }
    final finalResults = results.first is num
        ? results.first
        : throw _wrongTypes('.power()', results, executedValue);
    final finalValue = executedValue.first is num
        ? executedValue.first
        : throw _wrongTypes('.power()', results, executedValue);
    return pow(finalResults as num, finalValue as num).isNaN
        ? []
        : [pow(finalResults, finalValue)];
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}PowerParser\n${value.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) =>
      '.power(\n${"  " * indent}${value.prettyPrint(indent + 1)}\n'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

class RoundParser extends ValueParser<ParserList> {
  RoundParser([FhirPathParser? nextParser]) : super(ParserList([]), nextParser);

  RoundParser copyWithNextParser(FhirPathParser nextParser) =>
      RoundParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedValue = value.execute(results.toList(), passed);
    return results.isEmpty
        ? []
        : results.length > 1
            ? throw _wrongLength('.round()', results)
            : executedValue.isEmpty ||
                    executedValue.length != 1 ||
                    executedValue.first is! num
                ? throw _wrongTypes('.round()', results, executedValue)
                : results.first is! num
                    ? throw _wrongTypes('.round()', results, executedValue)
                    : [
                        executedValue.isEmpty
                            ? (results.first as num).round()
                            : double.parse((results.first as num)
                                .toStringAsFixed(executedValue.first as int))
                      ];
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}RoundParser\n${value.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) => value.isEmpty
      ? '.round()'
      : '.round(\n${"  " * indent}${value.prettyPrint(indent + 1)}\n'
          '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

class SqrtParser extends FhirPathParser {
  SqrtParser([FhirPathParser? super.nextParser]);

  SqrtParser copyWithNextParser(FhirPathParser nextParser) =>
      SqrtParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => results.isEmpty
      ? []
      : results.length > 1
          ? throw _wrongLength('.sqrt()', results)
          : results.first is num
              ? (sqrt(results.first as num).isNaN
                  ? []
                  : [sqrt(results.first as num)])
              : throw _wrongTypes('.sqrt()', results, 'none');

  @override
  String verbosePrint(int indent) => '${"  " * indent}SqrtParser';

  @override
  String prettyPrint([int indent = 2]) => '.sqrt()';
}

class TruncateParser extends ValueParser<int> {
  const TruncateParser([FhirPathParser? nextParser]) : super(0, nextParser);

  TruncateParser copyWithNextParser(FhirPathParser nextParser) =>
      TruncateParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => results.isEmpty
      ? []
      : results.length > 1
          ? throw _wrongLength('.truncate()', results)
          : results.first is num
              ? [(results.first as num).toInt()]
              : throw _wrongTypes('.truncate()', results, 'none');

  @override
  String verbosePrint(int indent) => '${"  " * indent}TruncateParser\n$value';

  @override
  String prettyPrint([int indent = 2]) {
    return '.truncate(\n$value\n'
        '${indent <= 0 ? "" : "  " * (indent - 1)})';
  }
}

Exception _wrongLength(String functionName, List results) =>
    FhirPathEvaluationException(
        'The function $functionName can only work on a collection'
        ' with 0 or 1 item.',
        collection: results);

Exception _wrongArgLength(String functionName, List value) =>
    FhirPathEvaluationException(
        'The function $functionName must have an argument that '
        'evaluates to 0 or 1 item.',
        operation: functionName,
        arguments: value);

Exception _wrongTypes(String functionName, List results, dynamic value) =>
    FhirPathEvaluationException(
        'The function $functionName cannot work with the types '
        'passed.',
        collection: results,
        arguments: value);

// ignore_for_file: annotate_overrides, overridden_fields, avoid_dynamic_calls

// Package imports:
import 'package:fhir/primitive_types/primitive_types.dart';

// Project imports:
import '../../petit_fhir_path.dart';

class FpNotParser extends FhirPathParser {
  FpNotParser([FhirPathParser? super.nextParser]);

  FpNotParser copyWithNextParser(FhirPathParser nextParser) =>
      FpNotParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final input = SingletonEvaluation.toBool(results,
        name: 'input for .not()', operation: 'not()', collection: results);
    return input != null ? [!input] : [];
  }

  @override
  String prettyPrint([int indent = 2]) => '.not()';
}

class NowParser extends FhirPathParser {
  NowParser([FhirPathParser? super.nextParser]);

  NowParser copyWithNextParser(FhirPathParser nextParser) =>
      NowParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) =>
      [FhirDateTime(DateTime.now())];

  @override
  String prettyPrint([int indent = 2]) => '.now()';
}

class TimeOfDayParser extends FhirPathParser {
  TimeOfDayParser([FhirPathParser? super.nextParser]);

  TimeOfDayParser copyWithNextParser(FhirPathParser nextParser) =>
      TimeOfDayParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => [
        FhirTime(
            DateTime.now().toIso8601String().split('T').last.substring(0, 12))
      ];

  @override
  String prettyPrint([int indent = 2]) => '.timeOfDay()';
}

class TodayParser extends FhirPathParser {
  TodayParser([FhirPathParser? super.nextParser]);

  TodayParser copyWithNextParser(FhirPathParser nextParser) =>
      TodayParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) =>
      [FhirDate(DateTime.now().toIso8601String().split('T').first)];

  @override
  String prettyPrint([int indent = 2]) => '.today()';
}

class TraceParser extends ValueParser<int> {
  const TraceParser([FhirPathParser? nextParser]) : super(0, nextParser);

  TraceParser copyWithNextParser(FhirPathParser nextParser) =>
      TraceParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => results;

  @override
  String verbosePrint(int indent) => '${"  " * indent}TraceParser\n$value';

  @override
  String prettyPrint([int indent = 2]) => 'trace(\n$value\n)';
}

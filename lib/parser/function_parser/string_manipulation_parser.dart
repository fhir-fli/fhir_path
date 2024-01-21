// ignore_for_file: annotate_overrides, overridden_fields

// Project imports:
import '../../fhir_path.dart';

class IndexOfParser extends ValueParser<ParserList> {
  IndexOfParser([FhirPathParser? nextParser])
      : super(ParserList([]), nextParser);

  IndexOfParser copyWithNextParser(FhirPathParser nextParser) =>
      IndexOfParser(nextParser);

  @override
  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedValue = value.execute(results.toList(), passed);
    return results.isEmpty
        ? []
        : results.length > 1
            ? throw _requiresList('.indexOf()', results)
            : executedValue.first is! String
                ? throw _requiresString('.indexOf()', results)
                : results.first.toString() == ''
                    ? []
                    : [
                        results.first
                            .toString()
                            .indexOf(executedValue.first as String)
                      ];
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}IndexOfParser\n${value.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) =>
      '.indexOf(\n${"  " * indent}${value.prettyPrint(indent + 1)}\n'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

class SubstringParser extends ValueParser<ParserList> {
  SubstringParser([FhirPathParser? nextParser])
      : super(ParserList([]), nextParser);

  SubstringParser copyWithNextParser(FhirPathParser nextParser) =>
      SubstringParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedValue = value.execute(results.toList(), passed);
    return results.isEmpty
        ? []
        : results.length > 1
            ? throw _requiresList('.substring()', results)
            : (results.first is! String)
                ? throw _requiresString('.substring()', results)
                : executedValue.isNotEmpty &&
                        executedValue.first is int &&
                        (((executedValue.first as int) >=
                                (results.first as String).length) ||
                            (executedValue.first as int) < 0)
                    ? []
                    : executedValue.length == 1 && executedValue.first is int
                        ? [
                            results.first
                                .toString()
                                .substring(executedValue.first as int)
                          ]
                        : executedValue.length == 2 &&
                                executedValue.first is int &&
                                executedValue.last is int
                            ? [
                                results.first.toString().substring(
                                      executedValue.first as int,
                                      ((executedValue.first as int) +
                                                  (executedValue.last as int)) >
                                              results.first.toString().length
                                          ? results.first.toString().length
                                          : ((executedValue.first as int) +
                                              (executedValue.last as int)),
                                    )
                              ]
                            : throw FhirPathEvaluationException(
                                'The function .substring() was not provided the '
                                ' proper parameters.',
                                operation: '.substring()',
                                collection: results,
                                arguments: executedValue);
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}SubstringParser\n${value.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) =>
      '.substring(\n${"  " * indent}${value.prettyPrint(indent + 1)}\n'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

class StartsWithParser extends ValueParser<ParserList> {
  StartsWithParser([FhirPathParser? nextParser])
      : super(ParserList([]), nextParser);

  StartsWithParser copyWithNextParser(FhirPathParser nextParser) =>
      StartsWithParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedValue = value.execute(results.toList(), passed);
    return results.isEmpty
        ? []
        : results.length > 1
            ? throw _requiresList('.startsWith()', results)
            : executedValue.first is! String
                ? throw _requiresString('.startsWith()', results)
                : results.first.toString() == ''
                    ? [true]
                    : [
                        results.first
                            .toString()
                            .startsWith(executedValue.first as String)
                      ];
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}StartsWithParser\n${value.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) =>
      '.startsWith(\n${"  " * indent}${value.prettyPrint(indent + 1)}\n'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

class EndsWithParser extends ValueParser<ParserList> {
  EndsWithParser([FhirPathParser? nextParser])
      : super(ParserList([]), nextParser);

  EndsWithParser copyWithNextParser(FhirPathParser nextParser) =>
      EndsWithParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedValue = value.execute(results.toList(), passed);
    return results.isEmpty
        ? []
        : results.length > 1
            ? throw _requiresList('.endsWith()', results)
            : executedValue.first is! String
                ? throw _requiresString('.endsWith()', results)
                : results.first.toString() == ''
                    ? [true]
                    : [
                        results.first
                            .toString()
                            .endsWith(executedValue.first as String)
                      ];
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}EndsWithParser\n${value.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) =>
      '.endsWith(\n${"  " * indent}${value.prettyPrint(indent + 1)}\n'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

// http://hl7.org/fhirpath/#containssubstring-string-boolean
class ContainsFunctionParser extends ValueParser<ParserList> {
  ContainsFunctionParser([FhirPathParser? nextParser])
      : super(ParserList([]), nextParser);

  ContainsFunctionParser copyWithNextParser(FhirPathParser nextParser) =>
      ContainsFunctionParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedValue = value.execute(results.toList(), passed);
    return results.isEmpty
        ? []
        : results
            .map((e) =>
                e is String && e.contains(executedValue.first.toString()))
            .toList();
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}ContainsFunctionParser\n${value.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) =>
      '.containsFunction(\n${"  " * indent}${"  " * indent}${value.prettyPrint(indent + 1)}\n'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

class UpperParser extends FhirPathParser {
  UpperParser([FhirPathParser? super.nextParser]);

  UpperParser copyWithNextParser(FhirPathParser nextParser) =>
      UpperParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => results.isEmpty
      ? []
      : results.length > 1
          ? throw _requiresList('.upper()', results)
          : [results.first.toString().toUpperCase()];

  @override
  String prettyPrint([int indent = 2]) => '.upper()';
}

class LowerParser extends FhirPathParser {
  LowerParser([FhirPathParser? super.nextParser]);

  LowerParser copyWithNextParser(FhirPathParser nextParser) =>
      LowerParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => results.isEmpty
      ? []
      : results.length > 1
          ? throw _requiresList('.lower()', results)
          : [results.first.toString().toLowerCase()];

  @override
  String prettyPrint([int indent = 2]) => '.lower()';
}

class ReplaceParser extends ValueParser<ParserList> {
  ReplaceParser([FhirPathParser? nextParser])
      : super(ParserList([]), nextParser);

  ReplaceParser copyWithNextParser(FhirPathParser nextParser) =>
      ReplaceParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedValue = value.execute(results.toList(), passed);
    return results.isEmpty
        ? []
        : results.length > 1
            ? throw _requiresList('.replace()', results)
            : executedValue.first is! String || executedValue.last is! String
                ? throw _requiresString('.replace()', results)
                : [
                    results.first.toString().replaceAll(
                        executedValue.first as String,
                        executedValue.last as String)
                  ];
  }

  @override
  String verbosePrint(int indent) => '${"  " * indent}ReplaceParser';

  @override
  String prettyPrint([int indent = 2]) => value.isEmpty
      ? '.replace()'
      : '.replace(\n${"  " * indent}${value.prettyPrint(indent + 1)}\n'
          '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

class FpMatchesParser extends ValueParser<ParserList> {
  FpMatchesParser([FhirPathParser? nextParser])
      : super(ParserList([]), nextParser);

  FpMatchesParser copyWithNextParser(FhirPathParser nextParser) =>
      FpMatchesParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedValue = value.execute(results.toList(), passed);
    return results.isEmpty || value.isEmpty
        ? []
        : results.length > 1
            ? throw _requiresList('.matches()', results)
            : executedValue.first is! String
                ? throw _requiresString('.matches()', results)
                : [
                    RegExp(executedValue.first as String)
                        .hasMatch(results.first.toString())
                  ];
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}FpMatchesParser\n${value.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) =>
      '.matches(\n${"  " * indent}${value.prettyPrint(indent + 1)}\n'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

class ReplaceMatchesParser extends ValueParser<ParserList> {
  ReplaceMatchesParser([FhirPathParser? nextParser])
      : super(ParserList([]), nextParser);

  ReplaceMatchesParser copyWithNextParser(FhirPathParser nextParser) =>
      ReplaceMatchesParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final executedValue = value.execute(results.toList(), passed);
    return results.isEmpty || value.isEmpty
        ? []
        : results.length > 1
            ? throw _requiresList('.replace()', results)
            : value.length == 3 &&
                    value.first is StringParser &&
                    value.last is StringParser
                ? [
                    results.first.toString().replaceAll(
                        RegExp('${executedValue.first}'),
                        '${executedValue.last}')
                  ]
                : throw FhirPathEvaluationException(
                    'The function .replace() was not provided the '
                    ' proper parameters.',
                    operation: '.replace()',
                    collection: results,
                    arguments: value);
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}ReplaceMatchesParser\n${value.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) =>
      '.replaceMatches(\n${"  " * indent}${value.prettyPrint(indent + 1)}\n'
      '${indent <= 0 ? "" : "  " * (indent - 1)})';
}

class LengthParser extends FhirPathParser {
  LengthParser([FhirPathParser? super.nextParser]);

  LengthParser copyWithNextParser(FhirPathParser nextParser) =>
      LengthParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => results.isEmpty
      ? []
      : results.length > 1
          ? throw _requiresList('.length()', results)
          : results.first is String
              ? [(results.first as String).length]
              : throw _requiresString('.length()', results);

  @override
  String prettyPrint([int indent = 2]) => '.length()';
}

class ToCharsParser extends FhirPathParser {
  ToCharsParser([FhirPathParser? super.nextParser]);

  ToCharsParser copyWithNextParser(FhirPathParser nextParser) =>
      ToCharsParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => results.isEmpty
      ? []
      : results.length > 1
          ? throw _requiresList('.toChars()', results)
          : results.first is String
              ? (results.first as String).split('')
              : throw _requiresString('.toChar()', results);

  @override
  String prettyPrint([int indent = 2]) => '.toChars()';
}

Exception _requiresList(String function, List results) =>
    FhirPathEvaluationException(
      'The function $function only accepts lists'
      ' with 0 or 1 item, this was the list passed: $results',
      operation: function,
      collection: results,
    );

Exception _requiresString(String function, List results) =>
    FhirPathEvaluationException(
      'The function $function was not applied to a string.',
      operation: function,
      collection: results,
    );

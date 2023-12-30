// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_dynamic_calls

// Package imports:
import 'package:collection/collection.dart';

// Project imports:
import '../../petit_fhir_path.dart';

class SumParser extends FhirPathParser {
  SumParser([FhirPathParser? super.nextParser]);

  SumParser copyWithNextParser(FhirPathParser nextParser) =>
      SumParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => [
        results
            .map((e) => e is num
                ? e
                : throw FhirPathEvaluationException(
                    'sum() can only add numbers.',
                    operation: 'sum',
                    arguments: e,
                    collection: results))
            .sum
      ];

  @override
  String prettyPrint([int indent = 2]) => '.sum()';
}

class MinParser extends FhirPathParser {
  MinParser([FhirPathParser? super.nextParser]);

  MinParser copyWithNextParser(FhirPathParser nextParser) =>
      MinParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => [
        results
            .map((e) => e is num
                ? e
                : throw FhirPathEvaluationException(
                    'min() can only operate on numbers.',
                    operation: 'min',
                    arguments: e,
                    collection: results))
            .min
      ];

  @override
  String prettyPrint([int indent = 2]) => '.min()';
}

class MaxParser extends FhirPathParser {
  MaxParser([FhirPathParser? super.nextParser]);

  MaxParser copyWithNextParser(FhirPathParser nextParser) =>
      MaxParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => [
        results
            .map((e) => e is num
                ? e
                : throw FhirPathEvaluationException(
                    'max() can only operate on numbers.',
                    operation: 'max',
                    arguments: e,
                    collection: results))
            .max
      ];

  @override
  String prettyPrint([int indent = 2]) => '.max()';
}

class AvgParser extends FhirPathParser {
  AvgParser([FhirPathParser? super.nextParser]);

  AvgParser copyWithNextParser(FhirPathParser nextParser) =>
      AvgParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => [
        results
            .map((e) => e is num
                ? e
                : throw FhirPathEvaluationException(
                    'avg() can only operate on numbers.',
                    operation: 'avg',
                    arguments: e,
                    collection: results))
            .average
      ];

  @override
  String prettyPrint([int indent = 2]) => '.avg()';
}

class AnswersParser extends FhirPathParser {
  AnswersParser([FhirPathParser? super.nextParser]);

  AnswersParser copyWithNextParser(FhirPathParser nextParser) =>
      AnswersParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final descendants = DescendantsParser().execute(results, passed);
    final answerMaps = descendants.where((element) =>
        (element is Map<String, dynamic>) && element.containsKey('answer'));
    final answers = <dynamic>[];
    answerMaps.forEach((element) {
      answers.addAll((element as Map<String, dynamic>)['answer'] as Iterable);
    });
    return answers;
  }

  @override
  String prettyPrint([int indent = 2]) => '.answers()';
}

class OrdinalParser extends FhirPathParser {
  OrdinalParser([FhirPathParser? super.nextParser]);

  OrdinalParser copyWithNextParser(FhirPathParser nextParser) =>
      OrdinalParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final newResults = [];

    List checkForOrdinalValues(List list) {
      final tempResults = [];

      /// check each result
      for (final val in list) {
        /// if it's a Map (if it's not, then we can't use it with Ordinal)
        if (val is Map) {
          /// First we check the element for extensions
          if (val.keys.contains('extension')) {
            /// get those extensions
            final extension = val['extension'];

            /// generally we expect the extension to be a list
            if (extension is List) {
              /// for each extension in the list
              for (final ext in extension) {
                /// if it is defined as an ordinalValue
                if (ext['url'] ==
                    'http://hl7.org/fhir/StructureDefinition/ordinalValue') {
                  /// Safety check just to ensure there is a value
                  if (ext['valueDecimal'] != null) {
                    /// add that value to the results to return
                    tempResults.add(ext['valueDecimal']);
                  }
                }
              }
            } else

            /// just in case it's a Map and not a list
            if (extension is Map) {
              /// if it is defined as an ordinalValue
              if (extension['url'] ==
                  'http://hl7.org/fhir/StructureDefinition/ordinalValue') {
                /// Safety check just to ensure there is a value
                if (extension['valueDecimal'] != null) {
                  /// add that value to the results to return
                  tempResults.add(extension['valueDecimal']);
                }
              }
            }
          }
        }
      }
      return tempResults;
    }

    newResults.addAll(checkForOrdinalValues(results));

    for (final result in results) {
      if (result is! Map) {
        break;
      }

      polymorphicPrefixes.forEach((element) {
        if (result['${element}Coding'] != null) {
          newResults
              .addAll(checkForOrdinalValues([result['${element}Coding']]));
        }
        if (result['${element}Code'] != null) {
          newResults.addAll(checkForOrdinalValues([result['${element}Code']]));
        }
      });
    }

    return newResults;
  }

  @override
  String prettyPrint([int indent = 2]) => '.ordinal()';
}

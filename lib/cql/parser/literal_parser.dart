import 'package:collection/collection.dart';
import 'package:fhir/dstu2.dart' as dstu2;
import 'package:fhir/primitive_types/primitive_types.dart';
import 'package:fhir/r4.dart' as r4;
import 'package:fhir/r5.dart' as r5;
import 'package:fhir/stu3.dart' as stu3;

import '../../fhir_path.dart';

class IncludeDefinitionParser extends ValueParser<String> {
  IncludeDefinitionParser(this.include, [this.version, this.called]);
  String include;
  String? version;
  String? called;

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    return results;
  }

  /// To print the entire parsed FHIRPath expression, this includes ALL
  /// of the Parsers that are used in this package by the names used in
  /// this package. These are not always synonymous with the FHIRPath
  /// specification (although they usually are), and include some parser
  /// classes that were created for ease of evaluation but are not included
  /// at all as objects in the official spec. I'm generally going to recommend
  /// that you use [prettyPrint] instead
  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}UsingDefinitionParser: "$value"';

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) => '`$value`';
}

class UsingDefinitionParser extends ValueParser<String> {
  UsingDefinitionParser(this.using, [this.version]);
  String using;
  String? version;

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    return results;
  }

  /// To print the entire parsed FHIRPath expression, this includes ALL
  /// of the Parsers that are used in this package by the names used in
  /// this package. These are not always synonymous with the FHIRPath
  /// specification (although they usually are), and include some parser
  /// classes that were created for ease of evaluation but are not included
  /// at all as objects in the official spec. I'm generally going to recommend
  /// that you use [prettyPrint] instead
  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}UsingDefinitionParser: "$value"';

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) => '`$value`';
}

class LibraryDefinitionParser extends ValueParser<String> {
  LibraryDefinitionParser(this.library, [this.version]);
  String library;
  String? version;

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    return results;
  }

  /// To print the entire parsed FHIRPath expression, this includes ALL
  /// of the Parsers that are used in this package by the names used in
  /// this package. These are not always synonymous with the FHIRPath
  /// specification (although they usually are), and include some parser
  /// classes that were created for ease of evaluation but are not included
  /// at all as objects in the official spec. I'm generally going to recommend
  /// that you use [prettyPrint] instead
  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}LibraryDefinitionParser: "$value"';

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) => '`$value`';
}

class QualifiedIdentifierParser extends ValueParser<String> {
  QualifiedIdentifierParser(String? newQualifier, String newIdentifier) {
    String? formatValue(String? value) {
      if (value == null) {
        return value;
      }
      if (value.startsWith('"') ||
          value.startsWith("'") ||
          value.startsWith('`')) {
        value = value.substring(1, value.length - 1);
      }
      if (value.endsWith('"') || value.endsWith("'") || value.endsWith('`')) {
        value = value.substring(0, value.length - 1);
      }
      return value;
    }

    qualifier = formatValue(newQualifier);
    identifier = formatValue(newIdentifier)!;
  }
  late String? qualifier;
  late String identifier;

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    return results;
  }

  /// To print the entire parsed FHIRPath expression, this includes ALL
  /// of the Parsers that are used in this package by the names used in
  /// this package. These are not always synonymous with the FHIRPath
  /// specification (although they usually are), and include some parser
  /// classes that were created for ease of evaluation but are not included
  /// at all as objects in the official spec. I'm generally going to recommend
  /// that you use [prettyPrint] instead
  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}QualifiedIdentifierParser: "$value"';

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) => '`$value`';
}

/// Identifiers are used as labels to allow expressions to reference elements
/// such as model types and properties. FHIRPath supports two types of
/// identifiers, simple and delimited.
/// A delimited identifier is any sequence of characters enclosed in
/// backticks ( ` ):
/// The use of backticks allows identifiers to contains spaces, commas, and
/// other characters that would not be allowed within simple identifiers. This
/// allows identifiers to be more descriptive, and also enables expressions to
/// reference models that have property or type names that are not valid
/// simple identifiers.
class QuotedIdentifierParser extends ValueParser<String> {
  QuotedIdentifierParser(this.value);
  String value;

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    final identifierName = value;

    final finalResults = [];
    final finalPrimitiveExtensions =
        List<dynamic>.filled(results.length, null, growable: false);

    final passedExtensions = passed[ExtensionParser.extensionKey];
    passed[ExtensionParser.extensionKey] = null;

    if (passed.isVersion(FhirVersion.r4)
        ? r4.resourceTypeFromStringMap.keys.contains(identifierName)
        : passed.isVersion(FhirVersion.r5)
            ? r5.resourceTypeFromStringMap.keys.contains(identifierName)
            : passed.isVersion(FhirVersion.dstu2)
                ? dstu2.resourceTypeFromStringMap.keys.contains(identifierName)
                : stu3.resourceTypeFromStringMap.keys
                        .contains(identifierName) &&
                    (passed.hasNoContext
                        ? false
                        : passed.context?['resourceType'] == identifierName)) {
      finalResults.add(passed.context);
    } else {
      results.forEachIndexed((i, r) {
        if (r is Map) {
          String jsonIdentifierName = identifierName;
          dynamic rValue = r[identifierName];
          if (rValue == null) {
            // Support for polymorphism:
            // If the key cannot be found in the r-map, then find
            // a key that starts with the same word, e.g. 'value' identifier will
            // match 'valueDateTime' key.
            r.forEach((k, v) {
              if (k.toString().startsWith(identifierName) &&
                  polymorphicPrefixes.contains(identifierName) &&
                  startsWithAPolymorphicPrefix(k.toString())) {
                rValue = v;
                jsonIdentifierName = k.toString();
              }
            });
          }

          final jsonPrimitiveExtension =
              r['_$jsonIdentifierName'] as Map<String, dynamic>?;
          if (jsonPrimitiveExtension != null) {
            finalPrimitiveExtensions[i] = jsonPrimitiveExtension['extension'];
          }

          if (rValue is List) {
            finalResults.addAll(rValue as Iterable);
          } else if (rValue != null) {
            finalResults.add(rValue);
          } else if (r['resourceType'] == identifierName) {
            finalResults.add(r);
          }
        } else {
          if (identifierName == 'extension') {
            // Special processing for extensions on primitives
            if (passedExtensions != null) {
              final extensionOnPrimitive = passedExtensions[i];
              if (extensionOnPrimitive != null) {
                finalResults.addAll(extensionOnPrimitive as Iterable);
              }
            } else {
              // This primitive does not have an extension
              // Do nothing.
            }
          }
        }
      });
    }

    passed[ExtensionParser.extensionKey] = finalPrimitiveExtensions;

    return finalResults;
  }

  /// To print the entire parsed FHIRPath expression, this includes ALL
  /// of the Parsers that are used in this package by the names used in
  /// this package. These are not always synonymous with the FHIRPath
  /// specification (although they usually are), and include some parser
  /// classes that were created for ease of evaluation but are not included
  /// at all as objects in the official spec. I'm generally going to recommend
  /// that you use [prettyPrint] instead
  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}QuotedIdentifierParser: "$value"';

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) => '`$value`';
}

class CqlDateTimeParser extends BaseDateTimeParser<List> {
  CqlDateTimeParser(String stringValue) {
    final removeAt = stringValue.replaceFirst('@', '');
    final split = removeAt.split('T');

    if (split.length == 2 && split.last != '') {
      final formattedDateTime = FhirDateTime(removeAt).value;
      if (formattedDateTime == null) {
        throw FormatException(
            'The DateTime provided was not properly formatted', stringValue);
      }
      String? timeString;
      final timeLength = removeAt.split('T').last.split(':').length;
      timeString = formattedDateTime
          .toIso8601String()
          .split('T')
          .last
          .replaceFirst('Z', '')
          .split(':')
          .sublist(0, timeLength <= 3 ? timeLength : 3)
          .join(':');

      value = [
        DateParser(formattedDateTime.toIso8601String().split('T').first),
        TimeParser(timeString),
      ];
    } else {
      final formattedDateTime = FhirDateTime(removeAt.split('T').first).value;
      if (formattedDateTime == null) {
        throw FormatException(
            'The DateTime provided was not properly formatted', stringValue);
      }
      value = [FhirDate(removeAt.split('T').first)];
    }
  }
  late List value;

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    if (value.isEmpty) {
      return [];
    } else if (value.length == 1) {
      return [FhirDateTime(value.first.toString())];
    } else {
      return [FhirDateTime('${value.first}T${value.last}')];
    }
  }

  @override
  String toString() {
    if (value.length == 1) {
      return value.first.toString();
    } else {
      return '${value.first}T${value.last}';
    }
  }

  /// To print the entire parsed FHIRPath expression, this includes ALL
  /// of the Parsers that are used in this package by the names used in
  /// this package. These are not always synonymous with the FHIRPath
  /// specification (although they usually are), and include some parser
  /// classes that were created for ease of evaluation but are not included
  /// at all as objects in the official spec. I'm generally going to recommend
  /// that you use [prettyPrint] instead
  @override
  String verbosePrint(int indent) => '${"  " * indent}DateTimeParser: "$value"';

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) => '@${toString()}';
}

/// The Integer type represents whole numbers in the range -2^31 to 2^31-1 in
/// the FHIRPath spec, although we follow Dart's [int] which is +/- 2^53
class LongNumberParser extends ValueParser<num> {
  LongNumberParser(String newValue)
      : value = num.parse(newValue.replaceAll('L', ''));
  num value;

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) => [value];

  @override
  String toString() {
    return 'LongNumberParser: $value';
  }

  /// To print the entire parsed FHIRPath expression, this includes ALL
  /// of the Parsers that are used in this package by the names used in
  /// this package. These are not always synonymous with the FHIRPath
  /// specification (although they usually are), and include some parser
  /// classes that were created for ease of evaluation but are not included
  /// at all as objects in the official spec. I'm generally going to recommend
  /// that you use [prettyPrint] instead
  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}LongNumberParser: "$value"';

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) => '$value';
}

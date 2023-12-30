// ignore_for_file: annotate_overrides, overridden_fields, avoid_dynamic_calls, avoid_bool_literals_in_conditional_expressions

// Package imports:
import 'package:collection/collection.dart';
import 'package:fhir/dstu2.dart' as dstu2;
import 'package:fhir/primitive_types/primitive_types.dart';
import 'package:fhir/r4.dart' as r4;
import 'package:fhir/r5.dart' as r5;
import 'package:fhir/stu3.dart' as stu3;

// Project imports:
import '../../antlrish/quantity/generic_quantity.dart';
import '../petit_fhir_path.dart';

/// This includes all input that should be ignored, this includes pure white
/// space, along with comments, it simply returns whatever has been passed to it
class WhiteSpaceParser extends ValueParser<String> {
  const WhiteSpaceParser(super.value, [super.nextParser]);

  WhiteSpaceParser copyWithNextParser(FhirPathParser nextParser) =>
      WhiteSpaceParser(value, nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => results;

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}WhiteSpaceParser: "$value"';

  @override
  String prettyPrint([int indent = 2]) => value;
}

/// Boolean Parser, it returns a FHIR Boolean value
class BooleanParser extends ValueParser<bool> {
  const BooleanParser(super.value, [super.nextParser]);

  BooleanParser copyWithNextParser(FhirPathParser nextParser) =>
      BooleanParser(value, nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => [value];

  @override
  String verbosePrint(int indent) => '${"  " * indent}BooleanParser: "$value"';

  @override
  String prettyPrint([int indent = 2]) => '$value';

  @override
  operator ==(Object o) => o is BooleanParser
      ? o.value == value
      : o is bool
          ? o == value
          : o is String
              ? o == 'true'
                  ? value
                  : o == 'false'
                      ? !value
                      : false
              : false;
}

/// This allows the passing of a variable from the environment into the
/// evaluation.
class EnvVariableParser extends ValueParser<String> {
  const EnvVariableParser(super.value, [super.nextParser]);

  EnvVariableParser copyWithNextParser(FhirPathParser nextParser) =>
      EnvVariableParser(value, nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final variableName = value.replaceAll('`', '');

    if (variableName == '%sct') {
      return ['http://snomed.info/sct'];
    }

    if (variableName == '%loinc') {
      return ['http://loinc.org'];
    }

    if (variableName == '%ucum') {
      return ['http://unitsofmeasure.org'];
    }

    if (variableName.startsWith('%vs-')) {
      final valueSet = variableName.substring(4);
      return ['http://hl7.org/fhir/ValueSet/$valueSet'];
    }

    if (variableName.startsWith('%ext-')) {
      final extension = variableName.substring(5);
      return ['http://hl7.org/fhir/StructureDefinition/$extension'];
    }

    final passedValue = passed[variableName];
    if (passedValue == null) {
      throw FhirPathEvaluationException(
          'Variable $variableName does not exist.',
          variables: passed);
    }

    if (passedValue is! Function()) {
      return passedValue is List ? passedValue : [passedValue];
    } else {
      try {
        final result = passedValue();

        return result is List ? result : [result];
      } catch (ex) {
        throw FhirPathEvaluationException(
            'Variable $value could not be lazily evaluated.',
            cause: ex);
      }
    }
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}EnvVariableParser: "$value"';

  @override
  String prettyPrint([int indent = 2]) => value;
}

/// The Quantity type represents quantities with a specified unit, where
/// the value component is defined as a Decimal, and the unit element is
/// represented as a String that is required to be either a valid Unified
/// Code for Units of Measure (UCUM) unit or one of the calendar duration
/// keywords, singular or plural.
class QuantityParser extends ValueParser<GenericQuantity> {
  QuantityParser(String stringValue, [FhirPathParser? nextParser])
      : super(GenericQuantity.fromString(stringValue), nextParser);

  QuantityParser.fromValues(num value, String? unit,
      [FhirPathParser? nextParser])
      : super(GenericQuantity(value: value, unit: unit), nextParser);

  QuantityParser copyWithNextParser(FhirPathParser nextParser) =>
      QuantityParser(value.toString());

  @override
  List execute(List results, Map<String, dynamic> passed) => [value];

  @override
  operator ==(Object o) => o is QuantityParser
      ? o.value == value
      : o is GenericQuantity
          ? o == value
          : o is String
              ? GenericQuantity.fromString(o) == value
              : false;
}

/// The Integer type represents whole numbers in the range -2^31 to 2^31-1 in
/// the FHIRPath spec, although we follow Dart's [int] which is +/- 2^53
class IntegerParser extends ValueParser<int> {
  const IntegerParser(super.value, [super.nextParser]);

  IntegerParser copyWithNextParser(FhirPathParser nextParser) =>
      IntegerParser(value, nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => [value];

  @override
  String toString() {
    return 'Integer: $value';
  }

  @override
  String verbosePrint(int indent) => '${"  " * indent}IntegerParser: "$value"';

  @override
  String prettyPrint([int indent = 2]) => '$value';

  @override
  operator ==(Object o) => o is IntegerParser
      ? o.value == value
      : o is String
          ? int.tryParse(o) == value
          : false;
}

/// The Decimal type represents real values in the range (-10^28+1)/10^8 to
/// (10^28-1)/10^8 with a step size of 10^-8. Again, this is FHIRPath's official
/// definition, we use Dart's [double], which I believe is the same range as
/// [int] but with 15 decimal points. FHIRPath's range is defined based on a
/// survey of decimal-value implementations and is based on the most useful
/// lowest common denominator. Implementations can provide support for larger
/// decimals and higher precision, but must provide at least the range and
/// precision defined here. In addition, implementations should use
/// fixed-precision decimal formats to ensure that decimal values are
/// accurately represented
class DecimalParser extends ValueParser<double> {
  const DecimalParser(super.value, [super.nextParser]);

  DecimalParser copyWithNextParser(FhirPathParser nextParser) =>
      DecimalParser(value, nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => [value];

  @override
  operator ==(Object o) => o is DecimalParser
      ? o.value == value
      : o is String
          ? double.tryParse(o) == value
          : false;
}

/// Identifiers are used as labels to allow expressions to reference elements
/// such as model types and properties. FHIRPath supports two types of
/// identifiers, simple and delimited.
/// A simple identifier is any alphabetical character or an underscore,
/// followed by any number of alpha-numeric characters or underscores
class IdentifierParser extends ValueParser<String> {
  const IdentifierParser(super.value, [super.nextParser]);

  IdentifierParser copyWithNextParser(FhirPathParser nextParser) =>
      IdentifierParser(value, nextParser);

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
                    .contains(identifierName)) {
      if (!passed.hasNoContext &&
          passed.context?['resourceType'] == identifierName) {
        finalResults.add(passed.context);
      }
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

    if (nextParser != null) {
      return nextParser!.execute(finalResults, passed);
    } else {
      return finalResults;
    }
  }

  @override
  operator ==(Object o) => o is IdentifierParser
      ? o.value == value
      : o is String
          ? o == value
          : o.toString() == value;
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
class DelimitedIdentifierParser extends IdentifierParser {
  const DelimitedIdentifierParser(super.value, [super.nextParser]);

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

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}DelimitedIdentifierParser: "$value"';

  @override
  String prettyPrint([int indent = 2]) => '`$value`';

  @override
  operator ==(Object o) => o is DelimitedIdentifierParser
      ? o.value == value
      : o is String
          ? o == value
          : o.toString() == value;
}

/// The String type represents string values up to 2^31-1 characters in length.
/// String literals are surrounded by single-quotes and may use \-escapes to
/// escape quotes and represent Unicode characters.
class StringParser extends ValueParser<String> {
  const StringParser(super.value, [super.nextParser]);

  StringParser copyWithNextParser(FhirPathParser nextParser) =>
      StringParser(value, nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => [value];

  @override
  String verbosePrint(int indent) => "${'  ' * indent}StringParser: '$value'";

  @override
  String prettyPrint([int indent = 2]) => "'$value'";

  @override
  operator ==(Object o) => o is StringParser
      ? o.value == value
      : o is String
          ? o == value
          : o.toString() == value;
}

/// The DateTime type represents date/time and partial date/time values in the
/// range @0001-01-01T00:00:00.000 to @9999-12-31T23:59:59.999 with a 1
/// millisecond step size. This range is defined based on a survey of datetime
/// implementations and is based on the most useful lowest common denominator.
/// Implementations can provide support for larger ranges and higher precision,
/// but must provide at least the range and precision defined here.
class DateTimeParser extends BaseDateTimeParser<FhirDateTime> {
  const DateTimeParser(super.value, [super.nextParser]);

  DateTimeParser copyWithNextParser(FhirPathParser nextParser) =>
      DateTimeParser(value, nextParser);
  //  {
  //   final removeAt = stringValue.replaceFirst('@', '');
  //   final split = removeAt.split('T');

  //   if (split.length == 2 && split.last != '') {
  //     final formattedDateTime = FhirDateTime(removeAt).value;
  //     if (formattedDateTime == null) {
  //       throw FormatException(
  //           'The DateTime provided was not properly formatted', stringValue);
  //     }
  //     String? timeString;
  //     final timeLength = removeAt.split('T').last.split(':').length;
  //     timeString = formattedDateTime
  //         .toIso8601String()
  //         .split('T')
  //         .last
  //         .replaceFirst('Z', '')
  //         .split(':')
  //         .sublist(0, timeLength <= 3 ? timeLength : 3)
  //         .join(':');

  //     value = [
  //       DateParser(formattedDateTime.toIso8601String().split('T').first),
  //       TimeParser(timeString),
  //     ];
  //   } else {
  //     final formattedDateTime = FhirDateTime(removeAt.split('T').first).value;
  //     if (formattedDateTime == null) {
  //       throw FormatException(
  //           'The DateTime provided was not properly formatted', stringValue);
  //     }
  //     value = [FhirDate(removeAt.split('T').first)];
  //   }
  // }

  @override
  operator ==(Object o) => o is DateTimeParser
      ? o.value == value
      : o is DateParser
          ? o.value == value
          : o is FhirDateTime || o is FhirDate
              ? o == value
              : o is String
                  ? FhirDateTime(o).isValid && FhirDateTime(o) == value
                  : false;
}

/// The Date type represents date and partial date values in the range
/// @0001-01-01 to @9999-12-31 with a 1 day step size.
class DateParser extends BaseDateTimeParser<FhirDate> {
  const DateParser(super.value, [super.nextParser]);

  DateParser copyWithNextParser(FhirPathParser nextParser) =>
      DateParser(value, nextParser);

  @override
  operator ==(Object o) => o is DateParser
      ? o.value == value
      : o is DateTimeParser
          ? o.value == value
          : o is FhirTime || o is FhirDateTime
              ? o == value
              : o is String
                  ? FhirDate(o).isValid && FhirDate(o) == value
                  : false;
}

/// The Time type represents time-of-day and partial time-of-day values in the
/// range @T00:00:00.000 to @T23:59:59.999 with a step size of 1 millisecond.
/// This range is defined based on a survey of time implementations and is
/// based on the most useful lowest common denominator. Implementations can
/// provide support for higher precision, but must provide at least the range
/// and precision defined here. Time values in FHIRPath do not have a timezone
/// or timezone offset.
class TimeParser extends BaseDateTimeParser<FhirTime> {
  const TimeParser(super.value, [super.nextParser]);

  TimeParser copyWithNextParser(FhirPathParser nextParser) =>
      TimeParser(value, nextParser);
//  {
//     final removeAt = stringValue.replaceFirst('@', '');
//     value = FhirTime(removeAt.replaceFirst('T', ''));
//   }

  @override
  String prettyPrint([int indent = 2]) => '@T$value';

  @override
  operator ==(Object o) => o is TimeParser
      ? o.value == value
      : o is FhirTime
          ? o == value
          : o is String
              ? FhirTime(o).isValid && FhirTime(o) == value
              : false;
}

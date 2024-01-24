// ignore_for_file: annotate_overrides, overridden_fields, avoid_dynamic_calls

// Package imports:
import 'package:fhir/dstu2.dart' as dstu2;
import 'package:fhir/primitive_types/primitive_types.dart';
import 'package:fhir/r4.dart' as r4;
import 'package:fhir/r5.dart' as r5;
import 'package:fhir/stu3.dart' as stu3;
import 'package:ucum/ucum.dart';

// Project imports:
import '../../fhir_path.dart';

class IsParser extends OperatorParser {
  IsParser([FhirPathParser? super.nextParser]);

  IsParser copyWithNextParser(FhirPathParser nextParser) =>
      IsParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    print(results);
    print(nextParser);
    final List<dynamic> lhs = results;
    final List<dynamic>? rhs = nextParser == null
        ? null
        : nextParser is IdentifierParser
            ? [(nextParser as IdentifierParser).value]
            : nextParser?.execute([], passed);

    return rhs == null ||
            lhs.isEmpty ||
            lhs.length != 1 ||
            rhs.isEmpty ||
            rhs.length != 1
        ? throw FhirPathEvaluationException(
            'the "is" operation requires two operands, this was '
            'passed the following\n'
            'Operand1: $lhs\n'
            'Operand2: $rhs',
            collection: results)
        : (passed.isVersion(FhirVersion.r4)
                    ? r4.resourceTypeFromStringMap.keys.contains(rhs.first)
                    : passed.isVersion(FhirVersion.r5)
                        ? r5.resourceTypeFromStringMap.keys.contains(rhs.first)
                        : passed.isVersion(FhirVersion.dstu2)
                            ? dstu2.resourceTypeFromStringMap.keys
                                .contains(rhs.first)
                            : stu3.resourceTypeFromStringMap.keys
                                .contains(rhs.first)) &&
                lhs.first is Map &&
                lhs.first['resourceType'] == rhs.first
            ? [true]
            : rhs.first == 'String'
                ? [lhs.first is String]
                : rhs.first == 'Boolean'
                    ? [lhs.first is bool || lhs.first is FhirBoolean]
                    : rhs.first == 'Integer'
                        ? [
                            (lhs.first is int || lhs.first is FhirInteger) &&

                                /// This is because of transpilation to javascript
                                !lhs.first.toString().contains('.')
                          ]
                        : rhs.first == 'Decimal'
                            ? [
                                (lhs.first is double ||
                                        lhs.first is FhirDecimal) &&

                                    /// This is because of transpilation to javascript
                                    lhs.first.toString().contains('.')
                              ]
                            : rhs.first == 'Date'
                                ? [lhs.first is FhirDate]
                                : rhs.first == 'DateTime'
                                    ? [
                                        lhs.first is DateTime ||
                                            lhs.first is FhirDateTime
                                      ]
                                    : rhs.first == 'Time'
                                        ? [lhs.first is FhirTime]
                                        : rhs.first == 'Quantity'
                                            ? [isValidatedQuantity(lhs.first)]
                                            : [false];
  }
}

class AsParser extends OperatorParser {
  AsParser([FhirPathParser? super.nextParser]);

  AsParser copyWithNextParser(FhirPathParser nextParser) =>
      AsParser(nextParser);
  ParserList before = ParserList([]);
  ParserList after = ParserList([]);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final lhs = before.execute(results.toList(), passed);
    if (lhs.length != 1) {
      throw FhirPathEvaluationException(
          'The "as" operation requires a left operand with 1 item, '
          'but was passed the following\n'
          'Operand 1: $before',
          operation: 'as',
          arguments: before,
          collection: results);
    } else if (after.length != 1 || after.first is! IdentifierParser) {
      throw FhirPathEvaluationException(
          'The "as" operation requires a right operand that '
          'has a single item that resolves to an identifier, but was passed:\n'
          'Operand 2: $after',
          operation: 'as',
          arguments: after,
          collection: results);
    }
    final identifierValue = (after.first as IdentifierParser).value;
    if (((passed.isVersion(FhirVersion.r4)
                ? r4.resourceTypeFromStringMap.keys.contains(identifierValue)
                : passed.isVersion(FhirVersion.r5)
                    ? r5.resourceTypeFromStringMap.keys
                        .contains(identifierValue)
                    : passed.isVersion(FhirVersion.dstu2)
                        ? dstu2.resourceTypeFromStringMap.keys
                            .contains(identifierValue)
                        : stu3.resourceTypeFromStringMap.keys
                            .contains(identifierValue)) &&
            lhs.first is Map &&
            lhs.first['resourceType'] == identifierValue) ||
        (identifierValue.toLowerCase() == 'string' && (lhs.first is String)) ||
        (identifierValue.toLowerCase() == 'boolean' &&
            (lhs.first is bool || lhs.first is FhirBoolean)) ||
        (identifierValue.toLowerCase() == 'integer' &&
            (lhs.first is int || lhs.first is FhirInteger)) ||
        (identifierValue.toLowerCase() == 'decimal' &&
            (lhs.first is double || lhs.first is FhirDecimal)) ||
        (identifierValue.toLowerCase() == 'date' && lhs.first is FhirDate) ||
        (identifierValue.toLowerCase() == 'datetime' &&
            (lhs.first is DateTime || lhs.first is FhirDateTime)) ||
        (identifierValue.toLowerCase() == 'time' && lhs.first is FhirTime) ||
        (identifierValue == 'quantity' && lhs.first is ValidatedQuantity)) {
      return lhs;
    }

    if (FhirDatatypes.contains(identifierValue)) {
      final polymorphicString = 'value$identifierValue';
      final polymorphicIdentifier = IdentifierParser('', polymorphicString);
      final polymorphicParserList = ParserList([polymorphicIdentifier]);
      return polymorphicParserList.execute(results.toList(), passed);
    }
    return [];
  }

  @override
  String verbosePrint(int indent) => '${"  " * indent}AsParser'
      '\n${before.verbosePrint(indent + 1)}'
      '\n${after.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) => 'as'
      '\n${"  " * indent}${before.prettyPrint(indent + 1)}'
      '\n${"  " * indent}${after.prettyPrint(indent + 1)}';
}

const FhirDatatypes = {
  'Base64Binary',
  'Boolean',
  'Code',
  'Date',
  'DateTime',
  'Decimal',
  'Id',
  'Instant',
  'Integer',
  'Markdown',
  'PositiveInt',
  'String',
  'Time',
  'UnsignedInt',
  'Uri',
  'Url',
  'Address',
  'Annotation',
  'Age',
  'Attachment',
  'CodeableConcept',
  'Coding',
  'ContactPoint',
  'Count',
  'Distance',
  'Duration',
  'HumanName',
  'Identifier',
  'Money',
  'Period',
  'Quantity',
  'Range',
  'Ratio',
  'Reference',
  'SampledData',
  'Signature',
  'Timing',
  'ContactDetail',
  'Contributor',
  'DataRequirement',
  'Expression',
  'ParameterDefinition',
  'RelatedArtifact',
  'TriggerDefinition',
  'UsageContext',
  'Dosage',
  'Meta',
};

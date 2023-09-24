import '../../fhir_path.dart';

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

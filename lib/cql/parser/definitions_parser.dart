import '../../fhir_path.dart';

class LibraryDefinitionParser extends FhirPathParser {
  LibraryDefinitionParser(this.library, [this.version]);
  String library;
  String? version;

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    return results;
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}$runtimeType: "$library.$version"';

  @override
  String prettyPrint([int indent = 2]) => '`$library.$version`';
}

class UsingDefinitionParser extends FhirPathParser {
  UsingDefinitionParser(this.using, [this.version]);
  String using;
  String? version;

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    return results;
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}$runtimeType: "$using.$version"';

  @override
  String prettyPrint([int indent = 2]) => '`$using.$version`';
}

class IncludeDefinitionParser extends FhirPathParser {
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

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}$runtimeType: "$include.$version.$called"';

  @override
  String prettyPrint([int indent = 2]) => '`$include.$version.$called`';
}

class AccessModifierParser extends ValueParser<String> {
  AccessModifierParser(this.value);
  String value;

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    return results;
  }
}

class ParameterDefinitionParser extends ValueParser<String> {
  ParameterDefinitionParser(
    this.accessModifier,
    this.identifier,
    this.typeSpecifier,
    this.expression,
  );
  String accessModifier;
  String identifier;
  String typeSpecifier;
  String expression;

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    return results;
  }
}

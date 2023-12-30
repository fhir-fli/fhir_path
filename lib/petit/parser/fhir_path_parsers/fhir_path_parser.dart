// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes, avoid_function_literals_in_foreach_calls

/// FhirPathParser: base parser
abstract class FhirPathParser {
  final FhirPathParser? nextParser;
  const FhirPathParser([this.nextParser]);

  FhirPathParser copyWithNextParser(FhirPathParser nextParser);

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  List execute(List results, Map<String, dynamic> passed) => [];

  /// To print the entire parsed FHIRPath expression, this includes ALL
  /// of the Parsers that are used in this package by the names used in
  /// this package. These are not always synonymous with the FHIRPath
  /// specification (although they usually are), and include some parser
  /// classes that were created for ease of evaluation but are not included
  /// at all as objects in the official spec. I'm generally going to recommend
  /// that you use [prettyPrint] instead
  String verbosePrint(int indent);

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  String prettyPrint([int indent = 2]);
}

/// ValueParser: basic parser that holds a value
abstract class ValueParser<T> extends FhirPathParser {
  const ValueParser(this.value, [FhirPathParser? super.nextParser]);
  final T value;

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed);

  @override
  String toString() => '$runtimeType: $value';

  /// To print the entire parsed FHIRPath expression, this includes ALL
  /// of the Parsers that are used in this package by the names used in
  /// this package. These are not always synonymous with the FHIRPath
  /// specification (although they usually are), and include some parser
  /// classes that were created for ease of evaluation but are not included
  /// at all as objects in the official spec. I'm generally going to recommend
  /// that you use [prettyPrint] instead
  @override
  String verbosePrint(int indent) => '${"  " * indent}$runtimeType'
      '${value is FhirPathParser ? (value as FhirPathParser).verbosePrint(indent + 1) : value}';

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) => '$value';
}

/// OperatorParser: operators
abstract class OperatorParser extends FhirPathParser {
  OperatorParser([FhirPathParser? super.nextParser]);
  ParserList before = ParserList([]);
  ParserList after = ParserList([]);

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed);

  @override
  String toString() => '$runtimeType: $before $after';

  /// To print the entire parsed FHIRPath expression, this includes ALL
  /// of the Parsers that are used in this package by the names used in
  /// this package. These are not always synonymous with the FHIRPath
  /// specification (although they usually are), and include some parser
  /// classes that were created for ease of evaluation but are not included
  /// at all as objects in the official spec. I'm generally going to recommend
  /// that you use [prettyPrint] instead
  @override
  String verbosePrint(int indent) => '${"  " * indent}$runtimeType'
      '${"  " * (indent + 1)}${before.verbosePrint(indent + 1)}'
      '${"  " * (indent + 1)}${after.verbosePrint(indent + 1)}';

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) => '${before.prettyPrint(indent + 1)}'
      '${after.prettyPrint(indent + 1)}';

  @override
  bool operator ==(Object other);

  @override
  int get hashCode => toString().hashCode;
}

/// ParserList: anything that is a List of FhirPathParsers
class ParserList extends ValueParser<List<FhirPathParser>> {
  const ParserList(super.value, [FhirPathParser? super.nextParser]);

  ParserList copyWithNextParser(FhirPathParser nextParser) =>
      ParserList(value, nextParser);

  /// The iterable, nested function that evaluates the entire FHIRPath
  /// expression one object at a time
  @override
  List execute(List results, Map<String, dynamic> passed) {
    void addToList(List toAdd) => results
      ..clear()
      ..addAll(toAdd);

    value.forEach((v) {
      addToList(v.execute(results, passed).toList());
    });
    return results;
  }

  bool get isEmpty => value.isEmpty;
  int get length => value.length;
  FhirPathParser get first => value.first;
  FhirPathParser get last => value.last;
  FhirPathParser removeAt(int i) => value.removeAt(i);

  @override
  String toString() => 'PL(${value.length}): ${value.map((e) => e.toString())}';

  /// To print the entire parsed FHIRPath expression, this includes ALL
  /// of the Parsers that are used in this package by the names used in
  /// this package. These are not always synonymous with the FHIRPath
  /// specification (although they usually are), and include some parser
  /// classes that were created for ease of evaluation but are not included
  /// at all as objects in the official spec. I'm generally going to recommend
  /// that you use [prettyPrint] instead
  @override
  String verbosePrint(int indent) {
    var returnString = '${"  " * indent}PL(${value.length})';
    for (final item in value) {
      returnString += '\n${item.verbosePrint(indent + 1)}';
    }
    return returnString;
  }

  /// Uses a rough approximation of reverse polish notation to render the
  /// parsed value of a FHIRPath in a more human readable way than
  /// [verbosePrint], while still demonstrating how the expression was parsed
  /// and nested according to this package
  @override
  String prettyPrint([int indent = 2]) {
    var returnString = '';
    for (final item in value) {
      returnString += item.prettyPrint(indent + 1);
    }
    return returnString;
  }
}

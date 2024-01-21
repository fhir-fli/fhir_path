// ignore_for_file: annotate_overrides, overridden_fields

// Package imports:
import 'package:collection/collection.dart';

// Project imports:
import '../../fhir_path.dart';

class BracketsIndexParser extends ValueParser<int> {
  const BracketsIndexParser(super.value, [super.nextParser]);

  BracketsIndexParser copyWithNextParser(FhirPathParser nextParser) =>
      BracketsIndexParser(value, nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) =>
      results.isEmpty || value > results.length - 1 ? [] : [results[value]];

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}BracketsIndexParser: "$value"';

  @override
  String prettyPrint([int indent = 2]) => '[$value]';
}

/// If the function takes an expression as a parameter, the function will
/// evaluate the expression passed for the parameter with respect to each of
/// the items in the input collection. These expressions may refer to the
/// special $this and $index elements, which represent the item from the input
/// collection currently under evaluation, and its index in the collection,
/// respectively. For example, in name.given.where($this > 'ba' and $this
/// < 'bc') the where() function will iterate over each item in the input
/// collection (elements named given) and $this will be set to each item when
/// the expression passed to where() is evaluated.
class IndexParser extends FhirPathParser {
  IndexParser([FhirPathParser? super.nextParser]);

  IndexParser copyWithNextParser(FhirPathParser nextParser) =>
      IndexParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) =>
      [IterationContext.current(passed).indexValue];

  @override
  String prettyPrint([int indent = 2]) => 'index';
}

class IterationContext {
  dynamic thisValue;
  List<dynamic> totalValue = [];

  int indexValue = -1;

  static const _iterationKey = r'$iteration';

  static List<dynamic> withIterationContext(
      List<dynamic> Function(IterationContext) iteratedFunction,
      Map<String, dynamic> passed) {
    final topIterationContext = passed[_iterationKey];
    final thisIterationContext = IterationContext();
    passed[_iterationKey] = thisIterationContext;

    final result = iteratedFunction(thisIterationContext);

    passed[_iterationKey] = topIterationContext;

    return result;
  }

  static IterationContext current(Map<String, dynamic> passed) {
    final topRepeatContext = passed[_iterationKey];
    if (topRepeatContext == null) {
      throw FhirPathEvaluationException(
          r'No context for $this, $total, or $index is available.');
    }

    return topRepeatContext as IterationContext;
  }
}

/// If the function takes an expression as a parameter, the function will
/// evaluate the expression passed for the parameter with respect to each of
/// the items in the input collection. These expressions may refer to the
/// special $this and $index elements, which represent the item from the input
/// collection currently under evaluation, and its index in the collection,
/// respectively. For example, in name.given.where($this > 'ba' and $this
/// < 'bc') the where() function will iterate over each item in the input
/// collection (elements named given) and $this will be set to each item when
/// the expression passed to where() is evaluated.
class ThisParser extends FhirPathParser {
  ThisParser([FhirPathParser? super.nextParser]);

  ThisParser copyWithNextParser(FhirPathParser nextParser) =>
      ThisParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) =>
      [IterationContext.current(passed).thisValue];

  @override
  String prettyPrint([int indent = 2]) => 'this';
}

class TotalParser extends ValueParser<int> {
  const TotalParser([FhirPathParser? nextParser]) : super(0, nextParser);

  TotalParser copyWithNextParser(FhirPathParser nextParser) =>
      TotalParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) =>
      IterationContext.current(passed).totalValue;

  @override
  String verbosePrint(int indent) => '${"  " * indent}TotalParser';

  @override
  String prettyPrint([int indent = 2]) => 'total';
}

/// Performs general-purpose aggregation by evaluating the aggregator
/// expression for each element of the input collection. Within this
/// expression, the standard iteration variables of $this and $index can be
/// accessed, but also a $total aggregation variable.
/// The value of the $total variable is set to init, or empty ({ }) if no init
/// value is supplied, and is set to the result of the aggregator expression
/// after every iteration.
/// Using this function, sum can be expressed as:
///   value.aggregate($this + $total, 0)
/// Min can be expressed as:
///   value.aggregate(iif($total.empty(), $this, iif($this < $total, $this, $total)))
/// and average would be expressed as:
///   value.aggregate($total + $this, 0) / value.count()
class AggregateParser extends ValueParser<ParserList> {
  const AggregateParser([FhirPathParser? nextParser])
      : super(const ParserList([]), nextParser);

  AggregateParser copyWithNextParser(FhirPathParser nextParser) =>
      AggregateParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final finalTotal =
        IterationContext.withIterationContext((iterationContext) {
      List<dynamic> currentTotal = [];

      late FhirPathParser expression;
      late dynamic initialValue;
      if (value.value.first is CommaParser) {
        initialValue = (value.value.first as CommaParser)
            .after
            .execute(results.toList(), passed);
        expression = (value.value.first as CommaParser).before;
      } else {
        initialValue = [];
        expression = value;
      }

      iterationContext.totalValue = initialValue as List;
      results.forEachIndexed((i, r) {
        iterationContext.indexValue = i;
        iterationContext.thisValue = r;
        iterationContext.totalValue = expression.execute([r], passed);
        currentTotal = iterationContext.totalValue;
      });

      return currentTotal;
    }, passed);

    return finalTotal;
  }

  @override
  String verbosePrint(int indent) =>
      '${"  " * indent}AggregateParser\n${value.verbosePrint(indent + 1)}';

  @override
  String prettyPrint([int indent = 2]) =>
      'aggregate(\n${value.prettyPrint(indent + 1)}\n)';
}

/// There is no literal representation for null in FHIRPath. This means that
/// when, in an underlying data object (i.e. they physical data on which the
/// implementation is operating) a member is null or missing, there will
/// simply be no corresponding node for that member in the tree, e.g.
/// Patient.name will return an empty collection (not null) if there are no
/// name elements in the instance.
/// In expressions, the empty collection is represented as { }.
class EmptySetParser extends FhirPathParser {
  const EmptySetParser([FhirPathParser? super.nextParser]);

  EmptySetParser copyWithNextParser(FhirPathParser nextParser) =>
      EmptySetParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) =>
      nextParser == null ? [] : nextParser!.execute([], passed);

  @override
  String prettyPrint([int indent = 2]) => '{ }';
}

class DotParser extends FhirPathParser {
  DotParser([FhirPathParser? super.nextParser]);

  DotParser copyWithNextParser(FhirPathParser nextParser) =>
      DotParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) => results;

  @override
  String prettyPrint([int indent = 2]) => '.';
}

// Project imports:
import '../../petit_fhir_path.dart';

class ChildrenParser extends FhirPathParser {
  ChildrenParser([FhirPathParser? super.nextParser]);

  ChildrenParser copyWithNextParser(FhirPathParser nextParser) =>
      ChildrenParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final finalResults = [];
    for (final r in results) {
      if (r is Map) {
        r.forEach((key, value) {
          if (value is List) {
            finalResults.addAll(value);
          } else {
            finalResults.add(value);
          }
        });
      }
    }
    return finalResults;
  }

  @override
  String prettyPrint([int indent = 2]) => '.children()';
}

class DescendantsParser extends FhirPathParser {
  DescendantsParser([FhirPathParser? super.nextParser]);

  DescendantsParser copyWithNextParser(FhirPathParser nextParser) =>
      DescendantsParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    // According to spec, `descendants()` is shorthand for `repeat(children())`
    final repeatParser = RepeatParser(ParserList([ChildrenParser()]));
    return repeatParser.execute(results, passed);
  }

  @override
  String prettyPrint([int indent = 2]) => '.descendants()';
}

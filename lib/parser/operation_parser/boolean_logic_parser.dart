// ignore_for_file: overridden_fields, annotate_overrides

// Project imports:
import '../../fhir_path.dart';

class AndStringParser extends OperatorParser {
  AndStringParser([FhirPathParser? nextParser]) : super(nextParser);

  AndStringParser copyWithNextParser(FhirPathParser nextParser) =>
      AndStringParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final beforeBool = ToBooleanParser().execute(results, passed);
    final afterBool = nextParser == null ? [] : nextParser!.execute([], passed);

    if (beforeBool == true && afterBool == true) {
      return [true];
    }

    if (beforeBool == false || afterBool == false) {
      return [false];
    }

    return [];
  }
}

class XorParser extends OperatorParser {
  XorParser([FhirPathParser? super.nextParser]);

  XorParser copyWithNextParser(FhirPathParser nextParser) =>
      XorParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final beforeBool = ToBooleanParser().execute(results, passed);
    final afterBool =
        ToBooleanParser().execute(nextParser!.execute([], passed), passed);

    if (beforeBool.isEmpty || afterBool.isEmpty) {
      return [];
    }

    if (beforeBool == false && afterBool == false) {
      return [false];
    }

    if (beforeBool == true && afterBool == true) {
      return [false];
    }

    return [true];
  }
}

class OrStringParser extends OperatorParser {
  OrStringParser([FhirPathParser? super.nextParser]);

  OrStringParser copyWithNextParser(FhirPathParser nextParser) =>
      OrStringParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final beforeBool = ToBooleanParser().execute(results, passed);
    final afterBool =
        ToBooleanParser().execute(nextParser!.execute([], passed), passed);

    if (beforeBool == true || afterBool == true) {
      return [true];
    }

    if (beforeBool.isEmpty || afterBool.isEmpty) {
      return [];
    }

    return [false];
  }
}

class ImpliesParser extends OperatorParser {
  ImpliesParser([FhirPathParser? super.nextParser]);

  ImpliesParser copyWithNextParser(FhirPathParser nextParser) =>
      ImpliesParser(nextParser);

  @override
  List execute(List results, Map<String, dynamic> passed) {
    final beforeBool = ToBooleanParser().execute(results, passed);
    final afterBool =
        ToBooleanParser().execute(nextParser!.execute([], passed), passed);

    if (beforeBool == true) {
      return afterBool.isNotEmpty ? [afterBool] : [];
    }

    if (beforeBool == false) {
      return [true];
    }

    if (afterBool == true) {
      return [true];
    }

    return [];
  }
}

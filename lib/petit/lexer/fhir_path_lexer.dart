// ignore_for_file: avoid_dynamic_calls

// Package imports:
import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';

// Project imports:
import '../petit_fhir_path.dart';

/// Primary lexing function for this library
Parser<FhirPathParser> lexer() {
  final SettableParser<dynamic> lexerFunctions = undefined();
  final SettableParser<dynamic> lexerParentheses = undefined();

  /// The order of lexing is important, and if/when updated, needs
  /// to be taken into account in order for petiteparser to find
  /// patterns in the correct order
  final ChoiceParser<dynamic> tokenizer = simpleLexer |
      lexerFunctions |
      lexerParentheses |
      wordOperationLexer |
      wsLexer |
      symbolOperationLexer |
      specialLexer |
      literalLexer;

  /// Calls the operatorValues function to check if any arguments need
  /// to be passed to the current Parser
  lexerFunctions.set((functionLexer & tokenizer.star() & char(')')).map(
      (List<dynamic> val) =>
          val[0]..value = operatorValues(val[1] as List<dynamic>)));

  /// Calls the operatorValues function to check if any arguments need
  /// to be passed to the current ParenthesesParser
  lexerParentheses.set((char('(') & tokenizer.star() & char(')')).map(
      (List<dynamic> value) =>
          ParenthesesParser(operatorValues(value[1] as List<dynamic>))));

  /// Complete the lexing and again, passes to operatorValues
  return tokenizer
      .plus()
      .end()
      .map((List<dynamic> value) => operatorValues(value));
}

/// This ensures that any response is a ParserList (this allows easy recursion when
/// evaluating the expression)
ParserList operatorValues(List<dynamic> fullList) {
  /// if not arguments passed, then it is an empty ParserList
  if (fullList.isEmpty) {
    return ParserList(<FhirPathParser>[]);
  }

  /// We remove the whiteSpace because for evaluation purposes it's unimportant
  fullList.removeWhere((dynamic element) => element is WhiteSpaceParser);

  if (fullList.indexWhere((dynamic element) => element is OperatorParser) ==
      -1) {
    /// If there are no Operators, we just return the current elements
    return ParserList(
        fullList.map((dynamic e) => e as FhirPathParser).toList());
  } else {
    // Replace +/- with unary representation based on simple rules
    fullList.forEachIndexed(
      (int i, dynamic entry) => {
        if (entry is MinusParser || entry is PlusParser)
          {
            if (i == 0 || fullList[i - 1] is OperatorParser)
              {
                fullList[i] = entry is MinusParser
                    ? UnaryNegateParser()
                    : UnaryPlusParser()
              }
          }
      },
    );

    int highest = -1;
    for (final dynamic entry in fullList) {
      if ((operatorOrderMap[entry.runtimeType] ?? -1) > highest &&
          entry is OperatorParser) {
        highest = operatorOrderMap[entry.runtimeType] ?? -1;
      }
    }

    final int splitIndex = fullList.lastIndexWhere(
        (dynamic e) => operatorOrderMap[e.runtimeType] == highest);

    fullList[splitIndex].before =
        operatorValues(fullList.sublist(0, splitIndex));
    fullList[splitIndex].after =
        operatorValues(fullList.sublist(splitIndex + 1, fullList.length));
    return ParserList(<FhirPathParser>[fullList[splitIndex] as FhirPathParser]);
  }
}

part of '../fhir_path_dart_visitor.dart';

List<dynamic>? _$visitParenthesizedTerm(
  ParenthesizedTermContext ctx,
  FhirPathDartVisitor visitor,
) {
  if (ctx.childCount != 3) {
    throw FhirPathEvaluationException(
        'There should be a single context between '
        'parentheses (as far as the parser is concerned, but this was called with '
        'a ${ctx.childCount} contexts/children');
  }
  visitor.context = visitor.visit(ctx.getChild(1)!) ?? <dynamic>[];
  return visitor.context;
}

List<dynamic>? _$visitThisInvocation(
  ThisInvocationContext ctx,
  FhirPathDartVisitor visitor,
) {
  return visitor.context;
}

List<dynamic>? _$visitTotalInvocation(
  TotalInvocationContext ctx,
  FhirPathDartVisitor visitor,
) {
  visitor.context = visitor.environment[r'%$total'] as List<dynamic>;
  return visitor.environment[r'%$total'] as List<dynamic>;
}

List<dynamic>? _$visitParamList(
  ParamListContext ctx,
  FhirPathDartVisitor visitor,
) {
  final int? commaIndex = ctx.children?.indexWhere((ParseTree element) =>
      element is TerminalNodeImpl && element.text == ',');
  if (commaIndex != null && commaIndex != -1) {
    final List<dynamic> tempContext = <dynamic>[];
    ctx.children?.forEach((ParseTree element) {
      if (element is! TerminalNodeImpl && element.text != ',') {
        tempContext.addAll(visitor.copyWith().visit(element) ?? <dynamic>[]);
      }
    });
    visitor.context = tempContext;
    return visitor.context;
  } else {
    return visitor.visitChildren(ctx);
  }
}

List<dynamic>? _$visitIndexerExpression(
  IndexerExpressionContext ctx,
  FhirPathDartVisitor visitor,
) {
  if (ctx.expressions().length != 2 && ctx.children?.length != 4) {
    throw FhirPathException('IndexerExpression passed incorrect context');
  }
  final List<dynamic>? results = visitor.copyWith().visit(ctx.getChild(0)!);
  final List<dynamic>? value = visitor.copyWith().visit(ctx.getChild(2)!);

  visitor.context = results == null ||
          results.isEmpty ||
          value == null ||
          value.isEmpty ||
          value.length != 1 ||
          (value.first is int &&
              ((value.first as int < 0) ||
                  (value.first as int > results.length - 1)))
      ? <dynamic>[]
      : <dynamic>[results[value.first as int]];
  return visitor.context;
}

List<dynamic>? _$visitAndExpression(
  AndExpressionContext ctx,
  FhirPathDartVisitor visitor,
) {
  if (ctx.childCount != 3) {
    throw _wrongArgLength('and', ctx.children ?? <dynamic>[]);
  }
  final lhs = visitor.copyWith().visit(ctx.getChild(0)!);
  final rhs = visitor.copyWith().visit(ctx.getChild(2)!);

  bool? convertValue(dynamic value) => value is bool
      ? value
      : value is FhirBoolean
          ? value.isValid
              ? value.value
              : null
          : value == 1
              ? true
              : value == 0
                  ? false
                  : <String>[
                      'true',
                      't',
                      'yes',
                      'y',
                      '1',
                      '1.0',
                    ].contains(lhs.toString().toLowerCase())
                      ? true
                      : <String>['false', 'f', 'no', 'n', '0', '0.0']
                              .contains(lhs.toString().toLowerCase())
                          ? false
                          : null;

  final bool? lhsValue =
      lhs == null || lhs.isEmpty ? null : convertValue(lhs.first);
  final bool? rhsValue =
      rhs == null || rhs.isEmpty ? null : convertValue(rhs.first);
  if (lhsValue == null) {
    if (rhsValue == null || rhsValue) {
      visitor.context = <dynamic>[];
    } else {
      visitor.context = <dynamic>[false];
    }
  } else if (lhsValue) {
    if (rhsValue == null) {
      visitor.context = <dynamic>[];
    } else {
      visitor.context = <dynamic>[rhsValue];
    }
  } else {
    visitor.context = <dynamic>[false];
  }

  return visitor.context;
}

List<dynamic>? _$visitOrExpression(
  OrExpressionContext ctx,
  FhirPathDartVisitor visitor,
) {
  if (ctx.childCount != 3) {
    throw _wrongArgLength(ctx.text, ctx.children ?? <dynamic>[]);
  }
<<<<<<< HEAD
  final lhs = visitor.copyWith().visit(ctx.getChild(0)!);
  final rhs = visitor.copyWith().visit(ctx.getChild(2)!);
  final operator = ctx.getChild(1)!.text;
=======
  final List<dynamic>? lhs = visitor.copyWith().visit(ctx.getChild(0)!);
  final List<dynamic>? rhs = visitor.copyWith().visit(ctx.getChild(2)!);
  final String? operator = ctx.getChild(1)!.text;
>>>>>>> 2004e1db77094e271c85a3f347db9f8dbf2ffeb7

  bool? convertValue(dynamic value) => value is bool
      ? value
      : value is FhirBoolean
          ? value.isValid
              ? value.value
              : null
          : value == 1
              ? true
              : value == 0
                  ? false
                  : <String>[
                      'true',
                      't',
                      'yes',
                      'y',
                      '1',
                      '1.0',
                    ].contains(lhs.toString().toLowerCase())
                      ? true
                      : <String>['false', 'f', 'no', 'n', '0', '0.0']
                              .contains(lhs.toString().toLowerCase())
                          ? false
                          : null;

  final bool? lhsValue =
      lhs == null || lhs.isEmpty ? null : convertValue(lhs.first);
  final bool? rhsValue =
      rhs == null || rhs.isEmpty ? null : convertValue(rhs.first);
  if (operator == 'or') {
    if (lhsValue == null) {
      if (rhsValue == null || !rhsValue) {
        visitor.context = <dynamic>[];
      } else {
        visitor.context = <dynamic>[true];
      }
    } else if (lhsValue) {
      visitor.context = <dynamic>[true];
    } else {
      if (rhsValue == null) {
        visitor.context = <dynamic>[];
      } else {
        visitor.context = <dynamic>[rhsValue];
      }
    }
  } else if (operator == 'xor') {
    if (lhsValue == null || rhsValue == null) {
      visitor.context = <dynamic>[];
    } else if ((lhsValue && !rhsValue) || (!lhsValue && rhsValue)) {
      visitor.context = <dynamic>[true];
    } else {
      visitor.context = <dynamic>[false];
    }
  }

  return visitor.context;
}

List<dynamic>? _$visitImpliesExpression(
  ImpliesExpressionContext ctx,
  FhirPathDartVisitor visitor,
) {
  if (ctx.childCount != 3) {
    throw _wrongArgLength(ctx.text, ctx.children ?? <dynamic>[]);
  }
  final lhs = visitor.copyWith().visit(ctx.getChild(0)!);
  final rhs = visitor.copyWith().visit(ctx.getChild(2)!);

  bool? convertValue(dynamic value) => value is bool
      ? value
      : value is FhirBoolean
          ? value.isValid
              ? value.value
              : null
          : value == 1
              ? true
              : value == 0
                  ? false
                  : <String>[
                      'true',
                      't',
                      'yes',
                      'y',
                      '1',
                      '1.0',
                    ].contains(lhs.toString().toLowerCase())
                      ? true
                      : <String>['false', 'f', 'no', 'n', '0', '0.0']
                              .contains(lhs.toString().toLowerCase())
                          ? false
                          : null;

  final bool? lhsValue =
      lhs == null || lhs.isEmpty ? null : convertValue(lhs.first);
  final bool? rhsValue =
      rhs == null || rhs.isEmpty ? null : convertValue(rhs.first);

  if (lhsValue == null) {
    if (rhsValue == null || !rhsValue) {
      visitor.context = <dynamic>[];
    } else {
      visitor.context = <dynamic>[true];
    }
  } else if (lhsValue) {
    visitor.context = rhsValue == null ? <dynamic>[] : <dynamic>[rhsValue];
  } else {
    visitor.context = <dynamic>[true];
  }

  return visitor.context;
}

List<dynamic>? _$visitUnionExpression(
  UnionExpressionContext ctx,
  FhirPathDartVisitor visitor,
) {
  final List<dynamic> args = <dynamic>[
    ...visitor.copyWith().visit(ctx.getChild(0)!)?.toList() ?? <dynamic>[],
    ...visitor.copyWith().visit(ctx.getChild(2)!)?.toList() ?? <dynamic>[]
  ];
  visitor.context = <dynamic>[];
  for (final dynamic value in args) {
    if (notFoundInList(visitor.context, value)) {
      visitor.context.add(value);
    }
  }
  return visitor.context;
}

List<dynamic>? _$visitMembershipExpression(
  MembershipExpressionContext ctx,
  FhirPathDartVisitor visitor,
) {
  if (ctx.childCount != 3) {
    throw _wrongArgLength(ctx.text, ctx.children ?? <dynamic>[]);
  }
<<<<<<< HEAD
  final lhs = visitor.copyWith().visit(ctx.getChild(0)!);
  final rhs = visitor.copyWith().visit(ctx.getChild(2)!);
  final operator = ctx.getChild(1)!.text;
  final objectList = operator == 'in' ? lhs : rhs;
=======
  final List<dynamic>? lhs = visitor.copyWith().visit(ctx.getChild(0)!);
  final List<dynamic>? rhs = visitor.copyWith().visit(ctx.getChild(2)!);
  final String? operator = ctx.getChild(1)!.text;
  final List<dynamic>? objectList = operator == 'in' ? lhs : rhs;
>>>>>>> 2004e1db77094e271c85a3f347db9f8dbf2ffeb7
  if (objectList?.isEmpty ?? true) {
    visitor.context = <dynamic>[];
  } else {
    if (objectList!.length != 1) {
      throw FhirPathException(
          'IndexerExpression passed a list with more than one member');
    }
    final dynamic object = objectList.first;
    final List<dynamic>? collection = operator == 'in' ? rhs : lhs;
    if (collection?.isEmpty ?? true) {
      visitor.context = <dynamic>[false];
    } else {
      visitor.context = <dynamic>[
        collection!.indexWhere((dynamic element) {
              if (object is FhirDateTime ||
                  object is FhirDate ||
                  element is FhirDateTime ||
                  element is FhirDate) {
                /// As long as one is, we convert them both to strings then back
                /// to DateTimes
                final FhirDateTime lhsDateTime =
                    FhirDateTime(object.toString());
                final FhirDateTime rhsDateTime =
                    FhirDateTime(element.toString());

                /// As long as they are both valid we try and compare them
                if (lhsDateTime.isValid && rhsDateTime.isValid) {
                  return lhsDateTime == rhsDateTime;
                } else {
                  return false;
                }
              } else if (object is FhirPathQuantity ||
                  element is FhirPathQuantity) {
                if (object is FhirPathQuantity) {
                  return object == element;
                } else {
                  return element == object;
                }
              } else {
                return object == element || element == object;
              }
            }) !=
            -1
      ];
    }
  }

  return visitor.context;
}

// ignore_for_file: avoid_dynamic_calls

part of '../fhir_path_dart_visitor.dart';

List<dynamic>? _$visitTypeExpression(
  TypeExpressionContext ctx,
  FhirPathDartVisitor visitor,
) {
  if (ctx.childCount != 3) {
    throw _wrongArgLength(ctx.text, ctx.children ?? <dynamic>[]);
  }
  final List<dynamic>? lhs = visitor.copyWith().visit(ctx.getChild(0)!);
  final String? rhsText = ctx.getChild(2)!.text;

  List<dynamic>? rhs = (visitor.environment.isVersion(FhirVersion.r4)
              ? r4.resourceTypeFromStringMap.keys.contains(rhsText)
              : visitor.environment.isVersion(FhirVersion.r5)
                  ? r5.resourceTypeFromStringMap.keys.contains(rhsText)
                  : visitor.environment.isVersion(FhirVersion.dstu2)
                      ? dstu2.resourceTypeFromStringMap.keys.contains(rhsText)
                      : stu3.resourceTypeFromStringMap.keys
                          .contains(rhsText)) ||
          <dynamic>[
            'string',
            'boolean',
            'integer',
            'decimal',
            'date',
            'datetime',
            'time',
            'quantity',
          ].contains(rhsText?.toLowerCase())
      ? <dynamic>[ctx.getChild(2)!.text]
      : visitor.copyWith().visit(ctx.getChild(2)!);

  if (rhs?.isEmpty ?? true) {
    visitor.identifierOnly = true;
    rhs = visitor.copyWith().visit(ctx.getChild(2)!);
    visitor.identifierOnly = false;
  }

  final operator = ctx.getChild(1)?.text;

  if ((lhs?.isEmpty ?? true) ||
      lhs!.length != 1 ||
      (rhs?.isEmpty ?? true) ||
      rhs!.length != 1) {
    throw FhirPathEvaluationException(
        'the "$operator" operation requires two operands, this was '
        'passed the following\n'
        'Operand1: $lhs\n'
        'Operand2: $rhs',
        collection: visitor.context);
  } else if (operator == 'is') {
    visitor.context = (visitor.environment.isVersion(FhirVersion.r4)
                ? r4.resourceTypeFromStringMap.keys.contains(rhs.first)
                : visitor.environment.isVersion(FhirVersion.r5)
                    ? r5.resourceTypeFromStringMap.keys.contains(rhs.first)
                    : visitor.environment.isVersion(FhirVersion.dstu2)
                        ? dstu2.resourceTypeFromStringMap.keys
                            .contains(rhs.first)
                        : stu3.resourceTypeFromStringMap.keys
                            .contains(rhs.first)) &&
            lhs.first is Map &&
            (lhs.first as Map<String, dynamic>)['resourceType'] == rhs.first
        ? <dynamic>[true]
        : rhs.first == 'String'
            ? <dynamic>[lhs.first is String]
            : rhs.first == 'Boolean'
                ? <dynamic>[lhs.first is bool || lhs.first is FhirBoolean]
                : rhs.first == 'Integer'
                    ? <dynamic>[
                        (lhs.first is int || lhs.first is FhirInteger) &&

                            /// This is because of transpilation to javascript
                            !lhs.first.toString().contains('.')
                      ]
                    : rhs.first == 'Decimal'
                        ? <dynamic>[
                            (lhs.first is double || lhs.first is FhirDecimal) &&

                                /// This is because of transpilation to javascript
                                lhs.first.toString().contains('.')
                          ]
                        : rhs.first == 'Date'
                            ? <dynamic>[lhs.first is FhirDate]
                            : rhs.first == 'DateTime'
                                ? <dynamic>[
                                    lhs.first is DateTime ||
                                        lhs.first is FhirDateTime
                                  ]
                                : rhs.first == 'Time'
                                    ? <dynamic>[lhs.first is FhirTime]
                                    : rhs.first == 'Quantity'
                                        ? <dynamic>[isQuantity(lhs.first)]
                                        : <dynamic>[false];
  } else if (((visitor.environment.isVersion(FhirVersion.r4)
              ? r4.resourceTypeFromStringMap.keys.contains(rhs.first)
              : visitor.environment.isVersion(FhirVersion.r5)
                  ? r5.resourceTypeFromStringMap.keys.contains(rhs.first)
                  : visitor.environment.isVersion(FhirVersion.dstu2)
                      ? dstu2.resourceTypeFromStringMap.keys.contains(rhs.first)
                      : stu3.resourceTypeFromStringMap.keys
                          .contains(rhs.first)) &&
          lhs.first is Map &&
          (lhs.first as Map<String, dynamic>)['resourceType'] == rhs.first) ||
      (rhs.first.toLowerCase() == 'string' && (lhs.first is String)) ||
      (rhs.first.toLowerCase() == 'boolean' &&
          (lhs.first is bool || lhs.first is FhirBoolean)) ||
      (rhs.first.toLowerCase() == 'integer' &&
          (lhs.first is int || lhs.first is FhirInteger)) ||
      (rhs.first.toLowerCase() == 'decimal' &&
          (lhs.first is double || lhs.first is FhirDecimal)) ||
      (rhs.first.toLowerCase() == 'date' && lhs.first is FhirDate) ||
      (rhs.first.toLowerCase() == 'datetime' &&
          (lhs.first is DateTime || lhs.first is FhirDateTime)) ||
      (rhs.first.toLowerCase() == 'time' && lhs.first is FhirTime) ||
      (rhs.first == 'quantity' && lhs.first is FhirPathQuantity)) {
    visitor.context = lhs;
  } else if (FhirDatatypes.contains(rhs.first)) {
    // TODO(Dokotela): this seems cumbersome
    final String polymorphicString = 'value${rhs.first}';
    final ExpressionContext newContext = visitor.newContext(polymorphicString);
    visitor.context = visitor.copyWith().visit(newContext) ?? <dynamic>[];
  } else {
    visitor.context = <dynamic>[];
  }

  return visitor.context;
}

List<dynamic>? _$visitInvocationExpression(
  InvocationExpressionContext ctx,
  FhirPathDartVisitor visitor,
) {
  // TODO(Dokotela): this seems rough
  if (ctx.childCount == 3 &&
      ctx.getChild(2) is FunctionInvocationContext &&
      (ctx.getChild(2)!.text?.startsWith('extension') ?? false)) {
    visitor.identifierOnly = true;
    final List<dynamic>? identifier =
        visitor.copyWith().visit(ctx.getChild(0)!);
    visitor.identifierOnly = false;
    final String identifierExtension = '_${identifier?.first}';
    final String newString =
        '${ctx.getChild(0)!.text!.replaceAll('${identifier!.first}', identifierExtension)}'
        '${ctx.getChild(1)!.text}${ctx.getChild(2)!.text}';
    return visitor.visitChildren(visitor.newContext(newString));
  } else {
    return visitor.visitChildren(ctx);
  }
}

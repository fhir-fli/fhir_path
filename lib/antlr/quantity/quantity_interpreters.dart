// ignore_for_file: prefer_if_elements_to_conditional_expressions

part of '../fhir_path_dart_visitor.dart';

List<dynamic>? _$visitQuantityLiteral(
  QuantityLiteralContext ctx,
  FhirPathDartVisitor visitor,
) {
  return visitor.visitChildren(ctx);
}

List<dynamic>? _$visitUnit(
  UnitContext ctx,
  FhirPathDartVisitor visitor,
) {
  visitor.context = <dynamic>[ctx.text];
  return visitor.context;
}

List<dynamic>? _$visitQuantity(
  QuantityContext ctx,
  FhirPathDartVisitor visitor,
) {
  if (ctx.childCount == 2) {
    final List<Object?> amount = <Object?>[
      ctx.getChild(0).runtimeType == TerminalNodeImpl
          ? ctx.getChild(0)!.text
          : visitor.visit(ctx.getChild(0)!)
    ];
    final List<dynamic>? unit = visitor.visit(ctx.getChild(1)!);
    if (amount.length != 1 || unit?.length != 1) {
      throw FhirPathInvalidExpressionException(
          'A quantity requires both a unit '
          'as well as an amount, this is missing at least one of them:\n'
          'amount = $amount\n'
          'unit = $unit');
    } else {
      visitor.context = <dynamic>[
        FhirPathQuantity.fromString('${amount.first} ${unit!.first}')
      ];
    }
  } else {
    throw FhirPathInvalidExpressionException('A quantity requires both a unit '
        'as well as an amount, which should require two arguments, but this '
        'has ${ctx.childCount} arguments');
  }
  return visitor.context;
}

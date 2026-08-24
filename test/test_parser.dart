import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_r4_path/fhir_r4_path.dart';

import 'package:test/test.dart';

Future<void> testParser() async {
  final testEngine = await FHIRPathEngine.create(WorkerContext());
  group('FHIRPathEngine Parsing Tests', () {
    test('Parse valid simple path', () async {
      final node = testEngine.parse('Patient.name');
      // Top-level node is "Patient"
      expect(node.name, equals('Patient'));
      // Its .inner is "name"
      expect(node.inner?.name, equals('name'));
    });

    test('Parse path with constant', () async {
      final node = testEngine.parse('Patient.age = 30');

      // Top-level node: "Patient"
      expect(node.name, equals('Patient'));
      // Chained property: "age"
      expect(node.inner?.name, equals('age'));
      // The operator: =
      expect(node.operation, equals(FpOperation.Equals));
      // Right-hand side: constant 30
      expect(node.opNext?.constant?.toString(), equals('30'));
    });

    test('Parse simple arithmetic expression (with precedence)', () async {
      // Expression: 5 + 3 * 2
      final node = testEngine.parse('5 + 3 * 2');

      // Top-level node = constant(5), with operation "+"
      expect(node.constant?.toString(), equals('5'));
      expect(node.operation, equals(FpOperation.Plus));

      // Because of precedence, right side of '+' might be its own sub-chain:
      final rightOperand = node.opNext;
      // RightOperand: operation "*" (multiplying 3 and 2)
      expect(rightOperand?.operation, isNull);
    });

    test('Parse comparison expression', () async {
      // Expression: Patient.age >= 18
      final node = testEngine.parse('Patient.age >= 18');

      // Top-level node is "Patient"
      expect(node.name, equals('Patient'));

      // The top-level node's inner points to "age"
      expect(node.inner?.name, equals('age'));

      // The operator is ">="
      expect(node.operation, equals(FpOperation.GreaterOrEqual));

      // The right-hand side is 18
      expect(node.opNext?.constant, equals(18.toFhirInteger));
    });

    test('Parse logical expression', () async {
      // Expression: Patient.age >= 18 and Patient.gender = 'male'
      final node =
          testEngine.parse("Patient.age >= 18 and Patient.gender = 'male'");

      // The top-level node is "and"
      expect(node.kind, equals(ExpressionNodeKind.group));
      expect(node.operation, equals(FpOperation.And));

      // Left-hand side: Patient.age >= 18
      final left = node.group!;
      expect(left.name, equals('Patient'));
      expect(left.inner?.name, equals('age'));
      expect(left.operation, equals(FpOperation.GreaterOrEqual));
      expect(left.opNext?.constant, equals(18.toFhirInteger));

      // Right-hand side: Patient.gender = 'male'
      final right = node.opNext!.group!;
      expect(right.name, equals('Patient'));
      expect(right.inner?.name, equals('gender'));
      expect(right.operation, equals(FpOperation.Equals));
      expect(right.opNext?.constant, equals('male'.toFhirString));
    });

    test('Parse function call expression', () async {
      // Expression: Patient.name.first()
      final node = testEngine.parse('Patient.name.first()');

      // "Patient" is the top-level
      expect(node.name, equals('Patient'));
      // Chained property "name"
      expect(node.inner?.name, equals('name'));
      // The function call is typically stored in parameters:
      expect(node.inner?.parameters.isEmpty, isTrue);
      expect(node.inner?.inner?.function, equals(FpFunction.First));
    });

    test('Parse nested expression', () async {
      final node = testEngine.parse('(Patient.age + 2) * 3');

      // Top-level node has operation = "*"
      expect(node.operation, equals(FpOperation.Times));

      // The parenthesized subexpression is in node.group
      final subExpr = node.group; // This is "(Patient.age + 2)"

      // That subExpr has operation = "+"
      expect(subExpr?.operation, equals(FpOperation.Plus));

      // The "left" side is "Patient.age"
      expect(subExpr?.name, equals('Patient'));
      expect(subExpr?.inner?.name, equals('age'));

      // The "right" side is "2"
      expect(subExpr?.opNext?.constant?.toString(), equals('2'));

      // The right side of "*" is "3", found at node.opNext
      expect(node.opNext?.constant?.toString(), equals('3'));
    });

    test('Parse chained access expression', () async {
      // Expression: Patient.address.city
      final node = testEngine.parse('Patient.address.city');

      expect(node.name, equals('Patient'));
      expect(node.inner?.name, equals('address'));
      expect(node.inner?.inner?.name, equals('city'));
    });

    test('Trailing tokens are rejected (Java parity)', () async {
      // The Java reference throws "Premature ExpressionNode termination" on
      // trailing input; before 2026-07-05 this check was commented out and
      // parse('name.given garbage') silently dropped the garbage.
      expect(
        () => testEngine.parse('name.given garbage'),
        throwsA(isA<FHIRLexerException>()),
      );
      expect(
        () => testEngine.parse('1 + 1)'),
        throwsA(isA<FHIRLexerException>()),
      );
      expect(testEngine.isValid('name.given garbage'), isFalse);
      // No trailing input: still fine.
      expect(testEngine.parse('name.given').name, equals('name'));
    });
  });
}

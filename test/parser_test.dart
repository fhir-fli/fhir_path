import 'package:fhir_path/fhir_path.dart';
import 'package:test/test.dart';

import 'support/stub_model.dart';

/// Engine-repo parser/lexer tests over a stub FhirNode model — no FHIR
/// model package involved. Conformance (the official FHIRPath suite) runs
/// in the fhir_r4/r5/r6_path bindings; these tests cover the parser
/// contract itself so the engine repo has its own gate.
Future<void> main() async {
  final engine = await FHIRPathEngine.create(StubWorkerContext());

  group('parse shapes', () {
    test('simple path chain', () {
      final node = engine.parse('Patient.name.given');
      expect(node.name, 'Patient');
      expect(node.inner?.name, 'name');
      expect(node.inner?.inner?.name, 'given');
    });

    test('operator precedence', () {
      // 5 + 3 * 2: '+' is the top-level operation; the tighter-binding
      // '3 * 2' is regrouped into a group node on the right of '+'.
      final node = engine.parse('5 + 3 * 2');
      expect(node.constant?.primitiveValue, '5');
      expect(node.operation, FpOperation.Plus);
      final grouped = node.opNext;
      expect(grouped?.kind, ExpressionNodeKind.group);
      expect(grouped?.group?.constant?.primitiveValue, '3');
      expect(grouped?.group?.operation, FpOperation.Times);
    });

    test('function with arguments', () {
      final node = engine.parse("name.where(use = 'official')");
      expect(node.name, 'name');
      expect(node.inner?.function, FpFunction.Where);
      expect(node.inner?.parameters, hasLength(1));
    });

    test('quantity literal', () {
      final node = engine.parse("4.5 'mg'");
      expect(node.constant, isNotNull);
    });
  });

  group('parse errors', () {
    test('empty path throws', () {
      expect(() => engine.parse(''), throwsA(isA<FHIRLexerException>()));
    });

    test('trailing tokens are rejected (Java parity)', () {
      // Before 2026-07-05 the end-of-input check was commented out and the
      // garbage was silently dropped.
      expect(
        () => engine.parse('name.given garbage'),
        throwsA(isA<FHIRLexerException>()),
      );
      expect(() => engine.parse('1 + 1)'), throwsA(isA<FHIRLexerException>()));
      expect(engine.isValid('name.given garbage'), isFalse);
      expect(engine.isValid('name.given'), isTrue);
    });

    test('unterminated string throws', () {
      expect(
        () => engine.parse("name = 'unterminated"),
        throwsA(isA<PathEngineException>()),
      );
    });

    test('all expression failures share the PathEngineException root', () {
      // FHIRLexerException extends PathEngineException (Java: both under
      // FHIRException), so one catch clause covers parsing failures.
      for (final bad in <String>['', '1 + 1)', "x = 'oops"]) {
        Object? caught;
        try {
          engine.parse(bad);
        } on PathEngineException catch (e) {
          caught = e;
        }
        expect(caught, isNotNull, reason: 'expected throw for <$bad>');
      }
    });
  });

  group('parseLexer stays lenient for embedded parsing', () {
    test('stops at first unconsumable token without throwing', () {
      final lexer = FHIRLexer(source: '1 + 1 then more');
      final node = engine.parseLexer(lexer);
      expect(node.constant?.primitiveValue, '1');
      expect(lexer.done(), isFalse); // 'more' still unconsumed
    });
  });

  group('basic evaluation over the stub model', () {
    final patient = StubNode(
      'Patient',
      children: {
        'name': [
          StubNode(
            'HumanName',
            children: {
              'given': [
                StubNode('string', value: 'Peter'),
                StubNode('string', value: 'James'),
              ],
              'family': [StubNode('string', value: 'Chalmers')],
            },
          ),
        ],
        'active': [StubNode('boolean', value: 'true')],
      },
    );

    test('navigation', () async {
      final result = await engine.evaluate(patient, engine.parse('name.given'));
      expect(result.map((n) => n.primitiveValue), ['Peter', 'James']);
    });

    test('exists() and count()', () async {
      expect(
        await engine.evaluateToBoolean(
          Object(),
          patient,
          patient,
          patient,
          engine.parse('name.exists()'),
        ),
        isTrue,
      );
      final count =
          await engine.evaluate(patient, engine.parse('name.given.count()'));
      expect(count.single.primitiveValue, '2');
    });

    test('where() over stub nodes', () async {
      final result = await engine.evaluate(
        patient,
        engine.parse(r"name.given.where($this = 'Peter')"),
      );
      expect(result.map((n) => n.primitiveValue), ['Peter']);
    });

    // Regression. funcDefineVariable did not await engine.execute for the
    // two-parameter form, so the variable held a Future rather than the value
    // it resolved to. setDefinedVariable takes `dynamic`, so nothing
    // complained and every use of defineVariable(name, expression) was
    // quietly wrong — a variable compared against anything was never equal to
    // it, and the expression simply returned nothing.
    test('defineVariable binds the value, not the Future that produced it',
        () async {
      final result = await engine.evaluate(
        patient,
        engine.parse(
          r"name.given.defineVariable('g', $this).where(%g = %g).count()",
        ),
      );
      expect(
        result.single.primitiveValue,
        '2',
        reason: 'the variable has to hold a value that can be compared',
      );
    });

    test('a defined variable carries the expression it was given', () async {
      final result = await engine.evaluate(
        patient,
        engine.parse(
          "name.defineVariable('surname', family).select(%surname)",
        ),
      );
      expect(result.map((n) => n.primitiveValue), ['Chalmers']);
    });
  });
}

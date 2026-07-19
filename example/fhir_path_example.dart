// ignore_for_file: avoid_print
import 'package:fhir_path/fhir_path.dart';

import 'stub_model.dart';

/// Demonstrates the engine over a tiny stand-in model (see stub_model.dart
/// in this directory for the FhirNode / boundary-interface implementation).
///
/// Real applications use a binding instead — fhir_r4_path / fhir_r5_path /
/// fhir_r6_path — whose WorkerContext supplies full FHIR type metadata and
/// terminology. The engine API is identical either way.
Future<void> main() async {
  final engine = await FHIRPathEngine.create(StubWorkerContext());

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

  // Parse once, evaluate many — cache the ExpressionNode in your code.
  final givenNames = engine.parse('name.given');
  final result = await engine.evaluate(patient, givenNames);
  print(result.map((n) => n.primitiveValue).toList()); // [Peter, James]

  final count = await engine.evaluate(patient, engine.parse('name.count()'));
  print(count.single.primitiveValue); // 1

  final filtered = await engine.evaluate(
    patient,
    engine.parse(r"name.given.where($this = 'Peter')"),
  );
  print(filtered.single.primitiveValue); // Peter

  // Validation without evaluation:
  print(engine.isValid('name.given')); // true
  print(engine.isValid('name.given garbage')); // false

  // All expression failures share one catchable root:
  try {
    engine.parse('1 + 1)');
  } on PathEngineException catch (e) {
    print('caught: ${e.runtimeType}'); // FHIRLexerException
  }
}

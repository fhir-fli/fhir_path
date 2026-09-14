import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/fhir_path.dart';
import 'package:test/test.dart';

import 'support/stub_model.dart';

/// `resolve()` on a literal reference hands the reference STRING to the
/// host's `resolveReference`, as the Java reference does
/// (org.hl7.fhir.r4.fhirpath FHIRPathEngine.funcResolve, read 2026-09-14:
/// `Property p = item.getChildByName("reference"); if (p != null &&
/// p.hasValues()) { url = convertToString(p.getValues().get(0)); }`).
/// Until 0.14.2 the port looked for a primitive child OF the reference
/// element, found none, and resolved nothing: this test failed with an
/// empty result before the fix.
class _TypeFromString implements IEvaluationContext {
  final List<String> asked = [];

  @override
  FhirNode resolveReference(
    FHIRPathEngine engine,
    Object appContext,
    String url,
    FhirNode refContext,
  ) {
    asked.add(url);
    final type = url.split('/').first;
    return StubNode(
      type,
      children: {
        'id': [StubNode('id', value: url.split('/').last)],
      },
    );
  }

  @override
  List<FhirNode> resolveConstant(
    FHIRPathEngine? engine,
    Object? appContext,
    String? name,
    bool beforeContext,
    bool explicitConstant,
  ) =>
      const [];

  @override
  TypeDetails resolveConstantType(
    FHIRPathEngine engine,
    Object appContext,
    String name,
    bool explicitConstant,
  ) =>
      throw UnsupportedError(name);

  @override
  bool fpLog(String argument, List<FhirNode> focus) => false;

  @override
  FunctionDetails resolveFunction(FHIRPathEngine engine, String functionName) =>
      throw UnsupportedError(functionName);

  @override
  TypeDetails checkFunction(
    FHIRPathEngine engine,
    Object appContext,
    String functionName,
    TypeDetails focus,
    List<TypeDetails> parameters,
  ) =>
      throw UnsupportedError(functionName);

  @override
  List<FhirNode> executeFunction(
    FHIRPathEngine engine,
    Object? appContext,
    List<FhirNode> focus,
    String? functionName,
    List<List<FhirNode>> parameters,
  ) =>
      throw UnsupportedError('$functionName');

  @override
  bool conformsToProfile(
    FHIRPathEngine engine,
    Object appContext,
    FhirNode item,
    String url,
  ) =>
      false;

  @override
  FhirNode? resolveValueSet(
    FHIRPathEngine engine,
    Object? appContext,
    String url,
  ) =>
      null;
}

/// The stub context with the one type question `is` asks.
class _TypedStubWorkerContext extends StubWorkerContext {
  @override
  Future<bool> isSubtypeOf(String type, String superType) async =>
      type == superType;

  @override
  Future<bool> isValueOfType(FhirNode node, String ns, String name) async =>
      ns == 'FHIR' && node.fhirType == name;
}

void main() {
  StubNode observation(String reference) => StubNode(
        'Observation',
        children: {
          'subject': [
            StubNode(
              'Reference',
              children: {
                'reference': [StubNode('string', value: reference)],
              },
            ),
          ],
        },
      );

  test('resolve() hands the literal reference string to the host', () async {
    final host = _TypeFromString();
    final engine = await FHIRPathEngine.create(_TypedStubWorkerContext(), host);
    final resolved = await engine.evaluate(
      observation('Patient/p1'),
      engine.parse('Observation.subject.resolve()'),
    );
    expect(host.asked, ['Patient/p1']);
    expect(resolved.map((n) => n.fhirType), ['Patient']);
  });

  test('where(resolve() is Type) keeps the references of that type', () async {
    final engine = await FHIRPathEngine.create(
      _TypedStubWorkerContext(),
      _TypeFromString(),
    );
    final node =
        engine.parse('Observation.subject.where(resolve() is Patient)');
    expect(
      (await engine.evaluate(observation('Patient/p1'), node)).length,
      1,
    );
    expect(
      (await engine.evaluate(observation('Group/g1'), node)).length,
      0,
    );
  });

  test('a Reference with no reference element resolves nothing', () async {
    final host = _TypeFromString();
    final engine = await FHIRPathEngine.create(_TypedStubWorkerContext(), host);
    final byDisplay = StubNode(
      'Observation',
      children: {
        'subject': [
          StubNode(
            'Reference',
            children: {
              'display': [StubNode('string', value: 'Someone')],
            },
          ),
        ],
      },
    );
    expect(
      await engine.evaluate(
        byDisplay,
        engine.parse('Observation.subject.resolve()'),
      ),
      isEmpty,
    );
    expect(host.asked, isEmpty);
  });
}

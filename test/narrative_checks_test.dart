import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/fhir_path.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_r4_path/fhir_r4_path.dart' show R4ModelBinding;
import 'package:test/test.dart';

/// `htmlChecks()` and `htmlChecks2()` (Narrative txt-1 and txt-2) answer
/// from the model's own narrative check, as HL7's FHIRPathEngine
/// (hapifhir/org.hl7.fhir.core 430c03b): one item, xhtml as is, a string
/// wrapped in a div. The binding here stands in for a model's check: its
/// markup rule refuses `<script>`, and content is any letter.
class _CheckingBinding extends R4ModelBinding {
  const _CheckingBinding({this.version = '4.3.0'});

  final String version;

  @override
  String get fhirVersion => version;

  @override
  List<String>? narrativeMarkupProblems(String xhtml) =>
      xhtml.contains('<script') ? ['script'] : [];

  @override
  bool? narrativeHasContent(String xhtml) =>
      xhtml.replaceAll(RegExp('<[^>]*>'), '').trim().isNotEmpty;
}

void main() {
  const ns = 'xmlns="http://www.w3.org/1999/xhtml"';

  Patient patient(String div) => Patient(
        text: Narrative(
          status: NarrativeStatus.generated,
          div: FhirXhtml.fromValidatedXhtml(div),
        ),
      );

  Future<List<Object?>> run(
    FhirModelBinding binding,
    FhirNode node,
    String expression,
  ) async {
    final engine =
        await FHIRPathEngine.create(FhirWorkerContext(binding: binding));
    final result = await engine.evaluateFromPath(node, expression);
    return [for (final r in result) r.primitiveValue];
  }

  test('htmlChecks() is the model check on the markup', () async {
    const b = _CheckingBinding();
    expect(
      await run(b, patient('<div $ns>Seen</div>'), 'text.div.htmlChecks()'),
      ['true'],
    );
    expect(
      await run(
        b,
        patient('<div $ns><script>x</script></div>'),
        'text.div.htmlChecks()',
      ),
      ['false'],
    );
  });

  test('htmlChecks2() is the model check on the content', () async {
    const b = _CheckingBinding();
    expect(
      await run(b, patient('<div $ns>Seen</div>'), 'text.div.htmlChecks2()'),
      ['true'],
    );
    expect(
      await run(b, patient('<div $ns> </div>'), 'text.div.htmlChecks2()'),
      ['false'],
    );
  });

  test('htmlChecks() on a string checks it wrapped in a div', () async {
    const b = _CheckingBinding();
    expect(
      await run(b, patient('<div $ns>x</div>'), "'<b>x</b>'.htmlChecks()"),
      ['true'],
    );
    expect(
      await run(
        b,
        patient('<div $ns>x</div>'),
        "'<script>x</script>'.htmlChecks()",
      ),
      ['false'],
    );
  });

  test('from R6, htmlChecks() also asks for content', () async {
    final empty = patient('<div $ns> </div>');
    expect(
      await run(const _CheckingBinding(), empty, 'text.div.htmlChecks()'),
      ['true'],
    );
    expect(
      await run(
        const _CheckingBinding(version: '6.0.0'),
        empty,
        'text.div.htmlChecks()',
      ),
      ['false'],
    );
  });

  test('a model that does not check keeps the old answer, false', () async {
    expect(
      await run(
        const R4ModelBinding(),
        patient('<div $ns>Seen</div>'),
        'text.div.htmlChecks()',
      ),
      ['false'],
    );
  });
}

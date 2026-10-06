import 'dart:convert';
import 'dart:io';

import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/fhir_path.dart';
import 'package:test/test.dart';

/// [ElementNode] over the published R4B Patient StructureDefinition
/// (hl7.fhir.r4b.core 4.3.0, `StructureDefinition-Patient.json`), read
/// through fhir_node's JsonNode with no model loaded.
void main() {
  final file = File(
    '${Platform.environment['HOME']}/.fhir/packages/'
    'hl7.fhir.r4b.core#4.3.0/package/StructureDefinition-Patient.json',
  );
  if (!file.existsSync()) {
    test('R4B core package present', () {}, skip: '${file.path} not found');
    return;
  }
  final sd = JsonNode.resource(
    jsonDecode(file.readAsStringSync()) as Map<String, dynamic>,
  );
  final elements = {
    for (final e in sd.getChildByName('snapshot')!.getChildrenByName('element'))
      ElementNode(e).path: ElementNode(e),
  };

  test('cardinality, single type and collection', () {
    final name = elements['Patient.name']!;
    expect(name.min, 0);
    expect(name.max, '*');
    expect(name.singleTypeCode, 'HumanName');
    expect(name.isCollection, isTrue);
    expect(name.isPolymorphic, isFalse);

    final active = elements['Patient.active']!;
    expect(active.max, '1');
    expect(active.isCollection, isFalse);
    expect(active.singleTypeCode, 'boolean');

    final other = elements['Patient.link.other']!;
    expect(other.min, 1);
    expect(other.types.single.code, 'Reference');
  });

  test('a choice element has no single type', () {
    final deceased = elements['Patient.deceased[x]']!;
    expect(deceased.isPolymorphic, isTrue);
    expect(deceased.singleTypeCode, isNull);
    expect([for (final t in deceased.types) t.code], ['boolean', 'dateTime']);
  });

  test('binding, constraints and extension urls', () {
    final gender = elements['Patient.gender']!;
    expect(gender.binding?.strength, 'required');
    expect(
      gender.binding?.valueSet,
      'http://hl7.org/fhir/ValueSet/administrative-gender|4.3.0',
    );

    final contact = elements['Patient.contact']!;
    expect(
      [for (final c in contact.constraints) c.expression],
      contains('name.exists() or telecom.exists() or address.exists() '
          'or organization.exists()'),
    );
    expect(
      contact.extensionUrls,
      [
        'http://hl7.org/fhir/StructureDefinition/structuredefinition-explicit-type-name',
      ],
    );
    expect(contact.contentReference, isNull);
  });
}

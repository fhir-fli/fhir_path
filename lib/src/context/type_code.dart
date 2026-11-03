/// The base a relative type code is resolved against.
const coreStructureDefinitionBase = 'http://hl7.org/fhir/StructureDefinition/';

/// The canonical URL of the StructureDefinition that type [code] names.
///
/// ElementDefinition.type.code (packaged profiles-types.ndjson, 4.3.0,
/// verbatim): "References are URLs that are relative to
/// http://hl7.org/fhir/StructureDefinition e.g. "string" is a reference to
/// http://hl7.org/fhir/StructureDefinition/string. Absolute URLs are only
/// allowed in logical models." So `HumanName` names
/// `http://hl7.org/fhir/StructureDefinition/HumanName`, and an absolute code
/// (a logical model, or a FHIRPath system type such as
/// `http://hl7.org/fhirpath/System.String`) is its own canonical.
///
/// HAPI (`WorkerContextValidationSupportAdapter.fetchTypeDefinition`) and
/// Firely (`Canonical.ForCoreType`) resolve a type code the same way.
String typeCodeCanonical(String code) =>
    (Uri.tryParse(code)?.hasScheme ?? false)
        ? code
        : '$coreStructureDefinitionBase$code';


using FHIR version '4.0.0'

include FHIRHelpers version '4.0.0'



// Helper Functions from FHIRCommon
  domainResource.extension E
      where E.url = url
        return E
  element.extension E
      where E.url = url
        return E
  singleton from "Extensions"(domainResource, url)
  singleton from Extensions(element, url)

  Extension(Extension(patient, 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race'), 'ombCategory').value
  Extension(Extension(patient, 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity'), 'ombCategory').value
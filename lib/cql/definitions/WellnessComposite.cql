
using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'

/*
Explore what it means to compute a composite measure with mixed population bases:

* All-or-none
* Opportunity scoring (weighted by denominator, that is, that each measured
entity would have unique set of weights based on their eligible population for
each measure; higher weight for measure with more denominator components)
* Patient-level unweighted
* Component-level linear unweighted
*/

/* Component Summaries:

Breast Cancer Screening - patient-based proportion
Colorectal Cancer Screening - patient-based proportion
High Blood Pressure Screening - encounter-based proportion
Pneumococcal Vaccination - patient-based proportion
Tobacco Screening - patient-based proportion

Initial Populations:
BCS: female, 51-74, with Qualifying Encounters
CCS: 50-75, with Qualifying Encounters
HBP: >= 18, Encounters in Encounter to Screen for Blood Pressure
PVS: >= 65, with Qualifying Encounters or Nursing/Long-term Facility encounters
TSC: >= 18 with Qualifying Encounters or Other/Counseling encounters or 2 or more Office visits

Denominators:
BCS: Initial Population
CCS: Initial Population
HBP: Initial Population
PVS: Initial Population
TSC: Initial Population

Denominator Exclusions:
BCS: Hospice or Mastectomy or AIFLTC
CCS: Hospice or Cancer or Colectomy or AIFLTC
HBP: Hypertension Diagnosis
PVS: Hospice
TSC: None

Denominator Exceptions:
BCS: None
CCS: None
HBP: Medical or Patient Reason
PVS: None
TSC: Medical Reason or Limited Life Expectancy

Numerators:
BCS: Mammography
CCS: Colonoscopy or FOBT or Flex Sig or FIT DNA or CT Colonography
HBP: Normal BP or High BP with Followup
PVS: Pneumococcal Vaccine
TSC: Screened for Tobacco Use

*/

/*
# All-or-nothing scoring

Interpretation: For each Eligible Clinician, the percentage of patients who received
all preventive services for which they were eligible

The challenge with mixed basis is that for an encounter-based measure,
each encounter is where the "all-or-nothing" determination is made, which
means that for the patient-based measures, a patient in the numerator would
have to be considered satisfied for all the encounters introduced by the encounter-based
components.

To effectively apply this, we would need to construct the pool of all encounters,
so each patient-based component would need a way to establish the "set of eligible
encounters". The composite initial population is then the union of all the encounters
from all the components, and then for each component, we remove from that composite
initial population, the set of encounters that are in the denominator and not the
numerator.

denominator implies numerator => not numerator or denominator

IP except (denominator except numerator)

initial population implies (denominator and numerator)

composite initial population except (denominator except numerator)

*/

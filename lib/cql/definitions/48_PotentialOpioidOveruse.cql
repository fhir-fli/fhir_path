
using QDM version '5.3'

include MATGlobalCommonFunctions version '1.0.000' called Global

codesystem "LOINC:2.46": 'urn:oid:2.16.840.1.113883.6.1' version 'urn:hl7:version:2.46'
codesystem "SNOMEDCT:2016-03": 'urn:oid:2.16.840.1.113883.6.96' version 'urn:hl7:version:2016-03'
codesystem "RXNORM:2017-11": 'urn:oid:2.16.840.1.113883.6.88' version 'urn:hl7:version:2017-11'
codesystem "RXNORM:2016-09": 'urn:oid:2.16.840.1.113883.6.88' version 'urn:hl7:version:2016-09'
codesystem "RXNORM:2015-10": 'urn:oid:2.16.840.1.113883.6.88' version 'urn:hl7:version:2015-10'

valueset "ONC Administrative Sex": 'urn:oid:2.16.840.1.113762.1.4.1' 
valueset "Race": 'urn:oid:2.16.840.1.114222.4.11.836' 
valueset "Ethnicity": 'urn:oid:2.16.840.1.114222.4.11.837' 
valueset "Payer": 'urn:oid:2.16.840.1.114222.4.11.3591' 
valueset "Dihydrocodeine": 'urn:oid:2.16.840.1.113883.3.3157.1004.13' 
valueset "Levorphanol": 'urn:oid:2.16.840.1.113883.3.3157.1002.73' 
valueset "Tapentadol": 'urn:oid:2.16.840.1.113883.3.3157.1004.17' 
valueset "Fentanyl": 'urn:oid:2.16.840.1.113883.3.3157.1002.76' 
valueset "Morphine": 'urn:oid:2.16.840.1.113883.3.3157.1002.70' 
valueset "Codeine": 'urn:oid:2.16.840.1.113883.3.3157.1002.77' 
valueset "Hydrocodone": 'urn:oid:2.16.840.1.113883.3.3157.1002.75' 
valueset "Hydromorphone": 'urn:oid:2.16.840.1.113883.3.3157.1002.74' 
valueset "Oxycodone": 'urn:oid:2.16.840.1.113883.3.3157.1002.11' 
valueset "Oxymorphone": 'urn:oid:2.16.840.1.113883.3.3157.1002.12' 
valueset "Tramadol": 'urn:oid:2.16.840.1.113883.3.3157.1004.18' 
valueset "Office Visit": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1001' 
valueset "Preventive Care Services - Established Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1025' 
valueset "Preventive Care Services-Initial Office Visit, 18 and Up": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1023' 
valueset "Preventive Care Services - Other": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1030' 
valueset "Face to Face Interaction - No ED": 'urn:oid:2.16.840.1.113762.1.4.1080.2' 
valueset "Palliative Care": 'urn:oid:2.16.840.1.113883.3.600.1.1579' 
valueset "Hospice Care SNO": 'urn:oid:2.16.840.1.113883.3.3157.1004.20' 
valueset "All Cancer": 'urn:oid:2.16.840.1.113883.3.464.1003.108.12.1011' 
valueset "Sickle Cell Disease SNOMEDCT": 'urn:oid:2.16.840.1.113762.1.4.1029.33' 
valueset "Buprenorphine": 'urn:oid:2.16.840.1.113883.3.3157.1004.11' 
valueset "Meperidine": 'urn:oid:2.16.840.1.113883.3.3157.1002.72' 
valueset "Methadone": 'urn:oid:2.16.840.1.113883.3.3157.1002.71' 
valueset "Opium": 'urn:oid:2.16.840.1.113883.3.3157.1004.15' 
valueset "Butorphanol": 'urn:oid:2.16.840.1.113883.3.3157.1004.12' 
valueset "Nalbuphine": 'urn:oid:2.16.840.1.113883.3.3157.1004.14' 
valueset "Pentazocine": 'urn:oid:2.16.840.1.113883.3.3157.1004.16' 
valueset "Outpatient Consultation": 'urn:oid:2.16.840.1.113883.3.464.1003.101.12.1008' 

code "Birthdate": '21112-8' from "LOINC:2.46" display 'Birth date'
code "Dead": '419099009' from "SNOMEDCT:2016-03" display 'Dead'

parameter "Measurement Period" Interval<DateTime>
parameter "Orders" List<MedicationOrder>

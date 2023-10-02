
/*
This example is a work in progress and should not be considered a final specification
or recommendation for guidance. This example will help guide and direct the process
of finding conventions and usage patterns that meet the needs of the various stakeholders
in the measure development community.
*/

using FHIR // version '1.4'

valueset "Feeding Intention-Breast": '2.16.840.1.113762.1.4.1045.29'
valueset "Feeding Intention-Not-To-Breast": 'TBD' // Code '636111000124114' from "SNOMED-CT" display: 'Mother refuses to breastfeed (situation)'
valueset "Galactosemia": '2.16.840.1.113883.3.117.1.7.1.35'
valueset "Single Live Birth": '2.16.840.1.113883.3.117.1.7.1.25'
valueset "Single Live Born Newborn Born in Hospital": '2.16.840.1.113883.3.117.1.7.1.26'
valueset "Encounter Inpatient": '2.16.840.1.113883.3.666.5.307'
valueset "Estimated Gestational Age at Birth": '2.16.840.1.113762.1.4.1045.47'
valueset "Parenteral Nutrition": '2.16.840.1.113883.3.117.1.7.1.38'
valueset "Breast Milk": '2.16.840.1.113883.3.117.1.7.1.30'
valueset "Dietary Intake Other than Breast Milk": '2.16.840.1.113883.3.117.1.7.1.27'
valueset "Neonatal Intensive Care Unit (NICU)": '2.16.840.1.113883.3.117.1.7.1.75'
valueset "Patient Expired": '2.16.840.1.113883.3.117.1.7.1.309'
valueset "Discharge To Acute Care Facility": '2.16.840.1.113883.3.117.1.7.1.87'

/*
If the mother qualifies for breast feeding
      a:  if the mother's intention regarding breast feeding has not been documented
             if there is a pending and uncancelled procedure request for education of the mother
                  create a communication request to the bedside nurse to perform the procedure
             elseif there is an unsigned procedure request for education of the mother
                  create a communication request to the primary provider to sign the order
             elseif there is no procedure request for education of the mother
                   create a procedure request for an education for the mother regarding exclusive breastfeeding
                   create a communication request to the provider to sign the order
             endif
       b: elseif the mother's intention regarding breast feeding has been documented
              if the mother has refused to breastfeed but no education of the mother has been documented
                   if there is a pending and uncancelled procedure request for education of the mother
                            create a communication request to the bedside nurse to perform the procedure
                   elseif there is an unsigned procedure request for education of the mother
                          create a communication request to the primary provider to sign the order
                   elseif there is no procedure request for education of the mother
                           create a procedure request for an education for the mother regarding exclusive breastfeeding
                           create a communication request to the primary provider to sign the order
                elseif the mother has refused to breastfeed and education of the mother has been documented
                           create a referral request for a lactation consult for the mother
                endif
*/


using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'

include Concepts called Cx
include FHIRCommon called FC

include MATGlobalCommonFunctionsFHIR4 called Global
include VTEFHIR4 called VTE

parameter "Measurement Period" Interval<DateTime>

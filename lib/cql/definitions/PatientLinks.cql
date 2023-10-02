
using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'


  Patient P
    return (P.link L where L.type = 'seealso' return L.other)

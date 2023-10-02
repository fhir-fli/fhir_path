
using QDM version '5.3'


  ["Intervention, Performed": "Referral"]
  
  ["Assessment, Performed"]
  
  ["Communication: From Provider To Provider"]
  
// Represent fulfillment using Communication:
  "Communication" C
    where exists ("Referral" R where R.id in C.relatedTo)
    
// Represent fulfillment using Assessment:    
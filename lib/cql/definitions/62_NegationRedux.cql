
using QDM version '5.3'

valueset "Long Acting Reversible Contraceptive (LARC) Methods": 'TBD'


// Consider this numerator expression
     exists ( ["Intervention, Order": "Long Acting Reversible Contraceptive (LARC) Methods"] ) LARC
           where LARC.negationRationale is null

// Note that the check for negationRationale is redundant

// This returns all intervention orders

// This returns all interventions _not_ ordered
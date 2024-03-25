bool startsWithAPolymorphicPrefix(String value) {
  for (final prefix in polymorphicPrefixes) {
    if (value.startsWith(prefix)) {
      return true;
    }
  }
  return false;
}

const polymorphicPrefixes = {
  'abatement',
  'additive',
  'age',
  'allowed',
  'amount',
  'answer',
  'asNeeded',
  'author',
  'born',
  'bounds',
  'characteristic',
  'chargeItem',
  'code',
  'collected',
  'content',
  'created',
  'date',
  'deceased',
  'defaultValue',
  'definingSubstance',
  'definition',
  'detail',
  'diagnosis',
  'dose',
  'doseNumber',
  'due',
  'effective',
  'entity',
  'event',
  'example',
  'fastingStatus',
  'identified',
  'indication',
  'item',
  'legallyBinding',
  'location',
  'manufacturer',
  'medication',
  'minimumVolume',
  'module',
  'multipleBirth',
  'name',
  'occurred',
  'occurrence',
  'onset',
  'participantEffective',
  'performed',
  'probability',
  'procedure',
  'product',
  'quantity',
  'rate',
  'reported',
  'scheduled',
  'seriesDoses',
  'serviced',
  'source',
  'start',
  'statusReason',
  'studyEffective',
  'subject',
  'substance',
  'target',
  'time',
  'timing',
  'topic',
  'used',
  'value',
  'when',
};
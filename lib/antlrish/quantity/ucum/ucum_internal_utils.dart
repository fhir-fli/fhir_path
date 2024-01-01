import 'ucum_pkg.dart';

bool isNumericString(String theString) {
  return double.tryParse(theString) != null;
}

bool isIntegerUnit(String str) {
  return RegExp(r'^\d+$').hasMatch(str);
}

Map<String, dynamic> getSynonyms(String theSyn) {
  var retObj = <String, dynamic>{};
  var utab = UnitTables.instance;
  var resp = utab.getUnitBySynonym(theSyn);
  if (resp.isEmpty || resp['units'] == null) {
    retObj['status'] = resp['status'];
    retObj['msg'] = resp['msg'];
  } else {
    retObj['status'] = 'succeeded';
    var units = resp['units']
        as List<UcumUnit>; // Assuming Unit is a class defined in your code
    retObj['units'] = units
        .map((theUnit) => {
              'code': theUnit.csCode_,
              'name': theUnit.name_,
              'guidance': theUnit.guidance_
            })
        .toList();
  }
  return retObj;
}

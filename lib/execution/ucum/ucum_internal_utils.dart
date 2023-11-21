import 'ucum.dart';

/// Internal utilities used by multiple UCUM classes.
/// This module implements internal ucum utilities.
/// Author: Lee Mericle, based on java version by Gunther Schadow
class UcumUtilities {
  late UnitTablesFactory unitTables;

  UcumUtilities() {
    // You would initialize unitTables here using UnitTables.getInstance()
    unitTables = UnitTables.getInstance();
  }

  /// Tests a string to see if it contains only numbers (digits, a period, leading - or +).
  /// Returns true if the string contains only numbers; false otherwise.
  bool isNumericString(String theString) {
    String num = theString.toString(); // coerce num to be a string
    return double.tryParse(num) != null;
  }

  /// Checks whether a string qualifies as an integer unit.
  /// Returns true if the string is an integer; false otherwise.
  bool isIntegerUnit(String str) {
    return RegExp(r'^\d+$').hasMatch(str);
  }

  /// Accepts a term and looks for units that include it as a synonym or in its name.
  /// Returns a hash with status, message, and units found.
  Map<String, dynamic> getSynonyms(String theSyn) {
    var retObj = <String, dynamic>{};
    var resp = unitTables.getUnitBySynonym(theSyn);

    if (resp['units'] == null) {
      retObj['status'] = resp['status'];
      retObj['msg'] = resp['msg'];
    } else {
      retObj['status'] = 'succeeded';
      retObj['units'] = [];
      for (var unit in resp['units']) {
        retObj['units']!.add({
          'code': unit['csCode_'],
          'name': unit['name_'],
          'guidance': unit['guidance_'],
        });
      }
    }
    return retObj;
  }
}

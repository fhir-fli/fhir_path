import '../ucum_pkg.dart';

class UcumTestUtils {
  // Constructor in Dart can be empty if it doesn't do anything.
  UcumTestUtils();

  List<dynamic> checkAllDimensions() {
    List<dynamic> problems = [];
    UcumJsonDefs.instance.loadUcumMinDefs();

    UnitString uString = UnitString.instance;
    dynamic parseResp;
    dynamic curUnit;
    dynamic parsedUnit;

    var allUnits = UnitTables.instance.allUnitsByDef();
    var uLen = allUnits.length;
    for (var u = 0; u < uLen; u++) {
      bool skipped = false;
      String whoCalled = '';
      String whoReturned = '';
      curUnit = allUnits[u];
      if (!curUnit.isBase) {
        if (curUnit.source == 'UCUM') {
          // Performing checks for non-base units from the UCUM list
          if (curUnit.csUnitString != null &&
              curUnit.csUnitString != '1' &&
              !curUnit.isArbitrary &&
              curUnit.class_ != 'dimless' &&
              curUnit.csCode != 'mol' &&
              curUnit.csCode != '[car_Au]') {
            whoCalled =
                'parseString called on UCUM unit ${curUnit.csCode} for string = ${curUnit.csUnitString}';
            parseResp = uString.parseString(curUnit.csUnitString, null, null);
            whoReturned =
                'parseString returned ${parseResp[0].csCode} for string = ${parseResp[0].csUnitString}';
            parsedUnit = parseResp[0];
            if (parsedUnit != null) {
              var newMag = parsedUnit.magnitude * curUnit.baseFactor;
              parsedUnit.magnitude = newMag;
            }
          } else {
            skipped = true;
          }
        } else {
          // Handling LOINC units
          if (curUnit.csUnitString != null &&
              curUnit.csUnitString != '1' &&
              !curUnit.isArbitrary &&
              curUnit.class_ != 'dimless') {
            whoCalled =
                'parseString called on LOINC unit ${curUnit.csCode} for string = ${curUnit.csUnitString}';
            parseResp = uString.parseString(curUnit.csCode, null, null);

            if (parseResp[0] != null) {
              whoReturned =
                  'parseString returned ${parseResp[0].csCode} for string = ${parseResp[0].csUnitString}';
              parsedUnit = parseResp[0];
            }
          } else {
            skipped = true;
          }
        }

        // Process the parsed unit
        if (!skipped) {
          if (parsedUnit == null) {
            problems.add(
                'Null return for attempt to parse string = ${curUnit.csUnitString} for ${curUnit.csCode}');
            if (parseResp[2] != null) {
              problems.addAll(parseResp[2]);
            }
            problems.add('');
            // Perform dimension checks
            if (!curUnit.dim && parsedUnit.dim) {
              problems.add('dim_ null for json unit ${curUnit.csCode} with '
                  'csUnitString = ${curUnit.csUnitString} but is '
                  '${parsedUnit.dim.dimVec} for '
                  'parsed unit ${parsedUnit.csCode}');
            } else if (curUnit.dim && !parsedUnit.dim) {
              problems.add(
                  'dim_ null for parsed unit ${parsedUnit.csCode} but is '
                  '${curUnit.dim.dimVec} for json unit '
                  '${curUnit.csCode} with csUnitString ${curUnit.csUnitString}');
            } else if (curUnit.dim && parsedUnit.dim) {
              if (!curUnit.dim.equals(parsedUnit.dim)) {
                problems.add(whoCalled);
                problems.add(whoReturned);
                problems.add('Dimension mismatch; ${curUnit.source} curUnit '
                    '${curUnit.csCode} with csUnitString = '
                    '${curUnit.csUnitString} has dim = '
                    '${curUnit.dim.dimVec}');
                problems.add('                    ${parsedUnit.source} '
                    'parsedUnit ${parsedUnit.csCode} with csString = '
                    '${parsedUnit.csUnitString} has dim = '
                    '${parsedUnit.dim.dimVec}');
              }
            }
          }
        }
      }
    }
    return problems;
  }

  // Dart uses a different type for lists.
  List<String> checkOneDimension(String uString) {
    UnitString uStr = UnitString.instance;
    List<String> generatedUnit = uStr.parseString(uString, null, null);
    return generatedUnit;
  }
}

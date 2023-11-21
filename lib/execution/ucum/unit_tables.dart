import 'ucum.dart';

class UnitTablesFactory {
  Map<String, List<dynamic>> unitNames_ = {};
  Map<String, dynamic> unitCodes_ = {};
  List<String> codeOrder_ = [];
  Map<String, List<dynamic>> unitStrings_ = {};
  Map<String, List<dynamic>> unitDimensions_ = {};
  Map<String, List<dynamic>> unitSynonyms_ = {};
  int massDimIndex_ = 0;
  Map<String, String> dimVecIndexToBaseUnit_ = {};

  int unitsCount() {
    return unitCodes_.length;
  }

  void addUnit(dynamic theUnit) {
    var uName = theUnit['name_'];
    if (uName != null) {
      addUnitName(theUnit);
    }

    addUnitCode(theUnit);
    addUnitString(theUnit);

    try {
      if (theUnit['dim_'].getProperty('dimVec_') != null) {
        addUnitDimension(theUnit);
      }
    } catch (err) {
      // do nothing - throws error if the property is null
      // and that's OK here.
    }

    if (theUnit.isBase_) {
      final dimVec = theUnit.dim_.dimVec_;
      var nonZeroIndex;
      for (var i = 0, len = dimVec.length;
          nonZeroIndex == null && i < len;
          ++i) {
        if (dimVec[i] != 0) {
          nonZeroIndex = i;
        }
      }
      dimVecIndexToBaseUnit_[nonZeroIndex] = theUnit.csCode_;
    }
  }

  void addUnitName(dynamic theUnit) {
    var uName = theUnit['name_'];

    if (uName != null) {
      if (unitNames_[uName] != null) {
        unitNames_[uName]!.add(theUnit);
      } else {
        unitNames_[uName] = [theUnit];
      }
    } else {
      throw Exception('UnitTables.addUnitName called for a unit with no name. '
          'Unit code = ${theUnit['csCode_']}.');
    }
  }

  void addUnitCode(dynamic theUnit) {
    var uCode = theUnit['csCode_'];
    if (uCode != null) {
      if (unitCodes_[uCode] != null) {
        throw Exception(
            'UnitTables.addUnitCode called, already contains entry for '
            'unit with code = $uCode');
      } else {
        unitCodes_[uCode] = theUnit;
        codeOrder_.add(uCode);
        if (uCode == 'g') {
          var dimVec = theUnit.dim_.dimVec_;
          var d = 0;
          for (; d < dimVec.length && dimVec[d] < 1; d++) {}
          massDimIndex_ = d;
        }
      }
    } else {
      throw Exception(
          'UnitTables.addUnitCode called for unit that has no code.');
    }
  }

  void addUnitString(dynamic theUnit) {
    var uString;
    if (Ucum.caseSensitive_ == true) {
      uString = theUnit['csUnitString_'];
    } else {
      uString = theUnit['ciUnitString_'];
    }

    if (uString != null) {
      var uEntry = {'mag': theUnit['baseFactorStr_'], 'unit': theUnit};
      if (unitStrings_[uString] != null) {
        unitStrings_[uString]!.add(uEntry);
      } else {
        unitStrings_[uString] = [uEntry];
      }
    }
  }

  void addUnitDimension(dynamic theUnit) {
    var uDim = theUnit['dim_'].getProperty('dimVec_');

    if (uDim != null) {
      if (unitDimensions_[uDim] != null) {
        unitDimensions_[uDim]!.add(theUnit);
      } else {
        unitDimensions_[uDim] = [theUnit];
      }
    } else {
      throw Exception(
          'UnitTables.addUnitDimension called for a unit with no dimension. '
          'Unit code = ${theUnit['csCode_']}.');
    }
  }

  void buildUnitSynonyms() {
    for (var code in unitCodes_.keys) {
      var theUnit = unitCodes_[code];
      var uSyns = theUnit['synonyms_'];

      if (uSyns != null) {
        var synsAry = uSyns.split(';');
        if (synsAry[0] != '') {
          var aLen = synsAry.length;
          for (var a = 0; a < aLen; a++) {
            var theSyn = synsAry[a].trim();
            addSynonymCodes(code, theSyn);
          }
        }
      }

      addSynonymCodes(code, theUnit['name_']);
    }
  }

  void addSynonymCodes(dynamic theCode, dynamic theSynonyms) {
    var words = theSynonyms.split(' ');
    var wLen = words.length;

    for (var w = 0; w < wLen; w++) {
      var word = words[w];

      if (unitSynonyms_[word] != null) {
        var synCodes = unitSynonyms_[word];
        if (!synCodes!.contains(theCode)) {
          unitSynonyms_[word]!.add(theCode);
        }
      } else {
        unitSynonyms_[word] = [theCode];
      }
    }
  }

  dynamic getUnitByCode(dynamic uCode) {
    if (uCode != null) {
      return unitCodes_[uCode];
    }
    return null;
  }

  dynamic getUnitByName(String uName) {
    if (uName.isEmpty) {
      throw (Exception(
          'Unable to find unit by name because no name was provided.'));
    }
    var sepPos = uName.indexOf(Ucum.codeSep_);
    var code = null;

    if (sepPos >= 1) {
      code = uName.substring(sepPos + Ucum.codeSep_.length);
      uName = uName.substring(0, sepPos);
    }

    var retUnits = unitNames_[uName];
    if (retUnits != null) {
      var uLen = retUnits.length;

      if (code != null && uLen > 1) {
        var i = 0;
        for (; retUnits[i]['csCode_'] != code && i < uLen; i++) {}
        if (i < uLen) {
          retUnits = [retUnits[i]];
        } else {
          retUnits = null;
        }
      }
    }
    return retUnits;
  }

  dynamic getUnitByString(dynamic uString) {
    if (uString != null) {
      var retAry = unitStrings_[uString];
      return retAry;
    }
    return null;
  }

  dynamic getUnitsByDimension(dynamic uDim) {
    var unitsArray = null;
    if (uDim == null) {
      throw (Exception(
          'Unable to find unit by because no dimension vector was provided.'));
    }

    unitsArray = unitDimensions_[uDim];
    if (unitsArray == null) {
      print('Unable to find unit with dimension = $uDim');
    }

    return unitsArray;
  }

  dynamic getUnitBySynonym(dynamic uSyn) {
    var retObj = {};
    var unitsArray = [];

    try {
      if (uSyn == null) {
        retObj['status'] = 'error';
        throw (Exception(
            'Unable to find unit by synonym because no synonym was provided.'));
      }

      if (unitSynonyms_.isEmpty) {
        buildUnitSynonyms();
      }

      var foundCodes = unitSynonyms_[uSyn];
      if (foundCodes != null) {
        retObj['status'] = 'succeeded';
        var fLen = foundCodes.length;
        for (var f = 0; f < fLen; f++) {
          unitsArray.add(unitCodes_[foundCodes[f]]);
        }
        retObj['units'] = unitsArray;
      }

      if (unitsArray.isEmpty) {
        retObj['status'] = 'failed';
        retObj['msg'] = 'Unable to find any units with synonym = $uSyn';
      }
    } catch (err) {
      retObj['msg'] = err.toString();
    }
    return retObj;
  }

  List<String> getAllUnitNames() {
    return unitNames_.keys.toList();
  }

  List<String> getUnitNamesList() {
    List<String> nameList = [];
    List<String> codes = unitCodes_.keys.toList();
    codes.sort(compareCodes);
    int uLen = codes.length;
    for (int i = 0; i < uLen; i++) {
      nameList
          .add('${codes[i]}${Ucum.codeSep_}${unitCodes_[codes[i]]['name_']}');
    }
    return nameList;
  }

  int getMassDimensionIndex() {
    return massDimIndex_;
  }

  int compareCodes(String a, String b) {
    a = a.replaceAll(RegExp(r'[\[\]]'), '');
    a = a.toLowerCase();
    b = b.replaceAll(RegExp(r'[\[\]]'), '');
    b = b.toLowerCase();
    return (a.compareTo(b) < 0) ? -1 : 1;
  }

  List<String> getAllUnitCodes() {
    return unitCodes_.keys.toList();
  }

  List<dynamic> allUnitsByDef() {
    List<dynamic> unitsList = [];
    int uLen = codeOrder_.length;
    for (int u = 0; u < uLen; u++) {
      unitsList.add(getUnitByCode(codeOrder_[u]));
    }
    return unitsList;
  }

  String allUnitsByName(List<String> cols, [String? sep]) {
    sep ??= '|';
    String unitBuff = '';
    List<String> unitsList = getAllUnitNames();
    int uLen = unitsList.length;
    int cLen = cols.length;
    for (int i = 0; i < uLen; i++) {
      List<dynamic>? nameRecs = getUnitByName(unitsList[i]);
      if (nameRecs != null) {
        int nameRecsLen = nameRecs.length;
        for (int u = 0; u < nameRecsLen; u++) {
          Map<String, dynamic> rec = nameRecs[u];
          for (int c = 0; c < cLen; c++) {
            if (c > 0) {
              unitBuff += sep;
            }
            if (cols[c] == 'dim_') {
              if (rec['dim_'] != null &&
                  rec['dim_'].getProperty('dimVec_') is List<dynamic>) {
                unitBuff +=
                    '[${rec['dim_'].getProperty('dimVec_')!.join(',')}]';
              } else {
                unitBuff += '';
              }
            } else {
              dynamic cbuf = rec[cols[c]];
              if (cbuf is String) {
                unitBuff += cbuf.replaceAll(RegExp(r'[\n\r]'), ' ');
              } else {
                unitBuff += cbuf.toString();
              }
            }
          }
          unitBuff += '\r\n';
        }
      }
    }
    return unitBuff;
  }

  String printUnits(bool? doLong, [String sep = '|']) {
    if (doLong == null) {
      doLong = false;
    }
    if (sep.isEmpty) {
      sep = '|';
    }
    var codeList = '';
    var uLen = codeOrder_.length;
    var unitString = 'csCode$sep';
    if (doLong) {
      unitString += 'ciCode$sep';
    }
    unitString += 'name$sep';
    if (doLong) {
      unitString += 'isBase$sep';
    }
    unitString += 'magnitude$sep' +
        'dimension$sep' +
        'from unit(s)$sep' +
        'value$sep' +
        'function$sep';
    if (doLong) {
      unitString += 'property$sep' +
          'printSymbol$sep' +
          'synonyms$sep' +
          'source$sep' +
          'class$sep' +
          'isMetric$sep' +
          'variable$sep' +
          'isSpecial$sep' +
          'isAbitrary$sep';
    }
    unitString += 'comment';
    codeList = unitString + '\n';

    for (var u = 0; u < uLen; u++) {
      var curUnit = getUnitByCode(codeOrder_[u]);
      unitString = codeOrder_[u] + sep;
      if (doLong) {
        unitString += curUnit.getProperty('ciCode_') + sep;
      }
      unitString += curUnit.getProperty('name_') + sep;
      if (doLong) {
        if (curUnit.getProperty('isBase_')) {
          unitString += 'true' + sep;
        } else {
          unitString += 'false' + sep;
        }
      }
      unitString += curUnit.getProperty('magnitude_') + sep;
      var curDim = curUnit.getProperty('dim_');
      if (curDim != null) {
        unitString += curDim.dimVec_ + sep;
      } else {
        unitString += 'null' + sep;
      }
      if (curUnit.csUnitString_ != null) {
        unitString += curUnit.csUnitString_ + sep + curUnit.baseFactor_ + sep;
      } else {
        unitString += 'null' + sep + 'null' + sep;
      }

      if (curUnit.cnv_ != null) {
        unitString += curUnit.cnv_ + sep;
      } else {
        unitString += 'null' + sep;
      }

      if (doLong) {
        unitString += curUnit.getProperty('property_') +
            sep +
            curUnit.getProperty('printSymbol_') +
            sep +
            curUnit.getProperty('synonyms_') +
            sep +
            curUnit.getProperty('source_') +
            sep +
            curUnit.getProperty('class_') +
            sep +
            curUnit.getProperty('isMetric_') +
            sep +
            curUnit.getProperty('variable_') +
            sep +
            curUnit.getProperty('isSpecial_') +
            sep +
            curUnit.getProperty('isArbitrary_') +
            sep;
      }
      if (curUnit.defError_) {
        unitString += 'problem parsing this one, deferred to later.';
      }
      codeList += unitString + '\n';
    }
    return codeList;
  }
}

// Provide access to the singleton instance via a getter method
class UnitTables {
  static final UnitTablesFactory _instance = UnitTablesFactory();

  static UnitTablesFactory getInstance() {
    return _instance;
  }
}

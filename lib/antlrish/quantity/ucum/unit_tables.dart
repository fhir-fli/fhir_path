import 'ucum_pkg.dart';

class UnitTables {
  // Declare the attributes
  Map<String, List<UcumUnit>> unitNames = {};
  Map<String, UcumUnit> unitCodes = {};
  List<String> codeOrder = [];
  Map<String, List<Map<String, dynamic>>> unitStrings = {};
  Map<String, List<UcumUnit>> unitDimensions = {};
  Map<String, List<String>> unitSynonyms = {};
  int massDimIndex = 0;
  Map<int, String> dimVecIndexToBaseUnit_ = {};

  static UnitTables get instance => _instance;

  static final UnitTables _instance = UnitTables._();

  UnitTables._();

  void addUnit(UcumUnit theUnit) {
    addUnitName(theUnit);
    addUnitCode(theUnit);
    addUnitString(theUnit);

    try {
      final dimVec = theUnit.dim_?.dimVec_;
      if (dimVec != null) {
        addUnitDimension(theUnit);
      }
    } catch (e) {
      // do nothing - throws error if the property is null
      // and that's OK here.
    }

    if (theUnit.isBase_) {
      final dimVec = theUnit.dim_?.dimVec_;
      int? nonZeroIndex;
      for (var i = 0; nonZeroIndex == null && i < (dimVec?.length ?? 0); ++i) {
        if (dimVec?[i] != 0) {
          nonZeroIndex = i;
        }
      }
      if (nonZeroIndex != null) {
        dimVecIndexToBaseUnit_[nonZeroIndex] = theUnit.csCode_;
      }
    }
  }

  int unitsCount() => unitCodes.length;

  void addUnitName(UcumUnit theUnit) {
    final String uName = theUnit.name_;
    unitNames[uName] = (unitNames[uName] ?? [])..add(theUnit);
  }

  void addUnitCode(UcumUnit theUnit) {
    final String uCode = theUnit.csCode_;
    if (unitCodes.containsKey(uCode)) {
      throw Exception('Unit with code $uCode already exists');
    }
    unitCodes[uCode] = theUnit;
    codeOrder.add(uCode);
    if (uCode == 'g') {
      var dimVec = theUnit.dim_?.dimVec_;
      massDimIndex = dimVec?.indexWhere((x) => x != 0) ?? 0;
    }
  }

  void addUnitString(UcumUnit theUnit) {
    var uString = theUnit.ciUnitString_;
    if (uString != null) {
      var uEntry = {'magn': theUnit.baseFactorStr_, 'unit': theUnit};
      unitStrings[uString] = (unitStrings[uString] ?? [])..add(uEntry);
    }
  }

  void addUnitDimension(UcumUnit theUnit) {
    var uDim = theUnit.dim_?.dimVec_;
    if (uDim != null) {
      unitDimensions[uDim] = (unitDimensions[uDim] ?? [])..add(theUnit);
    }
  }

  void buildUnitSynonyms() {
    unitCodes.forEach((code, theUnit) {
      var uSyns = theUnit.synonyms_;
      // Process synonyms and names
    });
  }

  void addSynonymCodes(String theCode, String theSynonyms) {
    var words = theSynonyms.split(' ');
    for (var word in words) {
      unitSynonyms[word] = (unitSynonyms[word] ?? [])..add(theCode);
    }
  }

  dynamic getUnitByCode(String uCode) {
    print('keys: ${unitCodes.keys}');
    return unitCodes[uCode];
  }

  List<dynamic> getUnitByName(String uName) {
    // Process to return unit by name
    return [];
  }

  List<Map<String, dynamic>>? getUnitByString(String uString) {
    return unitStrings[uString];
  }

  List<UcumUnit>? getUnitsByDimension(String uDim) {
    return unitDimensions[uDim];
  }

  Map<String, dynamic> getUnitBySynonym(String? uSyn) {
    Map<String, dynamic> retObj = {};
    List<UcumUnit> unitsArray = [];

    try {
      if (uSyn == null || uSyn.isEmpty) {
        retObj['status'] = 'error';
        throw ('Unable to find unit by synonym because no synonym '
            'was provided.');
      }

      // If this is the first request for a unit by synonym, build the hash map
      if (unitSynonyms.isEmpty) {
        buildUnitSynonyms();
      }

      List<String>? foundCodes = unitSynonyms[uSyn];

      if (foundCodes != null) {
        retObj['status'] = 'succeeded';
        for (var code in foundCodes) {
          if (unitCodes[code] != null) {
            unitsArray.add(unitCodes[code]!);
          }
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
    return unitNames.keys.toList();
  }

  List<String> getUnitNamesList() {
    List<String> nameList = [];
    List<String> codes = unitCodes.keys.toList();
    codes.sort(compareCodes);
    for (String code in codes) {
      nameList.add(code + UcumConfig.codeSep_ + (unitCodes[code]?.name_ ?? ''));
    }
    return nameList;
  }

  int getMassDimensionIndex() {
    return massDimIndex;
  }

  int compareCodes(String a, String b) {
    a = a.replaceAll(RegExp(r'[\[\]]'), '').toLowerCase();
    b = b.replaceAll(RegExp(r'[\[\]]'), '').toLowerCase();
    return a.compareTo(b);
  }

  List<String> getAllUnitCodes() {
    return unitCodes.keys.toList();
  }

  List<dynamic> allUnitsByDef() {
    List<dynamic> unitsList = [];
    for (String code in codeOrder) {
      unitsList.add(unitCodes[code]);
    }
    return unitsList;
  }

  String allUnitsByName(List<String> cols, [String sep = '|']) {
    StringBuffer unitBuff = StringBuffer();
    for (String unitName in unitNames.keys) {
      List<UcumUnit>? nameRecs = unitNames[unitName];
      for (UcumUnit rec in nameRecs ?? <UcumUnit>[]) {
        for (String col in cols) {
          if (col == 'dim_') {
            if (rec.dim_ != null && rec.dim_?.dimVec_ is List) {
              unitBuff
                  .write('[' + (rec.dim_?.dimVec_?.join(',') ?? '') + ']$sep');
            } else {
              unitBuff.write('$sep');
            }
          } else {
            var buf = rec.fieldByString(col);
            if (buf is String) {
              unitBuff.write(buf.replaceAll(RegExp(r'[\n\r]'), ' ') + sep);
            } else {
              unitBuff.write(buf.toString() + sep);
            }
          }
        }
        unitBuff.writeln();
      }
    }
    return unitBuff.toString();
  }

  String printUnits(bool doLong, [String sep = '|']) {
    StringBuffer codeList = StringBuffer();
    String unitString = 'csCode$sep';
    if (doLong) {
      unitString += 'ciCode$sep';
    }
    unitString += 'name$sep';
    if (doLong) {
      unitString += 'isBase$sep';
    }
    unitString += 'magnitude$sep';
    unitString += 'dimension$sep';
    unitString += 'from unit(s)$sep';
    unitString += 'value$sep';
    unitString += 'function$sep';
    if (doLong) {
      unitString += 'property$sep';
      unitString += 'printSymbol$sep';
      unitString += 'synonyms$sep';
      unitString += 'source$sep';
      unitString += 'class$sep';
      unitString += 'isMetric$sep';
      unitString += 'variable$sep';
      unitString += 'isSpecial$sep';
      unitString += 'isArbitrary$sep';
    }
    unitString += 'comment';
    codeList.writeln(unitString);

    for (String code in codeOrder) {
      dynamic curUnit = unitCodes[code];
      unitString = '$code$sep';
      if (doLong) {
        unitString += '${curUnit.getProperty("ciCode_")}$sep';
      }
      unitString += '${curUnit.getProperty("name_")}$sep';
      if (doLong) {
        unitString += (curUnit.getProperty('isBase_') ? 'true' : 'false') + sep;
      }
      unitString += '${curUnit.getProperty("magnitude_")}$sep';
      dynamic curDim = curUnit.getProperty('dim_');
      if (curDim != null) {
        unitString += '${curDim.dimVec_}$sep';
      } else {
        unitString += 'null$sep';
      }
      if (curUnit.csUnitString_ != null) {
        unitString += '${curUnit.csUnitString_}$sep${curUnit.baseFactor_}$sep';
      } else {
        unitString += 'null${sep}null${sep}';
      }
      if (curUnit.cnv_ != null) {
        unitString += '${curUnit.cnv_}$sep';
      } else {
        unitString += 'null$sep';
      }
      if (doLong) {
        unitString += '${curUnit.getProperty("property_")}$sep';
        unitString += '${curUnit.getProperty("printSymbol_")}$sep';
        unitString += '${curUnit.getProperty("synonyms_")}$sep';
        unitString += '${curUnit.getProperty("source_")}$sep';
        unitString += '${curUnit.getProperty("class_")}$sep';
        unitString += '${curUnit.getProperty("isMetric_")}$sep';
        unitString += '${curUnit.getProperty("variable_")}$sep';
        unitString += '${curUnit.getProperty("isSpecial_")}$sep';
        unitString += '${curUnit.getProperty("isArbitrary_")}$sep';
      }
      if (curUnit.defError_ != null) {
        unitString += 'problem parsing this one, deferred to later.';
      }
      codeList.writeln(unitString);
    }
    return codeList.toString();
  }

  // Method to add a unit object to the unitSynonyms map
  void addUnitSynonym(String synonym, dynamic theUnit) {
    if (!unitSynonyms.containsKey(synonym)) {
      unitSynonyms[synonym] = [];
    }
    unitSynonyms[synonym]!.add(theUnit);
  }

  // Method to get a list of all synonyms in the unit tables
  List<String> getAllSynonyms() => unitSynonyms.keys.toList();

  // Method to get a list of all units with a particular synonym
  List<dynamic> getUnitsBySynonym(String synonym) =>
      unitSynonyms[synonym] ?? [];

  // Method to get a list of all unit dimensions in the unit tables
  List<String> getAllUnitDimensions() => unitDimensions.keys.toList();

  // Method to add a unit to the mass dimension index
  void addToMassDimensionIndex(dynamic theUnit) {
    if (theUnit.isBase_ && theUnit.dim_ != null) {
      massDimIndex = theUnit.dim_.dimVec_.indexOf(1);
    }
  }

  // Method to retrieve the base unit symbol for a given dimension index
  String getBaseUnitSymbolForDimIndex(int index) {
    return dimVecIndexToBaseUnit[index] ?? '';
  }

  // Method to check if a unit code exists
  bool hasUnitCode(String code) {
    return unitCodes.containsKey(code);
  }

  // Method to check if a unit name exists
  bool hasUnitName(String name) {
    return unitNames.containsKey(name);
  }

  // Method to check if a unit string exists
  bool hasUnitString(String unitString) {
    return unitStrings.containsKey(unitString);
  }

  // Method to check if a unit synonym exists
  bool hasUnitSynonym(String synonym) {
    return unitSynonyms.containsKey(synonym);
  }

  // Method to check if a unit dimension exists
  bool hasUnitDimension(String dimension) {
    return unitDimensions.containsKey(dimension);
  }

  // Method to get the index of a unit code in the definition order
  int getUnitCodeIndex(String code) {
    return codeOrder.indexOf(code);
  }

  // Method to get the unit object at a specific index in the definition order
  dynamic getUnitAtIndex(int index) {
    if (index < 0 || index >= codeOrder.length) {
      return null;
    }
    return unitCodes[codeOrder[index]];
  }
}

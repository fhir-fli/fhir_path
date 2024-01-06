import 'ucum_pkg.dart';

class UnitTables {
  /// Tracks units by name, key is the name;
  /// value is an array of references to the Unit objects
  /// with the name.  More than one unit may have the same
  /// name, e.g., "second", which is shared by the base unit
  /// with the code = "s" and the unit with code = "'".
  /// {UcumUnit.name_: <UcumUnit>[]}
  // {'second': [UcumUnit('s'), UcumUnit('second')]}
  final Map<String, List<UcumUnit>> unitNames_ = {};

  /// Tracks units by code using case-sensitive version, key is the code.
  /// value is the reference to the Unit object.  Codes must be unique.
  /// {UcumUnit.csCode_: UcumUnit()}
  final Map<String, UcumUnit> unitCodes_ = {};

  /// Keeps track of the order in which units are defined.  The order is
  /// important because unit definitions build on previous definitions.
  final List<String> codeOrder_ = [];

  /// Tracks units by unit strings, e.g., cm-1
  /// key is the unit string
  /// value is an array of unit objects with that ciUnitString (vs csUnitString
  /// - the case sensitive version).
  /// {"ciUnitString_": <_UnitEntry>[]}
  final Map<String, List<UnitEntry>> unitStrings_ = {};

  /// Tracks units by Dimension vector
  /// key is the dimension vector (not the object, just the vector);
  /// value is an array of references to the Unit objects with that vector.
  /// More than one unit may have the same unit vector, and this can be
  /// used to provide a list of commensurable units.
  /// {[1, 0, 0, 0, 0, 0, 0]: <UcumUnit>[]}
  final Map<List<int>, List<UcumUnit>> unitDimensions_ = {};

  /// Maps synonyms to units. Not built until first requested. Key is the synonym
  /// value is an array of references to Unit objects that include that synonym.
  //  {UcumUnit.synonyms_: <UcumUnit.csCode_>[]}
  final Map<String, List<String>> unitSynonyms_ = {};

  /// Holds onto the index of the index of the dimension vector flag for the
  /// base mass unit (gram). This is set when the base unit (gram) is created,
  /// and is stored here so that it doesn't have to be found over and over
  /// again to try to determine whether or not a unit is mass-based
  /// (for mole<->mass conversions)
  int massDimIndex_ = 0;

  /// Map of indices in the dimension vector to base unit symbols.
  final Map<int, String> dimVecIndexToBaseUnit_ = {};

  static UnitTables get instance => _instance;

  static UnitTables _instance = UnitTables._();

  UnitTables._();

  int unitsCount() => unitCodes_.length;

  /// Adds a Unit object to the tables.
  /// theUnit the unit to be added
  /// catches and doesn't react if there's aa problem with the unit code or
  /// unit name
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
      final List<int>? dimVec = theUnit.dim_?.dimVec_;
      int? nonZeroIndex;
      if (dimVec != null) {
        for (var i = 0; nonZeroIndex == null && i < dimVec.length; ++i) {
          if (dimVec[i] != 0) {
            nonZeroIndex = i;
          }
        }
      }
      if (nonZeroIndex != null) {
        dimVecIndexToBaseUnit_[nonZeroIndex] = theUnit.csCode_;
      }
    }
  }

  /// Adds a Unit object to the unitNames_ table.  More than one unit
  /// can have the same name, e.g., the two units with the name "second",
  /// where the code for one of them is 's' and the code for the other is
  /// "'".  Because of this, an array of unit objects is stored for the
  /// name.  In most cases it will be an array of one object, but this
  /// clarifies that there may be more than one.
  void addUnitName(UcumUnit theUnit) {
    final String uName = theUnit.name_;
    unitNames_[uName] = (unitNames_[uName] ?? [])..add(theUnit);
  }

  /// Adds a Unit object to the unitCodes_, unitUcCodes_, unitLcCodes_ and
  /// codeOrder_ tables.  This also sets the mass dimension index when the
  /// base mass unit (gram) is read.
  void addUnitCode(UcumUnit theUnit) {
    final String uCode = theUnit.csCode_;
    if (unitCodes_.containsKey(uCode)) {
      throw Exception('Unit with code $uCode already exists');
    } else {
      unitCodes_[uCode] = theUnit;
      codeOrder_.add(uCode);
      if (uCode == 'g') {
        final List<int>? dimVec = theUnit.dim_?.dimVec_;
        massDimIndex_ = dimVec?.indexWhere((x) => x != 0) ?? 0;
      }
    }
  }

  /// Adds a unit object to the unitStrings__ table.  More than one unit
  /// can have the same string, so an array of unit objects is stored
  /// for the string.  The unit string is the string that creates a non-base
  /// unit, e.g., a Newton has a unit code of N, a name of Newton, and a
  /// unitString of kg.m/s2.
  /// If the unit has no string, nothing is stored and no error is reported.
  void addUnitString(UcumUnit theUnit) {
    final String? uString = UcumConfig.caseSensitive_
        ? theUnit.csUnitString_
        : theUnit.ciUnitString_;
    if (uString != null) {
      unitStrings_[uString] = (unitStrings_[uString] ?? <UnitEntry>[])
        ..add(UnitEntry(theUnit.baseFactorStr_, theUnit));
    }
  }

  /// Adds a Unit object to the unitDimensions_ table.  More than one unit
  /// can have the same dimension (commensurable units have the same dimension).
  /// Because of this, an array of unit objects is stored for the
  /// dimension.
  void addUnitDimension(UcumUnit theUnit) {
    final List<int>? uDim = theUnit.dim_?.dimVec_;
    if (uDim != null) {
      unitDimensions_[uDim] = (unitDimensions_[uDim] ?? [])..add(theUnit);
    } else {
      throw (new Exception(
          'UnitTables.addUnitDimension called for a unit with no dimension.  '
          "Unit code = ${theUnit.csCode_}."));
    }
  }

  /// Builds the unitSynonyms_ table. This is called the first time the
  /// getUnitsBySynonym method is called.  The table/hash contains each word
  /// (once) from each synonym as well as each word from each unit name.
  ///
  /// Hash keys are the words.  Hash values are an array of unit codes for
  /// each unit that has that word in its synonyms or name.
  void buildUnitSynonyms() {
    for (final String code in unitCodes_.keys) {
      final UcumUnit? theUnit = unitCodes_[code];
      final String? uSyns = theUnit?.synonyms_;

      // If the current unit has synonyms, process each synonym (often multiples)
      if (uSyns != null) {
        final List<String> synsAry = uSyns.split(';');
        if (synsAry.first != '') {
          for (final syn in synsAry) {
            final String theSyn = syn.trim();
            // Call addSynonymCodes to process each word in the
            // synonym, e.g., "British fluid ounces"
            addSynonymCodes(code, theSyn);
          }
        }
      }
      if (theUnit != null) {
        // Now call addSynonymCodes to process each word in the unit's name
        addSynonymCodes(code, theUnit.name_);
      }
    }
  }

  /// Adds unit code entries to the synonyms table for a string containing
  /// one or more words to be considered as synonyms.
  void addSynonymCodes(String theCode, String theSynonyms) {
    final List<String> words = theSynonyms.split(' ');
    for (final word in words) {
      unitSynonyms_[word] = (unitSynonyms_[word] ?? [])..add(theCode);
    }
  }

  /// Returns a unit object with a case-sensitive code matching the
  /// uCode parameter, or null if no unit is found with that code.
  UcumUnit? getUnitByCode(String uCode) => unitCodes_[uCode];

  /// Returns a array of unit objects based on the unit's name.  Usually this
  /// will be an array of one, but there may be more, since unit names are
  /// not necessarily unique.
  List<UcumUnit> getUnitByName(String? uName) {
    if (uName == null) {
      throw Exception(
          'Unable to find unit by name because no name was provided.');
    } else {
      final int sepPos = uName.indexOf(UcumConfig.codeSep_);
      String? uCode = null;
      if (sepPos >= 1) {
        uCode = uName.substring(sepPos + UcumConfig.codeSep_.length);
        uName = uName.substring(0, sepPos);
      }
      List<UcumUnit>? retUnits = unitNames_[uName];
      if (retUnits != null) {
        final int uLen = retUnits.length;
        if (uCode != null && uLen > 1) {
          for (var i = 0; i < uLen && retUnits![i].csCode_ != uCode; i++) {
            if (i < uLen) {
              retUnits = [retUnits[i]];
            } else {
              retUnits = null;
            }
          }
        }
      }
      return retUnits ?? <UcumUnit>[];
    }
  }

  /// Returns an array of unit objects with the specified unit string.
  /// The array may contain one or more unit reference objects.
  /// Or none, if no units have a matching unit string (which is not
  /// considered an error)
  List<UnitEntry> getUnitByString(String uString) =>
      unitStrings_[uString] ?? <UnitEntry>[];

  /// Returns a array of unit objects based on the unit's dimension vector.
  List<UcumUnit> getUnitsByDimension(List<int> uDim) =>
      unitDimensions_[uDim] ?? <UcumUnit>[];

  /// Returns a array of unit objects that include the specified synonym.
  ReturnObject getUnitBySynonym(String? uSyn) {
    ReturnObject retObj = ReturnObject(status: ReturnStatus.failed);
    List<UcumUnit> unitsArray = [];
    try {
      if (uSyn == null || uSyn.isEmpty) {
        retObj = retObj.copyWith(status: ReturnStatus.error);
        throw ('Unable to find unit by synonym because no synonym '
            'was provided.');
      }
      // If this is the first request for a unit by synonym, build the hash map
      if (unitSynonyms_.isEmpty) {
        buildUnitSynonyms();
      }
      List<String>? foundCodes = unitSynonyms_[uSyn];
      if (foundCodes != null) {
        retObj = retObj.copyWith(status: ReturnStatus.succeeded);
        for (var code in foundCodes) {
          if (unitCodes_[code] != null) {
            unitsArray.add(unitCodes_[code]!);
          }
        }
        retObj.copyWith(units: unitsArray);
      }
      if (unitsArray.isEmpty) {
        retObj = retObj.copyWith(status: ReturnStatus.failed, msg: [
          if (retObj.msg != null && retObj.msg!.isNotEmpty) ...retObj.msg!,
          'Unable to find any units with synonym = $uSyn'
        ]);
      }
    } catch (err) {
      retObj = retObj.copyWith(status: ReturnStatus.error, msg: [
        if (retObj.msg != null && retObj.msg!.isNotEmpty) ...retObj.msg!,
        err.toString()
      ]);
    }
    return retObj;
  }

  /// Gets a list of all unit names in the Unit tables
  List<String> getAllUnitNames() => unitNames_.keys.toList();

  /// Gets a list of all unit names in the tables.  Where more than one
  /// unit has the same name, the unit code, in parentheses, is appended
  /// to the end of the name.
  List<String> getUnitNamesList() {
    List<String> nameList = <String>[];
    List<String> codes = unitCodes_.keys.toList();
    codes.sort(compareCodes);
    for (String code in codes) {
      nameList
          .add(code + UcumConfig.codeSep_ + (unitCodes_[code]?.name_ ?? ''));
    }
    return nameList;
  }

  /// Returns the mass dimension index
  int getMassDimensionIndex() => massDimIndex_;

  /// This provides a sort function for unit codes so that sorting ignores
  /// square brackets and case.
  int compareCodes(String a, String b) {
    a = a.replaceAll(RegExp(r'[\[\]]'), '').toLowerCase();
    b = b.replaceAll(RegExp(r'[\[\]]'), '').toLowerCase();
    return a.compareTo(b);
  }

  /// Gets a list of all unit codes in the Unit tables
  List<String> getAllUnitCodes() => unitCodes_.keys.toList();

  /// This is used to get all unit objects.  Currently it is used
  /// to get the objects to write to the json ucum definitions file
  /// that is used to provide prefix and unit definition objects for
  /// conversions and validations.
  List<UcumUnit> allUnitsByDef() {
    final List<UcumUnit> units = <UcumUnit>[];
    for (final String code in codeOrder_) {
      if (unitCodes_[code] != null) {
        units.add(unitCodes_[code]!);
      }
    }
    return units;
  }

  /// This is used to get all unit objects, ordered by unit name.  Currently it
  /// is used to create a csv list of all units.
  String allUnitsByName(List<String> cols, [String sep = '|']) {
    StringBuffer unitBuff = StringBuffer();
    for (String unitName in unitNames_.keys) {
      List<UcumUnit>? nameRecs = unitNames_[unitName];
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

  /// This creates a list of all units in the tables.  It uses the byCode
  /// table, and uses the codeOrder_ array to determine the order in which
  /// the units are listed.
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

    for (String code in codeOrder_) {
      dynamic curUnit = unitCodes_[code];
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

  // Method to get a list of all synonyms in the unit tables
  List<String> getAllSynonyms() => unitSynonyms_.keys.toList();

  // Method to get a list of all units with a particular synonym
  List<dynamic> getUnitsBySynonym(String synonym) =>
      unitSynonyms_[synonym] ?? [];

  // Method to add a unit to the mass dimension index
  void addToMassDimensionIndex(dynamic theUnit) {
    if (theUnit.isBase_ && theUnit.dim_ != null) {
      massDimIndex_ = theUnit.dim_.dimVec_.indexOf(1);
    }
  }

  // Method to check if a unit code exists
  bool hasUnitCode(String code) => unitCodes_.containsKey(code);

  // Method to check if a unit name exists
  bool hasUnitName(String name) => unitNames_.containsKey(name);

  // Method to check if a unit string exists
  bool hasUnitString(String unitString) => unitStrings_.containsKey(unitString);

  // Method to check if a unit synonym exists
  bool hasUnitSynonym(String synonym) {
    return unitSynonyms_.containsKey(synonym);
  }

  // Method to check if a unit dimension exists
  bool hasUnitDimension(String dimension) =>
      unitDimensions_.containsKey(dimension);

  // Method to get the index of a unit code in the definition order
  int getUnitCodeIndex(String code) => codeOrder_.indexOf(code);

  // Method to get the unit object at a specific index in the definition order
  dynamic getUnitAtIndex(int index) {
    if (index < 0 || index >= codeOrder_.length) {
      return null;
    }
    return unitCodes_[codeOrder_[index]];
  }
}

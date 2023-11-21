import 'ucum.dart';

class Unit {
  late bool isBase_;
  late String name_;
  late String csCode_;
  late String ciCode_;
  late String property_;
  late num magnitude_;
  late Dimension dim_;
  late String? printSymbol_;
  late String? class_;
  late bool isMetric_;
  late String? variable_;
  late dynamic cnv_;
  late num cnvPfx_;
  late bool isSpecial_;
  late bool isArbitrary_;
  late int moleExp_;
  late dynamic synonyms_;
  late dynamic source_;
  late dynamic loincProperty_;
  late dynamic category_;
  late dynamic guidance_;
  late String? csUnitString_;
  late String? ciUnitString_;
  late String? baseFactorStr_;
  late num? baseFactor_;
  late bool defError_;

  Unit({Map<String, dynamic> attrs = const {}}) {
    isBase_ = attrs['isBase_'] ?? false;
    name_ = attrs['name_'] ?? '';
    csCode_ = attrs['csCode_'] ?? '';
    ciCode_ = attrs['ciCode_'] ?? '';
    property_ = attrs['property_'] ?? '';
    magnitude_ = attrs['magnitude_'] ?? 1;

    if (attrs['dim_'] == null || attrs['dim_'] == null) {
      dim_ = Dimension();
    } else if (attrs['dim_']['dimVec_'] != null) {
      dim_ = Dimension(attrs['dim_']['dimVec_']);
    } else if (attrs['dim_'] is Dimension) {
      dim_ = attrs['dim_'];
    } else if (attrs['dim_'] is List || intUtils.isInteger(attrs['dim_'])) {
      dim_ = Dimension(attrs['dim_']);
    } else {
      dim_ = Dimension();
    }

    printSymbol_ = attrs['printSymbol_'];
    class_ = attrs['class_'];
    isMetric_ = attrs['isMetric_'] ?? false;
    variable_ = attrs['variable_'];
    cnv_ = attrs['cnv_'];
    cnvPfx_ = attrs['cnvPfx_'] ?? 1;
    isSpecial_ = attrs['isSpecial_'] ?? false;
    isArbitrary_ = attrs['isArbitrary_'] ?? false;
    moleExp_ = attrs['moleExp_'] ?? 0;
    synonyms_ = attrs['synonyms_'];
    source_ = attrs['source_'];
    loincProperty_ = attrs['loincProperty_'];
    category_ = attrs['category_'];
    guidance_ = attrs['guidance_'];
    csUnitString_ = attrs['csUnitString_'];
    ciUnitString_ = attrs['ciUnitString_'];
    baseFactorStr_ = attrs['baseFactorStr_'];
    baseFactor_ = attrs['baseFactor_'];
    defError_ = attrs['defError_'] ?? false;
  }

  Unit assignUnity() {
    name_ = "";
    magnitude_ = 1;
    if (dim_ == null) dim_ = Dimension()..assignZero();
    cnv_ = null;
    cnvPfx_ = 1;
    return this;
  }

  void assignVals(Map<String, dynamic> vals) {
    vals.forEach((key, value) {
      final uKey = key.endsWith('_') ? key : '${key}_';
      if (this.containsKey(uKey)) {
        this[uKey] = value;
      } else {
        throw Exception('Parameter error; $key is not a property of a Unit');
      }
    });
  }

  Unit clone() {
    final retUnit = Unit();
    this.forEach((key, value) {
      if (key == 'dim_') {
        if (this['dim_'] != null) {
          retUnit['dim_'] = this['dim_']!.clone();
        } else {
          retUnit['dim_'] = null;
        }
      } else {
        retUnit[key] = value;
      }
    });
    return retUnit;
  }

  void assign(Unit unit2) {
    unit2.forEach((key, value) {
      if (key == 'dim_') {
        if (unit2['dim_'] != null) {
          this['dim_'] = unit2['dim_']!.clone();
        } else {
          this['dim_'] = null;
        }
      } else {
        this[key] = value;
      }
    });
  }

  bool equals(Unit unit2) {
    return (magnitude_ == unit2.magnitude_ &&
        cnv_ == unit2.cnv_ &&
        cnvPfx_ == unit2.cnvPfx_ &&
        ((dim_ == null && unit2.dim_ == null) || dim_.equals(unit2.dim_)));
  }

  bool fullEquals(Unit unit2) {
    final thisAttr = keys.toList()..sort();
    final u2Attr = unit2.keys.toList()..sort();

    final keyLen = thisAttr.length;
    var match = (keyLen == u2Attr.length);

    for (var k = 0; k < keyLen && match; k++) {
      if (thisAttr[k] == u2Attr[k]) {
        if (thisAttr[k] == 'dim_') {
          match = dim_.equals(unit2.dim_);
        } else {
          match = this[thisAttr[k]] == unit2[thisAttr[k]];
        }
      } else {
        match = false;
      }
    }
    return match;
  }

  dynamic getProperty(String propertyName) {
    final uProp = propertyName.endsWith('_') ? propertyName : '$propertyName_';
    return this[uProp];
  }

  double convertFrom(double num, Unit fromUnit) {
    var newNum = 0.0;

    if (this.isArbitrary_)
      throw (Exception(
          'Attempt to convert to arbitrary unit "${this.csCode_}"'));
    if (fromUnit.isArbitrary_)
      throw (Exception(
          'Attempt to convert arbitrary unit "${fromUnit.csCode_}"'));

    // Additional code logic here for conversion...

    return newNum;
  }

  dynamic getProperty(String propertyName) {
    String uProp = propertyName[propertyName.length - 1] == '_'
        ? propertyName
        : propertyName + '_';
    return this[uProp];
  }

  double convertTo(double num, dynamic toUnit) {
    return toUnit.convertFrom(num, this);
  }

  double convertCoherent(double num) {
    if (this.cnv_ != null)
      num = this.cnv_.f_from(num / this.cnvPfx_) * this.magnitude_;

    return num;
  }

  double mutateCoherent(double num) {
    num = this.convertCoherent(num);

    this.magnitude_ = 1;
    this.cnv_ = null;
    this.cnvPfx_ = 1;
    this.name_ = "";

    for (int i = 0, max = Dimension.getMax(); i < max; i++) {
      dynamic elem = this.dim_.getElementAt(i);
      dynamic tabs = this._getUnitTables();
      dynamic uA = tabs.getUnitsByDimension(new Dimension(i));
      if (uA == null)
        throw (new Error('Can\'t find base unit for dimension $i'));
      this.name_ = uA.name + elem;
    }
    return num;
  }

  double convertMassToMol(double amt, dynamic molUnit, double molecularWeight) {
    double molAmt = (this.magnitude_ * amt) / molecularWeight;
    dynamic tabs = this._getUnitTables();
    double avoNum = tabs.getUnitByCode('mol').magnitude_;
    double molesFactor = molUnit.magnitude_ / avoNum;
    return molAmt / molesFactor;
  }

  double convertMolToMass(
      double amt, dynamic massUnit, double molecularWeight) {
    dynamic tabs = this._getUnitTables();
    double avoNum = tabs.getUnitByCode('mol').magnitude_;
    double molesFactor = this.magnitude_ / avoNum;
    double massAmt = (molesFactor * amt) * molecularWeight;
    return massAmt / massUnit.magnitude_;
  }

  double mutateRatio(double num) {
    if (this.cnv_ == null)
      return this.mutateCoherent(num);
    else
      return num;
  }

  dynamic multiplyThis(s) {
    var retUnit = this.clone();
    if (retUnit.cnv_ != null)
      retUnit.cnvPfx_ *= s;
    else
      retUnit.magnitude_ *= s;
    var mulVal = s.toString();
    retUnit.name_ = this._concatStrs(mulVal, '*', this.name_, '[', ']');
    retUnit.csCode_ = this._concatStrs(mulVal, '.', this.csCode_, '(', ')');
    retUnit.ciCode_ = this._concatStrs(mulVal, '.', this.ciCode_, '(', ')');
    retUnit.printSymbol_ =
        this._concatStrs(mulVal, '.', this.printSymbol_, '(', ')');
    return retUnit;
  }

  dynamic multiplyThese(unit2) {
    var retUnit = this.clone();

    if (retUnit.cnv_ != null) {
      if (unit2.cnv_ == null && (!unit2.dim_ || unit2.dim_.isZero()))
        retUnit.cnvPfx_ *= unit2.magnitude_;
      else
        throw (new Error(
            'Attempt to multiply non-ratio unit ${retUnit.name_} failed.'));
    } else if (unit2.cnv_ != null) {
      if (!retUnit.dim_ || retUnit.dim_.isZero()) {
        retUnit.cnvPfx_ = unit2.cnvPfx_ * retUnit.magnitude_;
        retUnit.magnitude_ = unit2.magnitude_;
        retUnit.cnv_ = unit2.cnv_;
      } else
        throw (new Error('Attempt to multiply non-ratio unit ${unit2.name_}'));
    } else {
      retUnit.magnitude_ *= unit2.magnitude_;
    }

    if (!retUnit.dim_ || (retUnit.dim_ && !retUnit.dim_.dimVec_)) {
      if (unit2.dim_)
        retUnit.dim_ = unit2.dim_.clone();
      else
        retUnit.dim_ = unit2.dim_;
    } else if (unit2.dim_ && unit2.dim_ is Dimension) {
      retUnit.dim_.add(unit2.dim_);
    }

    retUnit.name_ = this._concatStrs(retUnit.name_, '*', unit2.name_, '[', ']');
    retUnit.csCode_ =
        this._concatStrs(retUnit.csCode_, '.', unit2.csCode_, '(', ')');
    if (retUnit.ciCode_ && unit2.ciCode_)
      retUnit.ciCode_ =
          this._concatStrs(retUnit.ciCode_, '.', unit2.ciCode_, '(', ')');
    else if (unit2.ciCode_) retUnit.ciCode_ = unit2.ciCode_;
    retUnit.resetFieldsForDerivedUnit();
    if (retUnit.printSymbol_ && unit2.printSymbol_)
      retUnit.printSymbol_ = this
          ._concatStrs(retUnit.printSymbol_, '.', unit2.printSymbol_, '(', ')');
    else if (unit2.printSymbol_) retUnit.printSymbol_ = unit2.printSymbol_;
    retUnit.moleExp_ = retUnit.moleExp_ + unit2.moleExp_;
    if (!retUnit.isArbitrary_) retUnit.isArbitrary_ = unit2.isArbitrary_;
    if (!retUnit.isSpecial_) retUnit.isSpecial_ = unit2.isSpecial_;
    return retUnit;
  }

  void resetFieldsForDerivedUnit() {
    this.guidance_ = '';
    this.synonyms_ = null;
    this.isBase_ = false;
  }

  dynamic divide(unit2) {
    var retUnit = this.clone();

    if (retUnit.cnv_ != null)
      throw (new Error('Attempt to divide non-ratio unit ${retUnit.name_}'));
    if (unit2.cnv_ != null)
      throw (new Error('Attempt to divide by non-ratio unit ${unit2.name_}'));

    if (retUnit.name_ && unit2.name_)
      retUnit.name_ =
          this._concatStrs(retUnit.name_, '/', unit2.name_, '[', ']');
    else if (unit2.name_) retUnit.name_ = unit2.invertString(unit2.name_);

    retUnit.csCode_ =
        this._concatStrs(retUnit.csCode_, '/', unit2.csCode_, '(', ')');

    if (retUnit.ciCode_ && unit2.ciCode_)
      retUnit.ciCode_ =
          this._concatStrs(retUnit.ciCode_, '/', unit2.ciCode_, '(', ')');
    else if (unit2.ciCode_) retUnit.ciCode_ = unit2.invertString(unit2.ciCode_);

    retUnit.resetFieldsForDerivedUnit();

    retUnit.magnitude_ /= unit2.magnitude_;

    if (retUnit.printSymbol_ && unit2.printSymbol_)
      retUnit.printSymbol_ = this
          ._concatStrs(retUnit.printSymbol_, '/', unit2.printSymbol_, '(', ')');
    else if (unit2.printSymbol_)
      retUnit.printSymbol_ = unit2.invertString(unit2.printSymbol_);

    if (unit2.dim_) {
      if (retUnit.dim_) {
        if (retUnit.dim_.isNull()) retUnit.dim_.assignZero();
        retUnit.dim_ = retUnit.dim_.sub(unit2.dim_);
      } else
        retUnit.dim_ = unit2.dim_.clone().minus();
    }

    retUnit.moleExp_ = retUnit.moleExp_ - unit2.moleExp_;
    if (!retUnit.isArbitrary_) retUnit.isArbitrary_ = unit2.isArbitrary_;

    return retUnit;
  }

  dynamic invert() {
    if (this.cnv_ != null)
      throw (new Error('Attempt to invert a non-ratio unit - ${this.name_}'));

    this.name_ = this.invertString(this.name_);
    this.magnitude_ = 1 / this.magnitude_;
    this.dim_.minus();
    return this;
  }

  String invertString(String theString) {
    if (theString.length > 0) {
      String stringRep = theString
          .replaceAll('/', "!")
          .replaceAll('.', '/')
          .replaceAll("!", '.');
      switch (stringRep[0]) {
        case '.':
          theString = stringRep.substring(1);
          break;
        case '/':
          theString = stringRep;
          break;
        default:
          theString = "/" + stringRep;
      }
    }
    return theString;
  }

  String _concatStrs(String str1, String operator, String str2,
      String startChar, String endChar) {
    return _buildOneString(str1, startChar, endChar) +
        operator +
        _buildOneString(str2, startChar, endChar);
  }

  String _buildOneString(String str, String startChar, String endChar) {
    String ret = '';
    if (int.tryParse(str) != null) {
      ret = str;
    } else {
      if ((str.startsWith('(') && str.endsWith(')')) ||
          (str.startsWith('[') && str.endsWith(']'))) {
        ret = str;
      } else if (RegExp(r'[./* ]').hasMatch(str)) {
        ret = startChar + str + endChar;
      } else {
        ret = str;
      }
    }
    return ret;
  }

  dynamic power(dynamic p) {
    if (this.cnv_ != null) {
      throw (new Error(
          'Attempt to raise a non-ratio unit, ${this.name_}, to a power.'));
    }

    String uStr = this.csCode_;
    List<String> uArray = uStr.split(RegExp(r'[./]'));
    int arLen = uArray.length;

    for (int i = 0; i < arLen; i++) {
      String un = uArray[i];
      if (un != '/' && un != '.') {
        int? nun = int.tryParse(un);
        if (nun != null) {
          uArray[i] = (nun.pow(p)).toString();
        } else {
          int uLen = un.length;
          for (int u = uLen - 1; u >= 0; u--) {
            int? uChar = int.tryParse(un[u]);
            if (uChar == null) {
              if (un[u] == '-' || un[u] == '+') {
                u--;
              }
              if (u < uLen - 1) {
                int exp = int.parse(un.substring(u));
                exp = pow(exp, p).toInt();
                uArray[i] = un.substring(0, u) + exp.toString();
                u = -1;
              } else {
                uArray[i] += p.toString();
                u = -1;
              }
              u = -1;
            }
          }
        }
      }
    }

    this.csCode_ = uArray.join('');

    this.magnitude_ = pow(this.magnitude_, p);
    this.dim_.mul(p);
    return this;
  }

  bool isMoleMassCommensurable(dynamic unit2) {
    UnitTables tabs = _getUnitTables();
    int d = tabs.getMassDimensionIndex();
    bool commensurable = false;
    if (this.moleExp_ == 1 && unit2.moleExp_ == 0) {
      Dimension testDim = this.dim_.clone();
      int curVal = testDim.getElementAt(d);
      testDim.setElementAt(d, (curVal + this.moleExp_));
      commensurable = (testDim.equals(unit2.dim_));
    } else if (unit2.moleExp_ == 1 && this.moleExp_ == 0) {
      Dimension testDim = unit2.dim_.clone();
      int curVal = testDim.getElementAt(d);
      testDim.setElementAt(d, (curVal + unit2.moleExp_));
      commensurable = (testDim.equals(this.dim_));
    }
    return commensurable;
  }

  /**
   * This returns the UnitTables singleton object.  Including the require
   * statement included here causes a circular dependency condition that
   * resulted in the UnitTables object not being defined for the Unit object.
   * sigh.  Thanks, Paul, for figuring this out.
   *
   * @private
   */
  _getUnitTables() {
    return UnitTables.getInstance();
  }
}

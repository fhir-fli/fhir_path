import 'ucum_pkg.dart';

class UcumUnit {
  bool isBase_;
  String name_;
  String csCode_;
  String ciCode_;
  String property_;
  dynamic magnitude_;
  Dimension? dim_;
  String? printSymbol_;
  String? class_;
  bool isMetric_;
  String? variable_;
  String? cnv_;
  num cnvPfx_;
  bool isSpecial_;
  bool isArbitrary_;
  int moleExp_;
  String? synonyms_;
  String? source_;
  String? loincProperty_;
  String? category_;
  String? guidance_;
  String? csUnitString_;
  String? ciUnitString_;
  String? baseFactorStr_;
  num? baseFactor_;
  bool defError_;

  UcumUnit(
    this.isBase_,
    this.name_,
    this.csCode_,
    this.ciCode_,
    this.property_,
    dynamic magnitude_,
    List<int> dim_,
    this.printSymbol_,
    this.class_,
    this.isMetric_,
    this.variable_,
    this.cnv_,
    this.cnvPfx_,
    this.isSpecial_,
    this.isArbitrary_,
    this.moleExp_,
    this.synonyms_,
    this.source_,
    this.loincProperty_,
    this.category_,
    this.guidance_,
    this.csUnitString_,
    this.ciUnitString_,
    this.baseFactorStr_,
    this.baseFactor_,
    this.defError_,
  )   : dim_ = Dimension(dim_),
        magnitude_ =
            magnitude_ is num || magnitude_ is BigInt ? magnitude_ : null;

  // Constructor
  UcumUnit.namedConstructor({
    this.isBase_ = false,
    this.name_ = '',
    this.csCode_ = '',
    this.ciCode_ = '',
    this.property_ = '',
    this.magnitude_ = 1,
    Dimension? dim_,
    this.printSymbol_,
    this.class_,
    this.isMetric_ = false,
    this.variable_,
    this.cnv_,
    this.cnvPfx_ = 1,
    this.isSpecial_ = false,
    this.isArbitrary_ = false,
    this.moleExp_ = 0,
    this.synonyms_,
    this.source_,
    this.loincProperty_,
    this.category_,
    this.guidance_,
    this.csUnitString_,
    this.ciUnitString_,
    this.baseFactorStr_,
    this.baseFactor_,
    this.defError_ = false,
  }) : dim_ = dim_ ?? Dimension();

  factory UcumUnit.fromJson(Map<String, dynamic> json) {
    print(json['synonyms_'].runtimeType);
    return UcumUnit.namedConstructor(
      isBase_: json['isBase_'] as bool,
      name_: json['name_'] as String,
      csCode_: json['csCode_'] as String,
      ciCode_: json['ciCode_'] as String,
      property_: json['property_'] as String,
      magnitude_: json['magnitude_'] is num || json['magnitude_'] is BigInt
          ? json['magnitude_']
          : null,
      dim_: json['dim_'] == null ? null : Dimension.fromJson(json['dim_']),
      printSymbol_: json['printSymbol_'] as String?,
      class_: json['class_'] as String?,
      isMetric_: json['isMetric_'] as bool,
      variable_: json['variable_'] as String?,
      cnv_: json['cnv_'] as String?,
      cnvPfx_: json['cnvPfx_'] as num,
      isSpecial_: json['isSpecial_'] as bool,
      isArbitrary_: json['isArbitrary_'] as bool,
      moleExp_: json['moleExp_'] as int,
      synonyms_: json['synonyms_'] as String?,
      source_: json['source_'] as String,
      loincProperty_: json['loincProperty_'] as String?,
      category_: json['category_'] as String?,
      guidance_: json['guidance_'] as String?,
      csUnitString_: json['csUnitString_'] as String?,
      ciUnitString_: json['ciUnitString_'] as String?,
      baseFactorStr_: json['baseFactorStr_'] as String?,
      baseFactor_: json['baseFactor_'] as num?,
      defError_: json['defError_'] as bool,
    );
  }

  // Example of the clone method
  UcumUnit clone() => UcumUnit(
        this.isBase_,
        this.name_,
        this.csCode_,
        this.ciCode_,
        this.property_,
        this.magnitude_,
        this.dim_?.dimVec_ ?? [],
        this.printSymbol_,
        this.class_,
        this.isMetric_,
        this.variable_,
        this.cnv_,
        this.cnvPfx_,
        this.isSpecial_,
        this.isArbitrary_,
        this.moleExp_,
        this.synonyms_,
        this.source_,
        this.loincProperty_,
        this.category_,
        this.guidance_,
        this.csUnitString_,
        this.ciUnitString_,
        this.baseFactorStr_,
        this.baseFactor_,
        this.defError_,
      );

  // Example of the convertFrom method
  num convertFrom(num num, UcumUnit fromUnit) {
    // Implementation details...
    return 0; // Placeholder for actual implementation
  }

  // Method to check if this unit is commensurable with another unit for mole to mass conversions
  bool isMoleMassCommensurable(UcumUnit unit2) {
    // Implementation details...
    return false; // Placeholder for actual implementation
  }

  // Method to get UnitTables instance
  UnitTables getUnitTables() => UnitTables.instance;

  // Example of the multiplyThis method
  UcumUnit multiplyThis(num s) {
    // Placeholder for actual implementation
    return UcumUnit.namedConstructor();
  }

  // Example of the multiplyThese method
  UcumUnit multiplyThese(UcumUnit unit2) {
    // Placeholder for actual implementation
    return UcumUnit.namedConstructor();
  }

  // Example of the divide method
  UcumUnit divide(UcumUnit unit2) {
    // Placeholder for actual implementation
    return UcumUnit.namedConstructor();
  }

  // Example of the invert method
  UcumUnit invert() {
    // Placeholder for actual implementation
    return UcumUnit.namedConstructor();
  }

  // Example of the invertString method
  String invertString(String theString) {
    // Placeholder for actual implementation
    return '';
  }

  // Example of the _concatStrs method
  String _concatStrs(String str1, String operator, String str2,
      String startChar, String endChar) {
    // Placeholder for actual implementation
    return '';
  }

  // Example of the _buildOneString method
  String _buildOneString(String str, String startChar, String endChar) {
    // Placeholder for actual implementation
    return '';
  }

  // Example of the power method
  UcumUnit power(int p) {
    // Placeholder for actual implementation
    return UcumUnit.namedConstructor();
  }

  ///  Clears fields like isBase_, synonyms_, etc. when a unit has been cloned
  ///  from a known unit but it being used to construct a derived unit.
  ///
  resetFieldsForDerivedUnit() {
    this.guidance_ = '';
    this.synonyms_ = null;
    this.isBase_ = false;
  }

  dynamic fieldByString(String string) {
    switch (string) {
      case 'isBase_':
        return isBase_;
      case 'name_':
        return name_;
      case 'csCode_':
        return csCode_;
      case 'ciCode_':
        return ciCode_;
      case 'property_':
        return property_;
      case 'magnitude_':
        return magnitude_;
      case 'dim_':
        return dim_;
      case 'printSymbol_':
        return printSymbol_;
      case 'class_':
        return class_;
      case 'isMetric_':
        return isMetric_;
      case 'variable_':
        return variable_;
      case 'cnv_':
        return cnv_;
      case 'cnvPfx_':
        return cnvPfx_;
      case 'isSpecial_':
        return isSpecial_;
      case 'isArbitrary_':
        return isArbitrary_;
      case 'moleExp_':
        return moleExp_;
      case 'synonyms_':
        return synonyms_;
      case 'source_':
        return source_;
      case 'loincProperty_':
        return loincProperty_;
      case 'category_':
        return category_;
      case 'guidance_':
        return guidance_;
      case 'csUnitString_':
        return csUnitString_;
      case 'ciUnitString_':
        return ciUnitString_;
      case 'baseFactorStr_':
        return baseFactorStr_;
      case 'baseFactor_':
        return baseFactor_;
      case 'defError_':
        return defError_;
      default:
        throw ('Unknown field $string');
    }
  }
}

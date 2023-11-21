class Prefix {
  late String code_;
  late String ciCode_;
  late String name_;
  late String printSymbol_;
  dynamic value_;
  dynamic exp_;

  Prefix(Map<String, dynamic> attrs) {
    if (attrs['code_'] == null ||
        attrs['ciCode_'] == null ||
        attrs['name_'] == null ||
        attrs['value_'] == null ||
        attrs['exp_'] == null) {
      throw Exception(
          'Prefix constructor called missing one or more parameters. '
          'Prefix codes (cs or ci), name, value, and exponent must all be specified '
          'and all but the exponent must not be null.');
    }

    this.code_ = attrs['code_'];
    this.ciCode_ = attrs['ciCode_'];
    this.name_ = attrs['name_'];
    this.printSymbol_ = attrs['printSymbol_'];

    if (attrs['value_'] is String) {
      this.value_ = double.tryParse(attrs['value_']);
    } else {
      this.value_ = attrs['value_'];
    }

    this.exp_ = attrs['exp_'];
  }

  dynamic getValue() {
    return this.value_;
  }

  String getCode() {
    return this.code_;
  }

  String getCiCode() {
    return this.ciCode_;
  }

  String getName() {
    return this.name_;
  }

  String getPrintSymbol() {
    return this.printSymbol_;
  }

  dynamic getExp() {
    return this.exp_;
  }

  bool equals(Prefix prefix2) {
    return this.code_ == prefix2.code_ &&
        this.ciCode_ == prefix2.ciCode_ &&
        this.name_ == prefix2.name_ &&
        this.printSymbol_ == prefix2.printSymbol_ &&
        this.value_ == prefix2.value_ &&
        this.exp_ == prefix2.exp_;
  }
}

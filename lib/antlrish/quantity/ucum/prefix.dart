class Prefix {
  String code_;
  String? ciCode_;
  String name_;
  String? printSymbol_;
  num value_;
  int? exp_;

  Prefix({
    required this.code_,
    this.ciCode_,
    required this.name_,
    this.printSymbol_,
    required this.value_,
    this.exp_,
  }) {
    if (code_.isEmpty || name_.isEmpty) {
      throw Exception('Prefix constructor called with missing parameters. '
          'Prefix code, name, and value must all be specified.');
    }
  }

  factory Prefix.fromJson(Map<String, dynamic> json) {
    return Prefix(
      code_: json['code_'] as String,
      ciCode_: json['ciCode_'] as String?,
      name_: json['name_'] as String,
      printSymbol_: json['printSymbol_'] as String?,
      value_: json['value_'] as num,
      exp_: int.tryParse(json['exp_'].toString()),
    );
  }

  bool equals(Prefix other) {
    return code_ == other.code_ &&
        ciCode_ == other.ciCode_ &&
        name_ == other.name_ &&
        printSymbol_ == other.printSymbol_ &&
        value_ == other.value_ &&
        exp_ == other.exp_;
  }
}

import 'ucum_pkg.dart';

class PrefixTables {
  final Map<String, Prefix> _byCode = {};
  final Map<num, Prefix> _byValue = {};

  static PrefixTables get instance => _instance;

  static final PrefixTables _instance = PrefixTables._();

  PrefixTables._();

  int prefixCount() => _byCode.length;

  String allPrefixesByValue() {
    var buffer = StringBuffer();
    var sortedValues = _byValue.keys.toList()..sort();
    for (var value in sortedValues) {
      var prefix = _byValue[value]!;
      buffer.writeln('${prefix.code_},${prefix.name_},,${prefix.value_}');
    }
    return buffer.toString();
  }

  List<Prefix> allPrefixesByCode() {
    var sortedCodes = _byCode.keys.toList()..sort();
    return sortedCodes.map((code) => _byCode[code]!).toList();
  }

  void add(Prefix prefix) {
    _byCode[prefix.code_] = prefix;
    _byValue[prefix.value_] = prefix;
  }

  bool isDefined(String code) {
    return _byCode.containsKey(code);
  }

  Prefix? getPrefixByCode(String code) {
    return _byCode[code];
  }

  Prefix? getPrefixByValue(double value) {
    return _byValue[value];
  }
}

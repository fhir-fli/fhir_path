class PrefixTablesFactory {
  Map<String, dynamic> byCode_ = {};
  Map<dynamic, dynamic> byValue_ = {};

  int prefixCount() {
    return byCode_.length;
  }

  String allPrefixesByValue() {
    String prefixBuff = '';
    List<dynamic> pList = byValue_.keys.toList();
    pList.sort();

    for (int p = 0; p < pList.length; p++) {
      dynamic pfx = getPrefixByValue(pList[p]);
      prefixBuff += '${pfx['code_']},${pfx['name_']},,${pfx['value_']}\r\n';
    }
    return prefixBuff;
  }

  List<dynamic> allPrefixesByCode() {
    List<dynamic> prefixList = [];
    List<String> pList = byCode_.keys.toList();
    pList.sort();

    for (int p = 0; p < pList.length; p++) {
      prefixList.add(getPrefixByCode(pList[p]));
    }
    return prefixList;
  }

  void add(dynamic prefixObj) {
    byCode_[prefixObj['code_']] = prefixObj;
    byValue_[prefixObj['value_']] = prefixObj;
  }

  bool isDefined(String code) {
    return byCode_.containsKey(code);
  }

  dynamic getPrefixByCode(String code) {
    return byCode_[code];
  }

  dynamic getPrefixByValue(dynamic value) {
    return byValue_[value];
  }
}

PrefixTablesFactory prefixTablesInstance = PrefixTablesFactory();

class PrefixTables {
  static PrefixTablesFactory getInstance() {
    return prefixTablesInstance;
  }
}

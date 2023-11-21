import 'ucum.dart';

class UcumLhcUtils {
  UnitString uStrParser_;

  UcumLhcUtils() {
    if (UnitTables.getInstance().unitsCount() == 0) {
      ucumJsonDefs.loadJsonDefs();
    }
    uStrParser_ = UnitString.getInstance();
  }

  void useHTMLInMessages([bool use = true]) {
    if (use == null) use = true;
    uStrParser_.useHTMLInMessages(use);
  }

  void useBraceMsgForEachString([bool use = true]) {
    if (use == null) use = true;
    uStrParser_.useBraceMsgForEachString(use);
  }

  // ... other methods translations ...

  Map<String, dynamic> getSpecifiedUnit(String uName, String valConv,
      [bool suggest = false]) {
    // Translation of the method content...
  }

  // ... other methods translations ...

  static UcumLhcUtils? _instance;

  static UcumLhcUtils getInstance() {
    if (_instance == null) {
      _instance = UcumLhcUtils();
    }
    return _instance!;
  }
}

import 'ucum.dart';

class UcumJsonDefs {
  void loadJsonDefs() {
    final prefixes = unpackArray(jsonDefs['prefixes']! as Map<String, dynamic>);
    final units = unpackArray(jsonDefs['units']! as Map<String, dynamic>);

    if (UnitTables.getInstance().unitsCount() == 0) {
      final pTab = PrefixTables.getInstance();
      final plen = prefixes.length;

      for (var p = 0; p < plen; p++) {
        final newPref = Prefix(prefixes[p]);
        pTab.add(newPref);
      }

      final uTab = UnitTables.getInstance();
      final ulen = units.length;

      for (var u = 0; u < ulen; u++) {
        final newUnit = Unit(units[u]);
        uTab.addUnit(newUnit);
      }
    }
  }
}

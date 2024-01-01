import 'ucum_pkg.dart';

class UcumJsonDefs {
  static UcumJsonDefs get instance => _instance;

  static final UcumJsonDefs _instance = UcumJsonDefs._();

  UcumJsonDefs._();

  void loadUcumDefs() {
    final Map<String, dynamic> jsonDefs = ucumMinJsonDefs;
    final prefixes = unpackArray(jsonDefs['prefixes']);
    final units = unpackArray(jsonDefs['units']);
    var unitTables = UnitTables.instance;
    if (unitTables.unitsCount() == 0) {
      var prefixTables = PrefixTables.instance;
      for (var prefixData in prefixes) {
        var newPrefix = Prefix.fromJson(prefixData);
        prefixTables.add(newPrefix);
      }

      for (var unitData in units) {
        var newUnit = UcumUnit.fromJson(unitData);
        unitTables.addUnit(newUnit);
      }
    }
  }
}

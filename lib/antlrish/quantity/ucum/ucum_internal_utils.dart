import 'ucum_pkg.dart';

bool isNumericString(String theString) {
  return double.tryParse(theString) != null;
}

bool isIntegerUnit(String str) {
  return RegExp(r'^\d+$').hasMatch(str);
}

ReturnObject getSynonyms(String theSyn) {
  final UnitTables utab = UnitTables.instance;
  ReturnObject resp = utab.getUnitBySynonym(theSyn);
  if (resp.units.isEmpty) {
    return ReturnObject(UnitGetStatus.failed,
        'No unit found for synonym $theSyn', <UcumUnit>[]);
  } else {
    return resp.copyWith(status: UnitGetStatus.succeeded);
  }
}

class UnitEntry {
  final String? mag;
  final UcumUnit unit;
  const UnitEntry(this.mag, this.unit);
}

class ReturnObject {
  final UnitGetStatus status;
  final String? msg;
  final List<UcumUnit> units;

  const ReturnObject(
    this.status,
    this.msg,
    this.units,
  );

  ReturnObject copyWith({
    UnitGetStatus? status,
    String? msg,
    List<UcumUnit>? units,
  }) =>
      ReturnObject(
        status ?? this.status,
        msg ?? this.msg,
        units ?? this.units,
      );
}

enum UnitGetStatus { succeeded, failed, error }

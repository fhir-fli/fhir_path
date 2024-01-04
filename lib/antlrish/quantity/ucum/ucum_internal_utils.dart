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
    return ReturnObject(
      UnitGetStatus.failed,
      ['No unit found for synonym $theSyn'],
      null,
      null,
      <UcumUnit>[],
    );
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
  final List<String>? msg;
  final List<String>? suggestions;
  final String? invalidUnit;
  final List<UcumUnit> units;

  const ReturnObject(
    this.status,
    this.msg,
    this.suggestions,
    this.invalidUnit,
    this.units,
  );

  const ReturnObject.empty()
      : status = UnitGetStatus.succeeded,
        msg = null,
        suggestions = null,
        invalidUnit = null,
        units = const <UcumUnit>[];

  ReturnObject copyWith({
    UnitGetStatus? status,
    List<String>? msg,
    List<String>? suggestions,
    String? invalidUnit,
    List<UcumUnit>? units,
  }) =>
      ReturnObject(
        status ?? this.status,
        msg ?? this.msg,
        suggestions ?? this.suggestions,
        invalidUnit ?? this.invalidUnit,
        units ?? this.units,
      );
}

enum UnitGetStatus { succeeded, failed, error }

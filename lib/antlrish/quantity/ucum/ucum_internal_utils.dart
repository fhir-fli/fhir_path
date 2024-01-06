import 'ucum_pkg.dart';

abstract class InternalUtils {
  static bool isNumericString(String theString) =>
      double.tryParse(theString) != null;

  static bool isIntegerUnit(String str) => RegExp(r'^\d+$').hasMatch(str);

  static ReturnObject getSynonyms(String theSyn) {
    final UnitTables utab = UnitTables.instance;
    ReturnObject resp = utab.getUnitBySynonym(theSyn);
    if (resp.units.isEmpty) {
      return ReturnObject(
        status: UnitGetStatus.failed,
        msg: ['No unit found for synonym $theSyn'],
        units: <UcumUnit>[],
      );
    } else {
      return resp.copyWith(status: UnitGetStatus.succeeded);
    }
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
  final List<String>? retMsg;
  final String? origString;
  final List<String>? suggestions;
  final String? invalidUnit;
  final List<UcumUnit> units;

  const ReturnObject({
    required this.status,
    this.msg,
    this.retMsg,
    this.origString,
    this.suggestions,
    this.invalidUnit,
    required this.units,
  });

  const ReturnObject.empty()
      : status = UnitGetStatus.initialized,
        msg = null,
        retMsg = null,
        origString = null,
        suggestions = null,
        invalidUnit = null,
        units = const <UcumUnit>[];

  ReturnObject copyWith({
    UnitGetStatus? status,
    List<String>? msg,
    List<String>? retMsg,
    String? origString,
    List<String>? suggestions,
    String? invalidUnit,
    List<UcumUnit>? units,
  }) =>
      ReturnObject(
        status: status ?? this.status,
        msg: msg ?? this.msg,
        retMsg: retMsg ?? this.retMsg,
        origString: origString ?? this.origString,
        suggestions: suggestions ?? this.suggestions,
        invalidUnit: invalidUnit ?? this.invalidUnit,
        units: units ?? this.units,
      );
}

enum UnitGetStatus { succeeded, failed, error, initialized }

class AnnotatedText {
  final String pStr;
  final String? startText;
  final String? endText;
  const AnnotatedText(this.pStr, this.startText, this.endText);
}

class SuggestedObject {
  final String msg;
  final String invalidUnit;
  final List<dynamic> units;
  const SuggestedObject(this.msg, this.invalidUnit, this.units);
}

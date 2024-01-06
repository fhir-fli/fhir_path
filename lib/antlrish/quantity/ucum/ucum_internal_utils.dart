import 'ucum_pkg.dart';

abstract class UcumUtils {
  static bool isNumericString(String theString) =>
      double.tryParse(theString) != null;

  static bool isIntegerUnit(String str) => RegExp(r'^\d+$').hasMatch(str);

  static ReturnObject getSynonyms(String theSyn) {
    UnitTables utab = UnitTables.instance;
    ReturnObject resp = utab.getUnitBySynonym(theSyn);
    if (resp.units?.isEmpty ?? true) {
      return ReturnObject(
        status: ReturnStatus.failed,
        msg: ['No unit found for synonym $theSyn'],
        units: <UcumUnit>[],
      );
    } else {
      return resp.copyWith(status: ReturnStatus.succeeded);
    }
  }
}

class ReturnObject {
  final ReturnStatus status;
  final List<String>? msg;
  final List<String>? retMsg;
  final String? origString;
  final UcumUnit? unit;
  final List<Suggestion>? suggestions;
  final List<UcumUnit>? units;

  const ReturnObject({
    required this.status,
    this.msg,
    this.retMsg,
    this.origString,
    this.unit,
    this.suggestions,
    this.units,
  });

  factory ReturnObject.empty() => ReturnObject(status: ReturnStatus.unknown);

  ReturnObject copyWith({
    ReturnStatus? status,
    List<String>? msg,
    List<String>? retMsg,
    String? origString,
    UcumUnit? unit,
    List<Suggestion>? suggestions,
    List<UcumUnit>? units,
  }) =>
      ReturnObject(
        status: status ?? this.status,
        msg: msg ?? this.msg,
        retMsg: retMsg ?? this.retMsg,
        origString: origString ?? this.origString,
        unit: unit ?? this.unit,
        suggestions: suggestions ?? this.suggestions,
        units: units ?? this.units,
      );
}

class ConvertObject extends ReturnObject {
  final num? toVal;
  final UcumUnit? fromUnit;
  final UcumUnit? toUnit;

  const ConvertObject({
    required super.status,
    super.msg,
    super.retMsg,
    super.origString,
    super.unit,
    super.suggestions,
    super.units,
    this.toVal,
    this.fromUnit,
    this.toUnit,
  });

  factory ConvertObject.empty() => ConvertObject(status: ReturnStatus.unknown);

  ConvertObject copyWith({
    ReturnStatus? status,
    List<String>? msg,
    List<String>? retMsg,
    String? origString,
    UcumUnit? unit,
    List<Suggestion>? suggestions,
    List<UcumUnit>? units,
    num? toVal,
    UcumUnit? fromUnit,
    UcumUnit? toUnit,
  }) =>
      ConvertObject(
        status: status ?? this.status,
        msg: msg ?? this.msg,
        retMsg: retMsg ?? this.retMsg,
        origString: origString ?? this.origString,
        unit: unit ?? this.unit,
        suggestions: suggestions ?? this.suggestions,
        units: units ?? this.units,
        toVal: toVal ?? this.toVal,
        fromUnit: fromUnit ?? this.fromUnit,
        toUnit: toUnit ?? this.toUnit,
      );
}

enum ReturnStatus {
  valid,
  invalid,
  error,
  failed,
  succeeded,
  unknown,
}

class Suggestion {
  final String msg;
  final String invalidUnit;
  final List<UcumUnit> units;

  const Suggestion({
    required this.msg,
    required this.invalidUnit,
    required this.units,
  });
}

class UnitEntry {
  final String? mag;
  final UcumUnit? unit;
  const UnitEntry(this.mag, this.unit);
}

class Number {
  final int? _integer;
  final double? _decimal;
  final BigInt? _bigInt;
  dynamic get value => _integer ?? _decimal ?? _bigInt;
  const Number._(this._integer, this._decimal, this._bigInt);
  factory Number.integer(int integer) => Number._(integer, null, null);
  factory Number.double(double decimal) => Number._(null, decimal, null);
  factory Number.bigInt(BigInt bigInt) => Number._(null, null, bigInt);
  factory Number.num(num num) {
    if (num is int) {
      return Number.integer(num);
    } else if (num is double) {
      return Number.double(num);
    } else {
      throw ArgumentError('num must be int or double');
    }
  }

  Number _fromOther(dynamic number) => number is num
      ? Number.num(number)
      : number is BigInt
          ? Number.bigInt(number)
          : number is Number
              ? number
              : throw ArgumentError('number must be num or BigInt');

  Number operator +(Object number) {
    Number other = _fromOther(number);
    // If either operand is a double, the result should be a double
    if (_decimal != null || other._decimal != null) {
      return Number.double((toDouble(this) + toDouble(other)));
    }

    // If one operand is BigInt and the other is not a double (could be int or
    //BigInt), convert both to BigInt and perform addition
    else if (_bigInt != null || other._bigInt != null) {
      return Number.bigInt((toBigInt(this) + toBigInt(other)));
    }

    // If both operands are int, perform int addition
    else {
      return Number.integer(toInt(this) + toInt(other));
    }
  }

  Number operator -(Object number) {
    Number other = _fromOther(number);
    if (_decimal != null || other._decimal != null) {
      return Number.double((toDouble(this) - toDouble(other)));
    } else if (_bigInt != null || other._bigInt != null) {
      return Number.bigInt((toBigInt(this) - toBigInt(other)));
    } else {
      return Number.integer(toInt(this) - toInt(other));
    }
  }

  Number operator *(Object number) {
    Number other = _fromOther(number);
    if (_decimal != null || other._decimal != null) {
      return Number.double((toDouble(this) * toDouble(other)));
    } else if (_bigInt != null || other._bigInt != null) {
      return Number.bigInt((toBigInt(this) * toBigInt(other)));
    } else {
      return Number.integer(toInt(this) * toInt(other));
    }
  }

  Number operator /(Object number) {
    Number other = _fromOther(number);
    // Division always results in a double to maintain precision
    return Number.double((toDouble(this) / toDouble(other)));
  }

  Number operator %(Object number) {
    Number other = _fromOther(number);
    if (_decimal != null || other._decimal != null) {
      return Number.double((toDouble(this) % toDouble(other)));
    } else if (_bigInt != null || other._bigInt != null) {
      return Number.bigInt((toBigInt(this) % toBigInt(other)));
    } else {
      return Number.integer(toInt(this) % toInt(other));
    }
  }

  static int toInt(Number number) =>
      number.value is int ? number.value as int : (number.value as num).toInt();

  static double toDouble(Number number) => number.value is double
      ? number.value as double
      : (number.value as num).toDouble();

  static BigInt toBigInt(Number number) => number.value is BigInt
      ? number.value as BigInt
      : BigInt.from(number.value as int);
}

// class AnnotatedText {
//   String pStr;
//   String? startText;
//   String? endText;
//   AnnotatedText(this.pStr, this.startText, this.endText);
// }

// class SuggestedObject {
//   String msg;
//   String invalidUnit;
//   List<dynamic> units;
//    SuggestedObject(this.msg, this.invalidUnit, this.units);
// }

// * pStr: <String>
// * beforeAnnotation: <String>
// * afterAnnotation: <String>

// * retMsg_: <String>[]
// * annotations_: <String>[]

// *  <UcumUnit>[]
// *  origString

// *  'status': <ReturnStatus>
// *  'toVal': <num>
// *  'msg': <String>[]
// *  'suggestions':
//     * from: [['msg', 'invalidUnit','units']]
//     * to: [['msg', 'invalidUnit','units']]
// *  'fromUnit': <UcumUnic>
// *  'toUnit': <UcumUnit>

// *  'status': <ReturnStatus>
// *  'msg': <String>[]
// *  'magnitude': magnitude?
// *  'fromUnitIsSpecial': <bool>
// *  'unitToExp': <UcumUnit, exponent>{}

// *  'status': <ReturnStatus>
// *   'unit': UcumUnit
// *   'origString': String
// *   'retMsg': <String>[]
// *   'suggestions': <Suggestion>[]

// * 'unit': UcumUnit
// *  'inString': <String>
// *   'suggestions': <Suggestion>[]

// * [UcumUnit, string]
// * retMsg_: <String>[]
// * parensUnits_: <UcumUnit>[]
// * the this.annotations_ array is referenced by methods called within
// *   this one
// *   'suggestions': <Suggestion>[]

// *  [preString, afterString]
// *  bool

// * [unitString, originString, bool]
// * retMsg_: <String>[]

// * [UcumUnit, bool]
// * retMsg_: <String>[]
// * parensUnits_: <UcumUnit>[]

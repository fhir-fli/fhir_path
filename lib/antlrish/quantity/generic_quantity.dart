// Package imports:
import 'package:fhir/dstu2.dart' as dstu2;
import 'package:fhir/primitive_types/primitive_types.dart' as primitives;
import 'package:fhir/r4.dart' as r4;
import 'package:fhir/r5.dart' as r5;
import 'package:fhir/stu3.dart' as stu3;
import 'package:fhir_path/petit/utils/exceptions.dart';
import 'package:units_converter/units_converter.dart';

import 'quantity_comparator.dart';
import 'ratios.dart';
import 'string_unit_to_property.dart';
import 'ucum_unit_codes.dart';
import 'units.dart';

class GenericQuantity {
  static RegExp _GenericQuantityRegex = RegExp(
      r"^(?<value>(\+|-)?\d+(\.\d+)?)\s*('(?<unit>[^']+)'|(?<time>[a-zA-Z]+))?$");

  final num value;
  final String? unit;
  final String? comparator;
  final String? system;
  final String? code;

  const GenericQuantity({
    required this.value,
    this.unit,
    this.comparator,
    this.system,
    this.code,
  });

  GenericQuantity copyWith({
    num? value,
    String? unit,
    String? comparator,
    String? system,
    String? code,
  }) =>
      GenericQuantity(
        value: value ?? this.value,
        unit: unit ?? this.unit,
        comparator: comparator ?? this.comparator,
        system: system ?? this.system,
        code: code ?? this.code,
      );

  factory GenericQuantity.fromDstu2Quantity(dstu2.Quantity quantity) {
    if (quantity.value?.value == null || quantity.code?.value == null) {
      throw Exception('Malformed quantity: $quantity');
    }
    return GenericQuantity(
      value: quantity.value!.value!,
      unit: quantity.code!.value!,
      comparator: quantity.comparator.toString() ==
              'QuantityQuantityComparator.less_than'
          ? '<'
          : quantity.comparator.toString() ==
                  'QuantityQuantityComparator.less_or_equal'
              ? '<='
              : quantity.comparator.toString() ==
                      'QuantityQuantityComparator.greater_or_equal'
                  ? '>='
                  : quantity.comparator.toString() ==
                          'QuantityQuantityComparator.greater_than'
                      ? '>'
                      : null,
      system: quantity.system?.value.toString(),
      code: quantity.code?.value,
    );
  }

  factory GenericQuantity.fromStu3Quantity(stu3.Quantity quantity) {
    if (quantity.value?.value == null || quantity.code?.value == null) {
      throw Exception('Malformed quantity: $quantity');
    }
    return GenericQuantity(
      value: quantity.value!.value!,
      unit: quantity.code!.value!,
      comparator: quantity.comparator.toString() ==
              'QuantityQuantityComparator.less_than'
          ? '<'
          : quantity.comparator.toString() ==
                  'QuantityQuantityComparator.less_or_equal'
              ? '<='
              : quantity.comparator.toString() ==
                      'QuantityQuantityComparator.greater_or_equal'
                  ? '>='
                  : quantity.comparator.toString() ==
                          'QuantityQuantityComparator.greater_than'
                      ? '>'
                      : null,
      system: quantity.system,
      code: quantity.code?.value,
    );
  }

  factory GenericQuantity.fromR4Quantity(r4.Quantity quantity) {
    if (quantity.value?.value == null || quantity.code?.value == null) {
      throw Exception('Malformed quantity: $quantity');
    }
    return GenericQuantity(
      value: quantity.value!.value!,
      unit: quantity.code!.value!,
      comparator: quantity.comparator.toString() ==
              'QuantityQuantityComparator.less_than'
          ? '<'
          : quantity.comparator.toString() ==
                  'QuantityQuantityComparator.less_or_equal'
              ? '<='
              : quantity.comparator.toString() ==
                      'QuantityQuantityComparator.greater_or_equal'
                  ? '>='
                  : quantity.comparator.toString() ==
                          'QuantityQuantityComparator.greater_than'
                      ? '>'
                      : null,
      system: quantity.system?.value.toString(),
      code: quantity.code?.value,
    );
  }

  factory GenericQuantity.fromR5Quantity(r5.Quantity quantity) {
    if (quantity.value?.value == null || quantity.code?.value == null) {
      throw Exception('Malformed quantity: $quantity');
    }
    return GenericQuantity(
      value: quantity.value!.value!,
      unit: quantity.code!.value!,
      comparator: quantity.comparator.toString() ==
              'QuantityQuantityComparator.less_than'
          ? '<'
          : quantity.comparator.toString() ==
                  'QuantityQuantityComparator.less_or_equal'
              ? '<='
              : quantity.comparator.toString() ==
                      'QuantityQuantityComparator.greater_or_equal'
                  ? '>='
                  : quantity.comparator.toString() ==
                          'QuantityQuantityComparator.greater_than'
                      ? '>'
                      : null,
      system: quantity.system?.value.toString(),
      code: quantity.code?.value,
    );
  }

  static num valueFromString(String? string) {
    if (string == null) {
      return 0;
    } else {
      final match =
          _GenericQuantityRegex.firstMatch(string.replaceAll(r"\'", "'"));
      final valueMatch = match?.namedGroup('value');
      if (valueMatch == null) {
        return 0;
      } else {
        return num.tryParse(valueMatch) ?? 0;
      }
    }
  }

  static String unitFromString(String? string) {
    // Special logic for UCUM, where the empty unit is '1';
    if (string == null) {
      return '1';
    } else {
      final match =
          _GenericQuantityRegex.firstMatch(string.replaceAll(r"\'", "'"));
      final unit = match?.namedGroup('unit');
      final time = match?.namedGroup('time');
      String unitString = '';

      if (unit == null && time == null) {
        // Special logic for UCUM, where the empty unit is '1';
        unitString = '1';
      } else if (unit != null) {
        unitString = unit;
      } else if (time != null) {
        unitString = time;
      }

      // Cannot just replace all apostrophes, as some units have one in the middle.
      if (unitString.startsWith("'")) {
        unitString = unitString.substring(1, unitString.length - 1);
      }

      // Escaped ' can all be removed
      unitString.replaceAll(r"\'", '');

      // Try to normalize time-valued units
      return timeValuedQuantitiesUnits[unitString] ?? unitString;
    }
  }

  factory GenericQuantity.fromString(String quantityString) => GenericQuantity(
      value: valueFromString(quantityString),
      unit: unitFromString(quantityString));

  bool get isNaN => value.isNaN;
  bool get isTimeValued => timeValuedQuantitiesUnits.containsValue(unit);
  bool get isDefiniteDuration =>
      definiteQuantityDurationUnits.containsKey(unit);
  String toString() => isTimeValued ? '$value $unit' : "$value '$unit'";

  GenericQuantity abs() => copyWith(value: value.abs());

  bool _eq(Object o, bool equivalent) {
    if (identical(this, o)) {
      return true;
    } else if (o is! GenericQuantity) {
      return false;
    } else {
      final fromUnit = stringUnitToProperty[unit];
      final toUnit = stringUnitToProperty[o.unit];
      var oValue = o.value;
      var thisValue = this.value;
      if (fromUnit == null || toUnit == null) {
        if (fromUnit == null && toUnit == null) {
          if ((num.tryParse(unit.toString()) == 1) &&
              (num.tryParse(o.unit.toString()) == 1)) {
            if (equivalent) {
              final sigDigsLhs = thisValue.toStringAsExponential().split('e');
              final sigDigsRhs = oValue.toStringAsExponential().split('e');
              if (sigDigsLhs.first.length < sigDigsRhs.first.length) {
                oValue = num.parse(
                    '${sigDigsRhs.first.toString().substring(0, sigDigsLhs.first.length)}'
                    'e${sigDigsRhs.last}');
              } else {
                thisValue = num.parse(
                    '${sigDigsLhs.first.toString().substring(0, sigDigsRhs.first.length)}'
                    'e${sigDigsLhs.last}');
              }
              return thisValue == oValue;
            } else {
              return thisValue == oValue;
            }
          } else {
            return false;
          }
        } else {
          return false;
        }
      } else {
        if ((fromUnit is Ratio && toUnit is! Ratio) ||
            (fromUnit is! Ratio && toUnit is Ratio)) {
          return false;
        } else if (fromUnit is Ratio) {
          if (equivalent) {
            final sigDigsLhs = thisValue.toStringAsExponential().split('e');
            final sigDigsRhs = oValue.toStringAsExponential().split('e');
            if (sigDigsLhs.first.length < sigDigsRhs.first.length) {
              oValue = num.parse(
                  '${sigDigsRhs.first.toString().substring(0, sigDigsLhs.first.length)}'
                  'e${sigDigsRhs.last}');
            } else {
              thisValue = num.parse(
                  '${sigDigsLhs.first.toString().substring(0, sigDigsRhs.first.length)}'
                  'e${sigDigsLhs.last}');
            }
          }
          return thisValue.convertRatioFromTo(fromUnit, toUnit as Ratio) ==
              oValue;
        } else {
          if (equivalent) {
            final sigDigsLhs = thisValue.toStringAsExponential().split('e');
            final sigDigsRhs = oValue.toStringAsExponential().split('e');
            if (sigDigsLhs.first.length < sigDigsRhs.first.length) {
              oValue = num.parse(
                  '${sigDigsRhs.first.toString().substring(0, sigDigsLhs.first.length)}'
                  'e${sigDigsRhs.last}');
            } else {
              thisValue = num.parse(
                  '${sigDigsLhs.first.toString().substring(0, sigDigsRhs.first.length)}'
                  'e${sigDigsLhs.last}');
            }
          }
          return thisValue.convertFromTo(fromUnit, toUnit) == oValue;
        }
      }
    }
  }

  @override
  bool operator ==(Object other) => _eq(other, false);

  @override
  int get hashCode => '$value $unit'.hashCode;

  bool equivalent(Object o) => _eq(o, true);

  bool compare(QuantityComparator comparator, Object o) {
    if (identical(this, o)) {
      return true;
    } else if (o is! GenericQuantity) {
      return false;
    } else {
      final fromUnit = stringUnitToProperty[unit];
      final toUnit = stringUnitToProperty[o.unit];
      if ((fromUnit is Ratio && toUnit is! Ratio) ||
          (fromUnit is! Ratio && toUnit is Ratio)) {
        return false;
      } else if (fromUnit is Ratio) {
        if (toUnit is! Ratio) {
          return false;
        } else {
          final convertedValue = value.convertRatioFromTo(fromUnit, toUnit);

          if (convertedValue != null) {
            switch (comparator) {
              case QuantityComparator.gt:
                return convertedValue > o.value;
              case QuantityComparator.gte:
                return convertedValue >= o.value;
              case QuantityComparator.lt:
                return convertedValue < o.value;
              case QuantityComparator.lte:
                return convertedValue <= o.value;
            }
          } else {
            return false;
          }
        }
      } else {
        final convertedValue = value.convertFromTo(fromUnit, toUnit);
        if (convertedValue != null) {
          switch (comparator) {
            case QuantityComparator.gt:
              return convertedValue > o.value;
            case QuantityComparator.gte:
              return convertedValue >= o.value;
            case QuantityComparator.lt:
              return convertedValue < o.value;
            case QuantityComparator.lte:
              return convertedValue <= o.value;
          }
        } else {
          return false;
        }
      }
    }
  }

  bool operator >(Object o) => compare(QuantityComparator.gt, o);
  bool operator >=(Object o) => compare(QuantityComparator.gte, o);
  bool operator <(Object o) => compare(QuantityComparator.lt, o);
  bool operator <=(Object o) => compare(QuantityComparator.lte, o);

  GenericQuantity mathOperator(String operator, Object o) {
    if (o is! GenericQuantity) {
      throw primitives.InvalidTypes<GenericQuantity>(
          'A $operator operator was attemped with an object that was not a GenericQuantity: '
          'instead this was passed $o which is a type ${o.runtimeType}');
    } else if (unit == o.unit) {
      if (operator == '+') {
        return copyWith(value: value + o.value, unit: unit);
      } else if (operator == '-') {
        return copyWith(value: value - o.value, unit: unit);
      } else if (operator == '*') {
        return copyWith(value: value * o.value, unit: unit);
      } else if (operator == '/') {
        return copyWith(value: value / o.value, unit: unit);
      } else if (operator == '%') {
        return copyWith(value: value % o.value, unit: unit);
      } else {
        throw Exception('Invalid operator: $operator');
      }
    } else {
      final fromUnit = stringUnitToProperty[o.unit];
      final toUnit = stringUnitToProperty[unit];
      final convertedValue = o.value.convertFromTo(fromUnit, toUnit);
      if (convertedValue == null) {
        throw primitives.InvalidTypes<GenericQuantity>(
            'A $operator operator was attemped with two units types that are not '
            'comparable: $this and $o');
      } else {
        if (operator == '+') {
          return copyWith(value: value + convertedValue);
        } else if (operator == '-') {
          return copyWith(value: value - convertedValue);
        } else if (operator == '*') {
          return copyWith(value: value * convertedValue);
        } else if (operator == '/') {
          return copyWith(value: value / convertedValue);
        } else if (operator == '%') {
          return copyWith(value: value % convertedValue);
        } else {
          throw Exception('Invalid operator: $operator');
        }
      }
    }
  }

  GenericQuantity operator +(Object o) => mathOperator('+', o);

  GenericQuantity operator -(Object o) => mathOperator('-', o);

  GenericQuantity operator *(Object o) => mathOperator('*', o);

  GenericQuantity operator /(Object o) => mathOperator('/', o);

  GenericQuantity operator %(Object o) => mathOperator('%', o);

  dynamic subtract(dynamic lhs) => _addSubtract(lhs, false);

  dynamic add(dynamic lhs) => _addSubtract(lhs, true);

  dynamic _addSubtract(dynamic lhs, bool add) {
    int _twoInts(int left, int right) => add ? left + right : left - right;

    if (!(unit == 'year' ||
        unit == 'month' ||
        unit == 'week' ||
        unit == 'day' ||
        unit == 'hour' ||
        unit == 'minute' ||
        unit == 'second' ||
        unit == 'milisecond')) {
      throw FhirPathEvaluationException(
        'Date & Time additions must be done with the proper units.\n'
        '$lhs ${add ? "+" : "-"} $value $unit was attempted, this is invalid',
        cause: lhs,
        operation: add ? '+' : '-',
        arguments: [lhs, this],
      );
    }
    final yearValue = (unit == 'year'
            ? value
            : unit == 'month'
                ? (value / 12).truncate()
                : 0)
        .toInt();
    final monthValue = (unit == 'month' ? value.remainder(12) : 0).toInt();
    final dayValue = (unit == 'week'
            ? value * 7
            : unit == 'day'
                ? value
                : 0)
        .toInt();
    final hourValue = (unit == 'hour' ? value : 0).toInt();
    final minuteValue = (unit == 'minute' ? value : 0).toInt();
    final secondValue = (unit == 'second' ? value : 0).toInt();
    final millisecondValue = (unit == 'millisecond' ? value : 0).toInt();
    if ((lhs is primitives.FhirDate &&
            (hourValue != 0 ||
                minuteValue != 0 ||
                secondValue != 0 ||
                millisecondValue != 0)) ||
        (lhs is primitives.FhirTime &&
            (yearValue != 0 || monthValue != 0 || dayValue != 0))) {
      throw FhirPathEvaluationException(
        'Date & Time additions must be done with the proper units.\n'
        '$lhs ${add ? "+" : "-"} $value $unit was attempted, this is invalid',
        cause: lhs,
        operation: add ? '+' : '-',
        arguments: [lhs, this],
      );
    }
    if (lhs is primitives.FhirDate && lhs.isValid && lhs.value != null) {
      final newDate = DateTime.utc(
          _twoInts(lhs.value!.year, yearValue),
          _twoInts(lhs.value!.month, monthValue),
          _twoInts(lhs.value!.day, dayValue));
      if (lhs.precision == primitives.DateTimePrecision.yyyy) {
        return primitives.FhirDate(newDate.toString().substring(0, 4));
      } else if (lhs.precision == primitives.DateTimePrecision.yyyy_MM) {
        return primitives.FhirDate(newDate.toString().substring(0, 7));
      } else {
        return primitives.FhirDate(newDate.toString().substring(0, 10));
      }
    } else if (lhs is primitives.FhirTime && lhs.isValid && lhs.value != null) {
      final timeList = lhs.value!.split(':');
      final duration = Duration(
        hours: _twoInts(int.tryParse(timeList.first) ?? 0, hourValue),
        minutes: _twoInts(
            (timeList.length > 1 ? int.tryParse(timeList[1]) ?? 0 : 0),
            minuteValue),
        seconds: _twoInts(
            (timeList.length > 2
                ? int.tryParse(timeList[2].split('.').first) ?? 0
                : 0),
            secondValue),
        milliseconds: _twoInts(
            (timeList.length > 2 && timeList[2].split('.').length > 1
                ? int.tryParse(timeList[2].split('.').last) ?? 0
                : 0),
            millisecondValue),
      );
      final durationList = duration.toString().split(':');
      durationList.first =
          int.parse(durationList.first).remainder(24).toString();
      return primitives.FhirTime(durationList.join(':'));
    } else if (lhs is primitives.FhirDateTime &&
        lhs.isValid &&
        lhs.value != null) {
      final oldDateTime = lhs.value!;
      final newDateTime = DateTime.utc(
        _twoInts(oldDateTime.year, yearValue),
        _twoInts(oldDateTime.month, monthValue),
        _twoInts(oldDateTime.day, dayValue),
        _twoInts(oldDateTime.hour, hourValue),
        _twoInts(oldDateTime.minute, minuteValue),
        _twoInts(oldDateTime.second, secondValue),
        _twoInts(oldDateTime.millisecond, millisecondValue),
      );
      if (lhs.precision == primitives.DateTimePrecision.yyyy) {
        return primitives.FhirDateTime(
            newDateTime.toIso8601String().substring(0, 4));
      } else if (lhs.precision == primitives.DateTimePrecision.yyyy_MM) {
        return primitives.FhirDateTime(
            newDateTime.toIso8601String().substring(0, 7));
      } else if (lhs.precision == primitives.DateTimePrecision.yyyy_MM_dd) {
        return primitives.FhirDateTime(
            newDateTime.toIso8601String().substring(0, 10));
      } else {
        return primitives.FhirDateTime(newDateTime);
      }
    }
  }

  /// Validating function. First checks if passed value is a GenericQuantity or a
  /// Quantity from any type of FHIR version. If not, it  checks if it is a Map
  /// that contains both a numerical value, as well as a unit as defined by the [UCUM]
  /// specification (https://hl7.org/fhirpath/#UCUM), as long as it meets these requirements
  /// it is considered a valid Quantity for FHIRPath (https://hl7.org/fhirpath/#quantity)
  bool isQuantity(value) => value is GenericQuantity ||
          value is r4.Quantity ||
          value is r5.Quantity ||
          value is dstu2.Quantity ||
          value is stu3.Quantity
      ? true
      : value is Map
          ? value['value'] != null &&
              num.tryParse(value['value'].toString()) != null &&
              value['code'] != null &&
              ucumUnitCodes.contains(value['code'])
          : false;
}

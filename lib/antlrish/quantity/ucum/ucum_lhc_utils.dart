import 'ucum_pkg.dart';

class UcumLhcUtils {
  UnitString _uStrParser;

  static UcumLhcUtils get instance => _instance;

  static final UcumLhcUtils _instance = UcumLhcUtils._();

  UcumLhcUtils._()
      : // Get the UnitString parser
        _uStrParser = UnitString.instance {
    // Load JSON definitions if they haven't been loaded already
    if (UnitTables.instance.unitsCount() == 0) {
      UcumJsonDefs.instance.loadUcumDefs();
    }
  }

  void useHTMLInMessages(bool use) {
    _uStrParser.useHTMLInMessages(use);
  }

  void useBraceMsgForEachString(bool use) {
    _uStrParser.useBraceMsgForEachString(use);
  }

  ReturnObject convertUnitTo(
    String? fromUnitCode,
    double fromVal,
    String? toUnitCode, [
    bool suggest = false,
    double? molecularWeight,
  ]) {
    molecularWeight ??= null;

    ConvertObject returnObj = ConvertObject(status: ReturnStatus.failed);

    if (fromUnitCode != null && fromUnitCode.isNotEmpty) {
      fromUnitCode = fromUnitCode.trim();
    }
    if (fromUnitCode == null || fromUnitCode.isEmpty) {
      return returnObj.copyWith(
        status: ReturnStatus.error,
        msg: ['No "from" unit expression specified.'],
      );
    }

    // Assuming _checkFromVal is another method in this class
    _checkFromVal(fromVal, returnObj);

    if (toUnitCode != null && toUnitCode.isNotEmpty) {
      toUnitCode = toUnitCode.trim();
    }
    if (toUnitCode == null || toUnitCode.isEmpty) {
      return returnObj.copyWith(
        status: ReturnStatus.error,
        msg: ['No "to" unit expression specified.'],
      );
    }

    if (returnObj.status != ReturnStatus.error) {
      try {
        UcumUnit? fromUnit;
        UcumUnit? toUnit;

        ReturnObject parseResp =
            getSpecifiedUnit(fromUnitCode, 'convert', suggest);
        fromUnit = parseResp.unit;
        if (parseResp.retMsg?.isNotEmpty ?? false) {
          returnObj = returnObj.copyWith(
            msg: (returnObj.msg ?? [])..addAll(parseResp.retMsg!),
          );
        }
        if (parseResp.suggestions != null) {
          returnObj = returnObj.copyWith(
            suggestions: parseResp.suggestions,
          );
        }

        parseResp = this.getSpecifiedUnit(toUnitCode, 'convert', suggest);
        toUnit = parseResp.unit;
        if (parseResp.retMsg?.isNotEmpty ?? false) {
          returnObj = returnObj.copyWith(
            msg: (returnObj.msg ?? [])..addAll(parseResp.retMsg!),
          );
        }
        if (parseResp.suggestions != null) {
          returnObj = returnObj.copyWith(
            suggestions: parseResp.suggestions,
          );
        }
        if (fromUnit != null && toUnit != null) {
          try {
            Number? toVal;
            if (molecularWeight == null) {
              // Perform a normal conversion
              toVal = toUnit.convertFrom(fromVal, fromUnit);
            } else {
              // Handle molecular weight-based conversions
              if (fromUnit.moleExp_ != 0 && toUnit.moleExp_ != 0) {
                throw Exception(
                    'Molecular weight specified but both units are mole-based. No conversion attempted.');
              }
              if (fromUnit.moleExp_ == 0 && toUnit.moleExp_ == 0) {
                throw Exception(
                    'Molecular weight specified but neither unit is mole-based. No conversion attempted.');
              }
              if (!fromUnit.isMoleMassCommensurable(toUnit)) {
                throw Exception('Units are not commensurable for conversion.');
              }

              // Mole to mass or mass to mole conversion logic
              if (fromUnit.moleExp_ != 0) {
                // Assume a mole to mass conversion
                toVal =
                    fromUnit.convertMolToMass(fromVal, toUnit, molecularWeight);
              } else {
                // Assume a mass to mole conversion
                toVal =
                    fromUnit.convertMassToMol(fromVal, toUnit, molecularWeight);
              }
            }

            returnObj = returnObj.copyWith(
              status: ReturnStatus.succeeded,
              toVal: toVal,
              fromUnit: fromUnit,
              toUnit: toUnit,
            );
          } catch (e) {
            returnObj = returnObj.copyWith(
              status: ReturnStatus.failed,
              msg: (returnObj.msg ?? [])..add(e.toString()),
            );
          }
        }
      } catch (e) {
        returnObj = returnObj.copyWith(
          status: ReturnStatus.error,
          msg: (returnObj.msg ?? [])..add(e.toString()),
        );
      }
    }

    return returnObj;
  }

  Map<String, dynamic> convertToBaseUnits(String fromUnit, num fromVal) {
    Map<String, dynamic> retObj = {};
    _checkFromVal(fromVal, retObj);

    if (retObj['status'] == null) {
      final inputUnitLookup = getSpecifiedUnit(fromUnit, 'validate');
      retObj = {
        'status': inputUnitLookup['status'] == 'valid'
            ? 'succeeded'
            : inputUnitLookup['status']
      };
      final unit = inputUnitLookup['unit'];
      retObj['msg'] = inputUnitLookup['retMsg'] ?? [];

      if (unit == null) {
        if (retObj['msg'].isEmpty) {
          retObj['msg'].add('Could not find unit information for $fromUnit');
        }
      } else if (unit['isArbitrary']) {
        retObj['msg'].add(
            'Arbitrary units cannot be converted to base units or other units.');
        retObj['status'] = 'failed';
      } else if (retObj['status'] == 'succeeded') {
        final unitToExp = <String, dynamic>{};
        final dimVec = unit['dim']['dimVec'];
        var baseUnitString = '1';

        if (dimVec != null) {
          final Map<int, String> dimVecIndexToBaseUnit =
              UnitTables.instance.dimVecIndexToBaseUnit_;
          for (var i = 0; i < dimVec.length; ++i) {
            final exp = dimVec[i];
            if (exp != null && dimVecIndexToBaseUnit[i] != null) {
              unitToExp[dimVecIndexToBaseUnit[i]!] = exp;
              baseUnitString +=
                  '.' + dimVecIndexToBaseUnit[i]! + exp.toString();
            }
          }
        }

        final retUnitLookup = getSpecifiedUnit(baseUnitString, 'validate');
        final retUnit = retUnitLookup['unit'];

        if (retUnitLookup['status'] != 'valid') {
          retObj['msg'].add(
              'Unable to construct base unit string; tried $baseUnitString');
          retObj['status'] = 'error';
        } else {
          try {
            retObj['magnitude'] = retUnit.convertFrom(fromVal, unit);
          } catch (e) {
            retObj['msg'].add(e.toString());
            retObj['status'] = 'error';
          }

          if (retObj['status'] == 'succeeded') {
            retObj['unitToExp'] = unitToExp;
            retObj['fromUnitIsSpecial'] = unit['isSpecial'];
          }
        }
      }
    }

    return retObj;
  }

  ReturnObject _checkFromVal(num? fromVal, ReturnObject responseObj) {
    if (fromVal == null ||
        !UcumUtils.isNumericString(fromVal.toString()) ||
        fromVal.isNaN) {
      responseObj = responseObj.copyWith(
        status: ReturnStatus.error,
        msg: [
          'No "from" value, or an invalid "from" value, ' + 'was specified.'
        ],
      );
    }
    return responseObj;
  }

  // Retrieves units that include a term as a synonym or in their name
  ReturnObject checkSynonyms(String? theSyn) => theSyn == null
      ? ReturnObject(
          status: ReturnStatus.error,
          msg: ['No term specified for synonym search.'],
          units: <UcumUnit>[])
      : UcumUtils.getSynonyms(theSyn);

  ReturnObject getSpecifiedUnit(
    String uName,
    String valConv, [
    bool suggest = false,
  ]) {
    ReturnObject retObj = ReturnObject.empty();

    if (uName.isEmpty) {
      retObj = retObj.copyWith(retMsg: <String>[
        if (retObj.retMsg != null) ...retObj.retMsg!,
        'No unit string specified.'
      ]);
    } else {
      final utab = UnitTables.instance;
      uName = uName.trim();
      print('uName: $uName');

      // Try using the name as the code
      final theUnit = utab.getUnitByCode(uName);

      if (theUnit != null) {
        retObj = retObj.copyWith(units: <UcumUnit>[
          theUnit
        ], retMsg: [
          if (retObj.retMsg?.isNotEmpty ?? false) ...retObj.retMsg!,
          uName
        ]);
      } else {
        try {
          final resp = UnitString.instance.parseString(uName, valConv, suggest);
          retObj = retObj.copyWith(
            units: resp.units,
            retMsg: resp.retMsg,
            suggestions: resp.suggestions,
          );
          // retObj['unit'] = resp[0];
          // retObj['origString'] = resp[1];
        } catch (err) {
          print('Unit requested for unit string $uName. ' +
              'Request unsuccessful; error thrown = ${err.toString()}');
          retObj.copyWith(retMsg: [
            '$uName is not a valid unit. ${err.toString()}',
            if (retObj.retMsg?.isNotEmpty ?? false) ...retObj.retMsg!,
            'Error: ${err.toString()}'
          ]);
        }
      }
    }

    if (retObj['unit'] == null) {
      retObj['status'] = retObj['origString'] == null ? 'error' : 'invalid';
    } else {
      retObj['status'] = retObj['origString'] == uName ? 'valid' : 'invalid';
    }

    return retObj;
  }

  Map<String, dynamic> validateUnitString(
    String uStr, [
    bool suggest = false,
    String valConv = 'validate',
  ]) {
    var resp = getSpecifiedUnit(uStr, valConv, suggest);
    print('resp: $resp');
    var theUnit = resp['unit'];
    var retObj = theUnit == null
        ? {'ucumCode': null}
        : {
            'ucumCode': resp['origString'],
            'unit': {
              'code': theUnit.csCode_,
              'name': theUnit.name_,
              'guidance': theUnit.guidance_,
            }
          };
    retObj['status'] = resp['status'];
    if (resp['suggestions'] != null) {
      retObj['suggestions'] = resp['suggestions'];
    }
    retObj['msg'] = resp['retMsg'];
    return retObj;
  }

  List<dynamic> commensurablesList(String fromName) {
    final List<String> retMsg = <String>[];
    List<dynamic>? commUnits;
    final Map<String, dynamic> parseResp =
        getSpecifiedUnit(fromName, 'validate', false);
    final fromUnit = parseResp['unit'];
    if (parseResp['retMsg'].length > 0) {
      retMsg.addAll(parseResp['retMsg']);
    }
    if (fromUnit == null) {
      retMsg.add('Could not find unit $fromName.');
      return retMsg;
    } else {
      List<int>? dimVec;
      final fromDim = fromUnit['dim_'];
      if (fromDim == null) {
        retMsg.add('No commensurable units were found for $fromName');
      } else {
        try {
          dimVec = fromDim['dimVec_'];
        } catch (err) {
          retMsg.add(err.toString());
          if (err.toString() ==
              "Dimension does not have requested property(dimVec_)") {
            dimVec = null;
          }
        }
        if (dimVec != null) {
          final utab = UnitTables.instance;
          commUnits = utab.getUnitsByDimension(dimVec);
        }
      }
    }
    return [commUnits, retMsg];
  }
}

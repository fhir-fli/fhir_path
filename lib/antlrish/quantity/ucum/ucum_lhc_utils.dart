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

  ReturnObject convertUnitTo({
    String? fromUnitCode,
    num? fromVal,
    String? toUnitCode,
    bool suggest = false,
    dynamic molecularWeight,
  }) {
    if (molecularWeight == null) molecularWeight = null;

    ReturnObject returnObj =
        ReturnObject(status: UnitGetStatus.failed, units: [], msg: []);

    if (fromUnitCode != null) {
      fromUnitCode = fromUnitCode.trim();
    }

    if (fromUnitCode == null || fromUnitCode.isEmpty) {
      returnObj = returnObj.copyWith(
        status: UnitGetStatus.error,
        msg: ['No "from" unit expression specified.'],
      );
      return returnObj;
    }

    returnObj = _checkFromVal(fromVal, returnObj);

    if (toUnitCode != null) {
      toUnitCode = toUnitCode.trim();
    }

    if (toUnitCode == null || toUnitCode.isEmpty) {
      returnObj = returnObj.copyWith(
        status: UnitGetStatus.error,
        msg: ['No "to" unit expression specified.'],
      );
      return returnObj;
    }

    if (returnObj.status != UnitGetStatus.error) {
      try {
        UcumUnit? fromUnit = null;

        var parseResp = getSpecifiedUnit(fromUnitCode, 'convert', suggest);

        fromUnit = parseResp.units.first;

        if (parseResp['retMsg'] != null) {
          returnObj['msg'].addAll(parseResp['retMsg']);
        }

        if (parseResp['suggestions'] != null) {
          returnObj['suggestions'] = {};
          returnObj['suggestions']['from'] = parseResp['suggestions'];
        }

        var toUnit = null;
        parseResp = getSpecifiedUnit(toUnitCode, 'convert', suggest);
        toUnit = parseResp['unit'];

        if (parseResp['retMsg'] != null) {
          returnObj['msg'].addAll(parseResp['retMsg']);
        }

        if (parseResp['suggestions'] != null) {
          if (returnObj['suggestions'] == null) returnObj['suggestions'] = {};
          returnObj['suggestions']['to'] = parseResp['suggestions'];
        }

        if (toUnit == null) {
          returnObj['msg'].add(
            'Unable to find a unit for $toUnitCode, so no conversion could be performed.',
          );
        }

        if (toUnit != null) {
          try {
            if (molecularWeight == null) {
              returnObj['toVal'] = toUnit.convertFrom(fromVal, fromUnit);
            } else {
              if (fromUnit.moleExp_ != 0 && toUnit.moleExp_ != 0) {
                throw (Exception(
                    'A molecular weight was specified but a mass <-> mole conversion cannot be executed for two mole-based units. No conversion was attempted.'));
              }

              if (fromUnit.moleExp_ == 0 && toUnit.moleExp_ == 0) {
                throw (Exception(
                    'A molecular weight was specified but a mass <-> mole conversion cannot be executed when neither unit is mole-based. No conversion was attempted.'));
              }

              if (!fromUnit.isMoleMassCommensurable(toUnit)) {
                throw (Exception(
                    'Sorry. $fromUnitCode cannot be converted to $toUnitCode.'));
              }

              if (fromUnit.moleExp_ != 0) {
                returnObj['toVal'] =
                    fromUnit.convertMolToMass(fromVal, toUnit, molecularWeight);
              } else {
                returnObj['toVal'] =
                    fromUnit.convertMassToMol(fromVal, toUnit, molecularWeight);
              }
            }

            returnObj['status'] = 'succeeded';
            returnObj['fromUnit'] = fromUnit;
            returnObj['toUnit'] = toUnit;
          } catch (e) {
            returnObj['status'] = 'failed';
            returnObj['msg'].add(e.toString());
          }
        }
      } catch (e) {
        if (e.toString() == UcumConfig.needMoleWeightMsg_) {
          returnObj['status'] = 'failed';
        } else {
          returnObj['status'] = 'error';
        }
        returnObj['msg'].add(e.toString());
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
        !InternalUtils.isNumericString(fromVal.toString()) ||
        fromVal.isNaN) {
      responseObj = responseObj.copyWith(
        status: UnitGetStatus.error,
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
          status: UnitGetStatus.error,
          msg: ['No term specified for synonym search.'],
          units: <UcumUnit>[])
      : InternalUtils.getSynonyms(theSyn);

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

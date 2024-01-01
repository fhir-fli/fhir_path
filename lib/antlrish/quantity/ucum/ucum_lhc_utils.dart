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
      UcumJsonDefs.instance.loadUcumMinDefs();
    }
  }

  void useHTMLInMessages(bool use) {
    _uStrParser.useHTMLInMessages(use);
  }

  void useBraceMsgForEachString(bool use) {
    _uStrParser.useBraceMsgForEachString(use);
  }

  Map<String, dynamic> convertUnitTo({
    String? fromUnitCode,
    num? fromVal,
    String? toUnitCode,
    bool suggest = false,
    dynamic molecularWeight,
  }) {
    if (molecularWeight == null) molecularWeight = null;

    Map<String, dynamic> returnObj = {
      'status': 'failed',
      'toVal': null,
      'msg': [],
    };

    if (fromUnitCode != null) {
      fromUnitCode = fromUnitCode.trim();
    }

    if (fromUnitCode == null || fromUnitCode.isEmpty) {
      returnObj['status'] = 'error';
      returnObj['msg'].add('No "from" unit expression specified.');
      return returnObj;
    }

    _checkFromVal(fromVal, returnObj);

    if (toUnitCode != null) {
      toUnitCode = toUnitCode.trim();
    }

    if (toUnitCode == null || toUnitCode.isEmpty) {
      returnObj['status'] = 'error';
      returnObj['msg'].add('No "to" unit expression specified.');
      return returnObj;
    }

    if (returnObj['status'] != 'error') {
      try {
        var fromUnit = null;

        var parseResp = getSpecifiedUnit(fromUnitCode, 'convert', suggest);
        fromUnit = parseResp['unit'];

        if (parseResp['retMsg'] != null) {
          returnObj['msg'].addAll(parseResp['retMsg']);
        }

        if (parseResp['suggestions'] != null) {
          returnObj['suggestions'] = {};
          returnObj['suggestions']['from'] = parseResp['suggestions'];
        }

        if (fromUnit == null) {
          returnObj['msg'].add(
            'Unable to find a unit for $fromUnitCode, so no conversion could be performed.',
          );
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

        if (fromUnit != null && toUnit != null) {
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
              UnitTables.instance.dimVecIndexToBaseUnit;
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

  void _checkFromVal(num? fromVal, Map<String, dynamic> responseObj) {
    if (fromVal == null ||
        !isNumericString(fromVal.toString()) ||
        fromVal.isNaN) {
      responseObj['status'] = 'error';
      responseObj['msg'] ??= [];
      responseObj['msg'].add(
          'No "from" value, or an invalid "from" value, ' + 'was specified.');
    }
  }

  // Retrieves units that include a term as a synonym or in their name
  Map<String, dynamic> checkSynonyms(String? theSyn) {
    Map<String, dynamic> retObj = <String, dynamic>{};
    if (theSyn == null) {
      retObj['status'] = 'error';
      retObj['msg'] = 'No term specified for synonym search.';
    } else {
      retObj = getSynonyms(theSyn);
    }
    return retObj;
  }

  Map<String, dynamic> getSpecifiedUnit(
    String uName,
    String valConv, [
    bool suggest = false,
  ]) {
    final retObj = <String, dynamic>{'retMsg': <String>[]};

    if (uName.isEmpty) {
      retObj['retMsg'].add('No unit string specified.');
    } else {
      final utab = UnitTables.instance;
      uName = uName.trim();
      print('uName: $uName');

      // Try using the name as the code
      final theUnit = utab.getUnitByCode(uName);

      if (theUnit != null) {
        retObj['unit'] = theUnit;
        retObj['origString'] = uName;
      } else {
        try {
          final resp = UnitString.instance.parseString(uName, valConv, suggest);
          retObj['unit'] = resp[0];
          retObj['origString'] = resp[1];
          retObj['retMsg'] = resp[2];
          retObj['suggestions'] = resp[3];
        } catch (err) {
          print('Unit requested for unit string $uName. ' +
              'Request unsuccessful; error thrown = ${err.toString()}');
          retObj['retMsg']
              .insert(0, '$uName is not a valid unit. ${err.toString()}');
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
          // commUnits = utab.getUnitsByDimension(dimVec);
        }
      }
    }
    return [commUnits, retMsg];
  }
}

import 'dart:math' as Math;
import 'ucum_pkg.dart';

class UnitString {
  // Get instances of the unit and prefix tables and the utilities
  final UnitTables utabs_ = UnitTables.instance;
  final PrefixTables pfxTabs_ = PrefixTables.instance;
  final String openEmph_ = UcumConfig.openEmph_;
  final String closeEmph_ = UcumConfig.closeEmph_;
  String bracesMsg_ = '';
  final String parensFlag_ = 'parens_placeholder';
  int pFlagLen = 0;
  final String braceFlag_ = 'braces_placeholder';
  int bFlagLen_ = 0;
  String? vcMsgStart_;
  String? vcMsgEnd_;
  List<String> retMsg_ = [];
  List<UcumUnit> parensUnits_ = [];
  List<String> annotations_ = [];
  List<Suggestion>? suggestions_ = [];

  // Static properties in Dart can be managed using static variables or singletons.
  static final String INVALID_ANNOTATION_CHAR_MSG =
      'An invalid character was found in the annotation ';
  static final RegExp VALID_ANNOTATION_REGEX = RegExp(r'^\{[!-z|~]*\}$');

  // Dart constructor
  UnitString({
    bracesMsg_ = '',
    required pFlagLen,
    required bFlagLen_,
    vcMsgStart_,
    vcMsgEnd_,
    List<String>? retMsg,
    List<UcumUnit>? parensUnits,
    List<String>? annotations,
    List<Suggestion>? suggestions,
  })  : retMsg_ = retMsg ?? [],
        parensUnits_ = parensUnits ?? <UcumUnit>[],
        annotations_ = annotations ?? <String>[],
        suggestions_ = suggestions ?? <Suggestion>[];

  static UnitString get instance => _instance;

  static final UnitString _instance = UnitString._();

  UnitString._();

  void useHTMLInMessages(bool use) {
    if (use) {
    } else {}
  }

  void useBraceMsgForEachString(bool use) {
    if (use) {
      bracesMsg_ = UcumConfig.bracesMsg_;
    } else {
      bracesMsg_ = '';
    }
  }

  /// Parses a unit string, returns a unit, a possibly updated version of
  /// the string passed in, and messages and suggestions where appropriate.
  ///
  /// The string returned may be updated if the input string contained unit
  /// names, e.g., "pound".  The unit code ([lb_av] for pound) is placed in
  /// the string returned, a the returned messages array includes a note
  /// explaining the substitution.
  ReturnObject parseString(String uStr, String? valConv, bool? suggest) {
    uStr = uStr.trim(); // Make sure we have something to work with

    if (uStr.isEmpty) {
      throw Exception('Please specify a unit expression to be validated.');
    }

    if (valConv == 'validate') {
      vcMsgStart_ = UcumConfig.valMsgStart_;
      vcMsgEnd_ = UcumConfig.valMsgEnd_;
    } else {
      vcMsgStart_ = UcumConfig.cnvMsgStart_;
      vcMsgEnd_ = UcumConfig.cnvMsgEnd_;
    }

    if (suggest == false) {
      suggestions_ = null;
    } else {
      suggestions_ = [];
    }

    retMsg_ = [];
    parensUnits_ = [];
    annotations_ = [];
    String origString = uStr;
    ReturnObject retObj = ReturnObject.empty();

    /// Extract any annotations, i.e., text enclosed in braces ({}) from the
    /// string before further processing.  Store each one in annotations_
    /// array and put a placeholder in the string for the annotation.  Do
    /// this before other processing in case an annotation contains characters
    /// that will be interpreted as parenthetical markers or operators in
    /// subsequent processing.

    uStr = _getAnnotations(uStr);

    if (retMsg_.isNotEmpty) {
      retObj = retObj.copyWith(
          units: retObj.units == null
              ? []
              : retObj.units!.length < 3
                  ? []
                  : retObj.units!.sublist(2));
    } else {
      /// First check for one of the "special" units.  If it's one of those, put
      /// in a substitution phrase for it to avoid having it separated on its
      /// embedded operator.  This will only happen, by the way, if it is
      /// preceded by a prefix or followed by an operator and another unit.
      for (var sUnit in UcumConfig.specUnits_.keys) {
        while (uStr.contains(sUnit) && UcumConfig.specUnits_[sUnit] != null) {
          uStr.replaceFirst(sUnit, UcumConfig.specUnits_[sUnit]!);
        }
      }

      // Check for spaces and throw an error if any are found.  The spec
      // explicitly forbids spaces except in annotations, which is why any
      // annotations are extracted before this check is made.
      if (uStr.contains(' ')) {
        throw Exception('Blank spaces are not allowed in unit expressions.');
      }

      // assign the array returned to retObj.  It will contain 2 elements:
      //  the unit returned in position 0; and the origString (possibly
      //  modified) in position 1.  The origString in position 1 will not
      //  be changed by subsequent processing.
      final parsedString = _parseTheString(uStr, origString);
      if (parsedString.unit != null) {
        retObj = retObj.copyWith(
          units: [
            if (retObj.units?.isNotEmpty ?? false) retObj.units!.first,
            parsedString.unit!
          ],
          origString: parsedString.mag,
        );
      }

      UcumUnit? finalUnit = retObj.units?.first;

      // Do a final check to make sure that finalUnit is a unit and not
      // just a number.  Something like "8/{HCP}" will return a "unit" of 8
      // - which is not a unit.  Hm - evidently it is.  So just create a unit
      // object for it.
      if (finalUnit?.property_ != null &&
              UcumUtils.isIntegerUnit(finalUnit!.property_) ||
          finalUnit is num) {
        finalUnit = UcumUnit.namedConstructor(
            csCode_: origString,
            ciCode_: origString,
            magnitude_: finalUnit,
            name_: origString);
        if (retObj.units != null) {
          retObj = retObj.copyWith(units: [
            finalUnit,
            if (retObj.units!.isNotEmpty) ...retObj.units!.sublist(1)
          ]);
        }
      }
    }

    retObj = retObj.copyWith(
        retMsg: [if (retObj.retMsg != null) ...retObj.retMsg!, ...retMsg_]);
    if (suggestions_ != null && suggestions_!.isNotEmpty) {
      retObj = retObj.copyWith(suggestions: [
        if (retObj.suggestions != null) ...retObj.suggestions!,
        ...suggestions_!
      ]);
    }

    return retObj;
  }

  UnitEntry _parseTheString(String uStr, String origString) {
    UcumUnit? finalUnit;
    var endProcessing = retMsg_.length > 0;

    var parensResp = _processParens(uStr, origString);
    endProcessing = parensResp[2];

    var uArray = <Map<String, dynamic>>[];

    if (!endProcessing) {
      uStr = parensResp[0];
      origString = parensResp[1];

      var mkUArray = _makeUnitsArray(uStr, origString);

      endProcessing = mkUArray[2];
      if (!endProcessing) {
        uArray = mkUArray[0];
        origString = mkUArray[1];

        for (var u1 = 0; u1 < uArray.length; u1++) {
          var curCode = uArray[u1]['un'];

          if (UcumUtils.isIntegerUnit(curCode)) {
            uArray[u1]['un'] = int.parse(curCode);
          } else {
            if (curCode.contains(parensFlag_)) {
              var parenUnit = getParensUnit(curCode, origString);
              if (!endProcessing) endProcessing = parenUnit[1];

              if (!endProcessing) {
                uArray[u1]['un'] = parenUnit[0];
              }
            } else {
              var uRet = _makeUnit(curCode, origString);
              if (uRet[0] == null) {
                endProcessing = true;
              } else {
                uArray[u1]['un'] = uRet[0];
                origString = uRet[1];
              }
            }
          }
        }
      }
    }

    if (!endProcessing) {
      if ((uArray.isEmpty || uArray[0]['un'] == null) && retMsg_.isEmpty) {
        retMsg_.add(
            'Unit string ($origString) did not contain anything that could be used to create a unit, or else something that is not handled yet by this package. Sorry');
        endProcessing = true;
      }
    }

    if (!endProcessing) {
      finalUnit = _performUnitArithmetic(uArray, origString);
    }

    return UnitEntry(origString, finalUnit);
  }

  String _getAnnotations(String uString) {
    int openBrace = uString.indexOf('{');

    while (openBrace >= 0) {
      int closeBrace = uString.indexOf('}', openBrace);

      if (closeBrace < 0) {
        retMsg_.add('Missing closing brace for annotation starting at ' +
            openEmph_ +
            uString.substring(openBrace) +
            closeEmph_);
        openBrace = -1;
      } else {
        String braceStr = uString.substring(openBrace, closeBrace + 1);

        // Check for valid characters in the annotation.
        // Adapt this part based on how you handle regular expressions in Dart.
        if (!isValidAnnotation(braceStr)) {
          retMsg_.add(UnitString.INVALID_ANNOTATION_CHAR_MSG +
              openEmph_ +
              braceStr +
              closeEmph_);
          openBrace = -1;
        } else {
          String aIdx = annotations_.length.toString();
          uString =
              uString.replaceFirst(braceStr, braceFlag_ + aIdx + braceFlag_);
          annotations_.add(braceStr);
          openBrace = uString.indexOf('{');
        }
      }
    }

    // Check for a stray/unmatched closing brace
    if (retMsg_.isEmpty) {
      int closeBrace = uString.indexOf('}');
      if (closeBrace >= 0) {
        retMsg_.add('Missing opening brace for closing brace found at ' +
            openEmph_ +
            uString.substring(0, closeBrace + 1) +
            closeEmph_);
      }
    }

    return uString;
  }

  /// Finds and processes any/all parenthesized unit strings. This should only
  /// be called from within this class (or by test code).
  ///
  /// Nested parenthesized strings are processed from the inside out.  The
  /// parseString function is called from within this one for each parenthesized
  /// unit string, and the resulting unit object is stored in parensUnits_,
  /// to be processed after all strings are translated to units.
  ///
  /// A placeholder is placed in the unit string returned to indicate that the
  /// unit object should be obtained from the parensUnits_ array.  The
  /// placeholder consists of the parenthesis flag (parensFlag_) followed
  /// by the index of the unit in parensUnits_ followed by parensFlag_.
  List<dynamic> _processParens(String uString, String origString) {
    List<String> uStrArray = [];
    // int uStrAryPos = 0;
    bool stopProcessing = false;
    int pu = parensUnits_.length;

    int trimmedCt = 0;

    while (uString.isNotEmpty && !stopProcessing) {
      int openCt = 0;
      int closeCt = 0;
      int openPos = uString.indexOf('(');

      if (openPos < 0) {
        int closePos = uString.indexOf(')');

        if (closePos >= 0) {
          String theMsg =
              'Missing open parenthesis for close parenthesis at ${uString.substring(0, closePos + trimmedCt)}${openEmph_}${uString[closePos]}${closeEmph_}';

          if (closePos < uString.length - 1) {
            theMsg += uString.substring(closePos + 1);
          }

          retMsg_.add(theMsg);
          uStrArray.add(uString);
          stopProcessing = true;
        } else {
          uStrArray.add(uString);
          uString = "";
        }
      } else {
        openCt++;
        if (openPos > 0) {
          uStrArray.add(uString.substring(0, openPos));
          // uStrAryPos++;
        }

        int closePos = 0;
        for (int c = openPos + 1;
            c < uString.length && openCt != closeCt;
            c++) {
          if (uString[c] == '(')
            openCt++;
          else if (uString[c] == ')') closeCt++;
        }

        if (openCt == closeCt) {
          closePos = openPos + 1;
          uStrArray.add('${parensFlag_}$pu${parensFlag_}');

          UnitEntry parseResp = _parseTheString(
              uString.substring(openPos + 1, closePos - 1), origString);

          if (parseResp.unit == null) {
            stopProcessing = true;
          } else {
            origString = parseResp.mag ?? origString;
            if (parseResp.unit != null) {
              parensUnits_.add(parseResp.unit!);
            }
            uString = uString.substring(closePos);
            trimmedCt = closePos;
            pu++;
          }
        } else {
          uStrArray.add(origString.substring(openPos));
          retMsg_.add(
              'Missing close parenthesis for open parenthesis at ${origString.substring(0, openPos + trimmedCt)}${openEmph_}${origString[openPos]}${closeEmph_}${origString.substring(openPos + 1)}');
          stopProcessing = true;
        }
      }
    }

    if (stopProcessing) {
      parensUnits_ = [];
    }
    return [uStrArray.join(''), origString, stopProcessing];
  }

  List<dynamic> _makeUnitsArray(String uStr, String origString) {
    bool endProcessing = false;
    List<dynamic> uArray = [];
    RegExp startNumCheck = RegExp(r'(^[0-9]+)(\[?[a-zA-Z\_0-9a-zA-Z\_]+\]?$)');

    List<String> uArray1 = uStr.split(RegExp(r'([./]|[^./]+)'));
    uArray1.removeWhere(
        (item) => item.isEmpty); // Remove empty strings from the list

    if (uArray1.isNotEmpty && uArray1[0] == '/') {
      uArray1.insert(0, '1');
    } else if (uArray1.isNotEmpty && uArray1[0] == '.') {
      retMsg_.add('$origString is not a valid UCUM code. '
          'The multiplication operator at the beginning of the expression is '
          'not valid. A multiplication operator must appear only between '
          'two codes.');
      endProcessing = true;
    }

    // ... (Continuing the translation of the logic)
    // Note: Dart has different ways to handle regular expressions and string processing.
    // You will need to adapt the rest of the JavaScript logic to Dart accordingly.

    // Return the result
    return [uArray, origString, endProcessing];
  }

  // Helper method to check valid annotation (adapt as needed)
  bool isValidAnnotation(String annotation) {
    // Implement the regular expression check here.
    // Example: return RegExp(r"your_regex_pattern").hasMatch(annotation);
    return true; // Replace this with actual implementation
  }

  List<dynamic> getParensUnit(String pStr, String origString) {
    bool endProcessing = false;
    dynamic retUnit;
    String befAnnoText;
    String aftAnnoText;

    int psIdx = pStr.indexOf(parensFlag_);
    String befText;
    if (psIdx > 0) {
      befText = pStr.substring(0, psIdx);
    }
    int peIdx = pStr.lastIndexOf(parensFlag_);
    String aftText;
    if (peIdx + pFlagLen < pStr.length) {
      aftText = pStr.substring(peIdx + pFlagLen);
    }

    String pNumText = pStr.substring(psIdx + pFlagLen, peIdx);

    if (UcumUtils.isNumericString(pNumText)) {
      retUnit = parensUnits_[int.parse(pNumText)];
      pStr = retUnit is int ? retUnit.toString() : retUnit.csCode;
    } else {
      throw Exception(
          'Processing error - invalid parens number $pNumText found in $pStr.');
    }

    // Process befText and aftText...

    // Note: The JavaScript code has complex logic for handling annotations,
    // numbers, exponents, and errors/warnings, which need to be translated
    // similarly in Dart.

    // Further processing to handle befText and aftText goes here...

    if (!endProcessing) {
      // Logic to handle the case when retUnit is not set or needs further processing
    }

    return [retUnit, endProcessing];
  }

  AnnotatedText _getAnnoText(String pStr, String origString) {
    int asIdx = pStr.indexOf(braceFlag_);
    String? startText = asIdx > 0 ? pStr.substring(0, asIdx) : null;
    if (asIdx != 0) {
      pStr = pStr.substring(asIdx);
    }

    int aeIdx = pStr.indexOf(braceFlag_, 1);
    String? endText = aeIdx + bFlagLen_ < pStr.length
        ? pStr.substring(aeIdx + bFlagLen_)
        : null;

    String idx = pStr.substring(bFlagLen_, aeIdx);
    int idxNum;
    try {
      idxNum = int.parse(idx);
    } catch (e) {
      throw Exception(
          'Processing Error - invalid annotation index $idx found in $pStr that was created from $origString');
    }

    if (idxNum >= annotations_.length) {
      throw Exception(
          'Processing Error - invalid annotation index $idx found in $pStr that was created from $origString');
    }

    pStr = annotations_[idxNum];
    return AnnotatedText(pStr, startText, endText);
  }

  /// Takes a unit string and looks for suggested units. This should be
  /// called for unit strings that cannot be resolved to unit codes. The
  /// string is searched for in the synonyms table found in the UnitTables
  /// class. That table includes all synonyms and unit names for the units
  /// in the unit data table.
  ///
  /// @param pStr the string being parsed
  /// @returns a string that indicates the status of the request:
  ///   'succeeded' indicates that synonyms were found;
  ///   'failed' indicates that no synonyms were found; or
  ///   'error' which indicates that an error occurred
  ///
  /// The `retMsg_` array will be updated with a message indicating whether
  /// or not synonyms/suggestions were found.
  /// The `suggestions_` array will be updated with a hash (added to the
  /// array if it already contains others) that contains three elements:
  ///   'msg' which is a message indicating what unit expression the
  ///      suggestions are for;
  ///   'invalidUnit' which is the unit expression the suggestions are for; and
  ///   'units' which is an array of data for each suggested unit found.
  ///       Each array will contain the unit code, the unit name and the
  ///       unit guidance (if any).
  ReturnStatus _getSuggestions(String pStr) {
    ReturnObject retObj = UcumUtils.getSynonyms(pStr);
    if (retObj.status == ReturnStatus.succeeded) {
      ReturnObject suggSet = ReturnObject(
        status: ReturnStatus.initialized,
        msg: [
          "$pStr is not a valid UCUM code. We found possible " +
              "units that might be what was meant:"
        ],
        invalidUnit: pStr,
        units: const <UcumUnit>[],
      );
      for (int s = 0; s < retObj.units.length; s++) {
        suggSet = suggSet.copyWith(
          units: [
            if (suggSet.units.isNotEmpty) ...suggSet.units,
            retObj.units[s],
          ],
        );
      }
      suggestions_ ??= <String>[];
      suggestions_!.addAll(suggSet.units.map((e) => e.csCode_).toList());
    } else {
      this
          .retMsg_
          .add("$pStr is not a valid UCUM code. No alternatives were found.");
    }
    return retObj.status;
  }

  /// Creates a unit object from a string defining one unit.  The string
  /// should consist of a unit code for a unit already defined (base or
  /// otherwise).  It may include a prefix and an exponent, e.g., cm2
  /// (centimeter squared).  This should only be called from within this
  /// class (or by test code).
  List<dynamic> _makeUnit(String uCode, String origString) {
    /// First try the code just as is, without looking for annotations,
    /// prefixes, exponents, or elephants.
    UcumUnit? retUnit = utabs_.getUnitByCode(uCode);
    if (retUnit != null) {
      retUnit = retUnit.clone();
    }

    /// If we found it, we're done.  No need to parse for those elephants (or
    /// other stuff).
    else if (uCode.contains(braceFlag_)) {
      List<dynamic> getAnnoRet = _getUnitWithAnnotation(uCode, origString);
      retUnit = getAnnoRet[0];
      if (retUnit != null) {
        origString = getAnnoRet[1];
      }

      /// If a unit is not found, retUnit will be returned null and
      /// the retMsg_ array will contain a message describing the problem.
      /// If a unit is found, of course, all is good. So ... nothing left
      /// to see here, move along.
    } else {
      /// So we didn't find a unit for the full uCode or for one with
      /// annotations.  Try looking for a unit that uses a carat (^)
      /// instead of an asterisk (*)
      if (uCode.contains('^')) {
        String tryCode = uCode.replaceAll('^', '*');
        retUnit = utabs_.getUnitByCode(tryCode);
        if (retUnit != null) {
          retUnit = retUnit.clone();
          retUnit.csCode_ = retUnit.csCode_.replaceAll('*', '^');
          retUnit.ciCode_ = retUnit.ciCode_.replaceAll('*', '^');
        }
      }

      /// If that didn't work, check to see if it should have brackets
      /// around it (uCode = degF when it should be [degF]
      if (retUnit == null) {
        String addBrackets = '[$uCode]';
        retUnit = utabs_.getUnitByCode(addBrackets);
        if (retUnit != null) {
          retUnit = retUnit.clone();
          origString = origString.replaceAll(uCode, addBrackets);
          // Add a message about the correction
          retMsg_.add(
              "$uCode is not a valid unit expression, but $addBrackets is.\n" +
                  "vcMsgStart_$addBrackets (${retUnit.name_})vcMsgEnd_");
        }
      }

      // Check if the unit can be found by name
      if (retUnit == null) {
        var retUnitAry = utabs_.getUnitByName(uCode);
        if (retUnitAry.isNotEmpty) {
          retUnit = retUnitAry[0].clone();
          String mString = 'The UCUM code for $uCode is ${retUnit.csCode_}.\n' +
              "vcMsgStart_${retUnit.csCode_}vcMsgEnd_";
          if (!retMsg_.contains(mString)) {
            retMsg_.add(mString);
          }
          RegExp rStr = RegExp(r'(^|[.\/({])($uCode)($|[.\/)}])');
          RegExpMatch? res = rStr.firstMatch(origString);
          origString = origString.replaceFirst(
              rStr, '${res?[1]}${retUnit.csCode_}${res?[3]}');
          uCode = retUnit.csCode_;
        }
      }

      /// If we still don't have a unit, try assuming a modifier (prefix and/or
      /// exponent) and look for a unit without the modifier
      if (retUnit == null) {
        // Check for special units first and replace placeholders
        for (var sUnit in UcumConfig.specUnits_.keys) {
          if (UcumConfig.specUnits_[sUnit] != null &&
              uCode.contains(UcumConfig.specUnits_[sUnit]!)) {
            uCode = uCode.replaceAll(UcumConfig.specUnits_[sUnit]!, sUnit);
          }
        }
        retUnit = utabs_.getUnitByCode(uCode);
        if (retUnit != null) {
          retUnit = retUnit.clone();
        }

        /// If still not found, separate out prefix and exponent
        if (retUnit == null) {
          String origCode = uCode;
          UcumUnit? origUnit;
          String? exp;
          String? pfxCode;
          Prefix? pfxObj;
          num? pfxVal;
          int? pfxExp;

          /// Look first for an exponent.  If we got one, separate it out and
          /// try to get the unit again
          var codeAndExp = _isCodeWithExponent(uCode);
          if (codeAndExp != null) {
            uCode = codeAndExp[0];
            exp = codeAndExp[1];
            origUnit = utabs_.getUnitByCode(uCode);
          }

          /// If we still don't have a unit, separate out the prefix, if any,
          /// and try without it.
          if (origUnit == null) {
            pfxCode = uCode[0];
            pfxObj = pfxTabs_.getPrefixByCode(pfxCode);

            /// if we got a prefix, get its info and remove it from the unit code
            if (pfxObj != null) {
              pfxVal = pfxObj.value_;
              pfxExp = pfxObj.exp_;
              uCode = uCode.substring(pfxCode.length);

              /// try again for the unit
              origUnit = utabs_.getUnitByCode(uCode);

              /// If we still don't have a unit, see if the prefix could be the
              /// two character "da" (deka) prefix.  That's the only prefix with
              /// two characters, and without this check it's interpreted as "d"
              /// (deci) and the "a" is considered part of the unit code.
              if (origUnit == null && pfxCode == 'd' && uCode.startsWith('a')) {
                pfxCode = 'da';
                pfxObj = pfxTabs_.getPrefixByCode(pfxCode);
                pfxVal = pfxObj?.value_;
                uCode = uCode.substring(1);

                /// try one more time for the unit
                origUnit = utabs_.getUnitByCode(uCode);
              }

              /// Reject the unit we found if it might have another prefix.
              /// Such things are in our tables through the LOINC source_
              /// (ucum.csv) which has guidance and synonyms.  I think it should be
              /// safe to exclude anything whose source is LOINC from having a
              /// prefix.
              if (origUnit != null && origUnit.source_ == 'LOINC') {
                origUnit = null;
              }
            }
          }

          /// If we still haven't found anything, we're done looking.
          /// (We tried with the full unit string, with the unit string
          /// without the exponent, the unit string without a prefix,
          /// common errors, etc. That's all we can try).
          if (origUnit == null) {
            retUnit = null;

            /// BUT if the user asked for suggestions, at least look for them
            if (suggestions_ != null) {
              // final suggestStat = _getSuggestions(origCode);
            } else {
              retMsg_.add('$origCode is not a valid UCUM code.');
            }
          } else {
            /// Otherwise we found a unit object.  Clone it and then apply the
            /// prefix and exponent, if any, to it.  And remove the guidance.
            retUnit = origUnit.clone();

            /// If we are here, this is only part of the full unit string, so
            /// it is not a base unit, and the synonyms will mostly likely not
            /// be correct for the full string.
            retUnit.resetFieldsForDerivedUnit();
            final Dimension? theDim = retUnit.dim_;
            var theMag = retUnit.magnitude_;
            String theName = retUnit.name_;
            String theCiCode = retUnit.ciCode_;
            String? thePrintSymbol = retUnit.printSymbol_;

            /// If there is an exponent for the unit, apply it to the dimension
            /// and magnitude now
            if (exp != null) {
              int? expMul = int.tryParse(exp);
              if (expMul != null) {
                if (theDim != null) {
                  theDim.mul(expMul);
                }
                theMag = Math.pow(theMag, expMul);
                retUnit.magnitude_ = theMag;

                // If there is also a prefix, apply the exponent to the prefix.
                if (pfxObj?.exp_ != null) {
                  // if the prefix base is 10 it will have an exponent. Multiply
                  // the current prefix exponent by the exponent for the unit
                  // we're working with. Then raise the prefix value to the level
                  // defined by the exponent.
                  if (pfxExp != null) {
                    expMul *= pfxObj!.exp_!;
                    pfxVal = Math.pow(10, expMul);
                  }
                  // If the prefix base is not 10, it won't have an exponent.
                  // Currently, there are no units using prefixes that aren't base 10.
                  // But if we encounter one, the prefix value will be applied to the magnitude
                  // if the unit does not have a conversion function, and to the conversion prefix
                  // if it does.
                }
              }
            }

            // Now apply the prefix, if there is one, to the conversion
            // prefix or the magnitude
            if (pfxObj != null && pfxVal != null) {
              if (retUnit.cnv_ != null) {
                retUnit.cnvPfx_ = pfxVal;
              } else {
                theMag *= pfxVal;
                retUnit.magnitude_ = theMag;
              }
            }
            // if we have a prefix and/or an exponent, add them to the unit
            // attributes - name, csCode, ciCode, and print symbol
            String theCode = retUnit.csCode_;
            if (pfxObj != null) {
              theName = '${pfxObj.name_}$theName';
              theCode = '${pfxCode ?? ""}$theCode';
              theCiCode = '${pfxObj.ciCode_ ?? ""}$theCiCode';
              thePrintSymbol = '${pfxObj.printSymbol_ ?? ""}$thePrintSymbol';
              retUnit
                ..name_ = theName
                ..csCode_ = theCode
                ..ciCode_ = theCiCode
                ..printSymbol_ = thePrintSymbol;
            }

            if (exp != null) {
              String expStr = exp.toString();
              retUnit
                ..name_ = '$theName<sup>$expStr</sup>'
                ..csCode_ = '$theCode$expStr'
                ..ciCode_ = '$theCiCode$expStr'
                ..printSymbol_ = '$thePrintSymbol<sup>$expStr</sup>';
            }
          }
        }
      }
    }
    return [retUnit, origString];
  }

  /// This method handles unit creation when an annotation is included
  /// in the unit string.  This basically isolates and retrieves the
  /// annotation and then calls _makeUnit to try to get a unit from
  /// any text that precedes or follows the annotation.
  List<dynamic> _getUnitWithAnnotation(String uCode, String origString) {
    UcumUnit? retUnit;

    AnnotatedText annoRet = _getAnnoText(uCode, origString);
    String annoText = annoRet.pStr;
    String? befAnnoText = annoRet.startText;
    String? aftAnnoText = annoRet.endText;

    if (bracesMsg_.isNotEmpty && !retMsg_.contains(bracesMsg_)) {
      retMsg_.add(bracesMsg_);
    }

    if (befAnnoText == null && aftAnnoText == null) {
      var tryBrackets = '[' + annoText.substring(1, annoText.length - 1) + ']';
      var mkUnitRet = _makeUnit(tryBrackets, origString);

      if (mkUnitRet[0] != null) {
        retUnit = UcumUnit.namedConstructor(
            csCode_: uCode, ciCode_: uCode, magnitude_: 1, name_: uCode);
        retMsg_.add(
            '$annoText is a valid unit expression, but did you mean $tryBrackets (${mkUnitRet[0].name_})?');
      } else {
        if (retMsg_.length > retMsg_.indexOf(bracesMsg_) + 1) {
          retMsg_.removeLast();
        }
        retUnit = UcumUnit.namedConstructor(
            csCode_: annoText,
            ciCode_: annoText,
            magnitude_: 1,
            name_: annoText);
      }
    } else if (befAnnoText != null && aftAnnoText == null) {
      if (UcumUtils.isIntegerUnit(befAnnoText)) {
        retUnit = UcumUnit.namedConstructor();
        retUnit.magnitude_ = befAnnoText;
      } else {
        var mkUnitRet = _makeUnit(befAnnoText, origString);
        if (mkUnitRet[0] != null) {
          retUnit = mkUnitRet[0];
          if (retUnit == null) {
            retUnit = UcumUnit.namedConstructor();
          }
          retUnit.csCode_ += annoText;
          origString = mkUnitRet[1];
        } else {
          retMsg_.add(
              'Unable to find a unit for $befAnnoText that precedes the annotation $annoText.');
        }
      }
    } else if (befAnnoText == null && aftAnnoText != null) {
      if (UcumUtils.isIntegerUnit(aftAnnoText)) {
        retUnit = UcumUnit.namedConstructor();
        retUnit.name_ = '$aftAnnoText$annoText';
        retMsg_.add(
            'The annotation $annoText before the $aftAnnoText is invalid. $vcMsgStart_$retUnit$vcMsgEnd_');
      } else {
        var mkUnitRet = _makeUnit(aftAnnoText, origString);
        if (mkUnitRet[0] != null) {
          retUnit = mkUnitRet[0] as UcumUnit?;
          if (retUnit == null) {
            retUnit = UcumUnit.namedConstructor();
          }
          retUnit.csCode_ += annoText;
          origString = retUnit.csCode_;
          retMsg_.add(
              'The annotation $annoText before the unit code is invalid. $vcMsgStart_$retUnit.csCode_$vcMsgEnd_');
        } else {
          retMsg_.add(
              'Unable to find a unit for $aftAnnoText that follows the annotation $annoText.');
        }
      }
    } else {
      retMsg_.add(
          'Unable to find a unit for $befAnnoText$annoText$aftAnnoText. We are not sure how to interpret text both before and after the annotation. Sorry');
    }

    return [retUnit, origString];
  }

  /// Performs unit arithmetic for the units in the units array.  That array
  /// contains units/numbers and the operators (division or multiplication) to
  /// be performed on each unit/unit or unit/number pair in the array.  This
  /// should only be called from within this class (or by test code).
  UcumUnit? _performUnitArithmetic(
      List<Map<String, dynamic>> uArray, String origString) {
    dynamic finalUnit = uArray[0]['un'];
    if (UcumUtils.isIntegerUnit(finalUnit)) {
      finalUnit = UcumUnit.namedConstructor(
          csCode_: finalUnit,
          ciCode_: finalUnit,
          magnitude_: finalUnit,
          name_: finalUnit);
    }

    int uLen = uArray.length;
    bool endProcessing = false;

    for (int u2 = 1; u2 < uLen && !endProcessing; u2++) {
      dynamic nextUnit = uArray[u2]['un'];
      if (UcumUtils.isIntegerUnit(nextUnit)) {
        nextUnit = UcumUnit.namedConstructor(
            csCode_: nextUnit,
            ciCode_: nextUnit,
            magnitude_: nextUnit,
            name_: nextUnit);
      }

      if (nextUnit == null || (nextUnit is! UcumUnit)) {
        String msgString =
            'Unit string ($origString) contains unrecognized element';
        if (nextUnit != null) {
          msgString += ' ($nextUnit)';
        }
        msgString += '; could not parse full string. Sorry';
        retMsg_.add(msgString);
        endProcessing = true;
      } else {
        try {
          String thisOp = uArray[u2]['op'];
          bool isDiv = thisOp == '/';

          finalUnit = isDiv
              ? finalUnit.divide(nextUnit)
              : finalUnit.multiplyThese(nextUnit);
        } catch (err) {
          retMsg_.insert(0, err.toString());
          endProcessing = true;
          finalUnit = null;
        }
      }
    }

    return finalUnit;
  }

  /// This tests a string to see if it starts with characters and ends with
  /// digits.  This is used to test for an exponent on a UCUM code (or what
  /// we think might be a UCUM code).  This is broken out to a separate
  /// function so that the regular expression can be verified to provide the
  /// results we expect, in case someone changes it.  (Per Paul Lynch)
  /// See "Test _isCodeWithExponent method" in testUnitString.spec.js
  ///
  /// This particular regex has been tweaked several times.  This one
  /// works with the following test strings:
  /// "m[H2O]-21 gives ["m[H2O]-21", "m[H2O]", "-21"]
  /// "m[H2O]+21 gives ["m[H2O]+21", "m[H2O]", "+21"]
  /// "m[H2O]21 gives ["m[H2O]-21", "m[H2O]", "21"]
  /// "s2" gives ["s2", "s, "2"]
  /// "kg" gives null
  /// "m[H2O]" gives null
  /// "m[H2O]23X" gives null
  List<String>? _isCodeWithExponent(String uCode) {
    RegExp exp = RegExp(r'(^[^\-\+]+?)([\-\+\d]+)$');
    RegExpMatch? match = exp.firstMatch(uCode);

    // If there is a match and it has the expected groups, separate the exponent
    // from the unit and return both as separate values
    if (match != null && match.groupCount >= 2) {
      String? mainPart = match.group(1);
      String? exponentPart = match.group(2);

      if (exponentPart != null && exponentPart.isNotEmpty) {
        return [mainPart ?? '', exponentPart];
      }
    }
    return null;
  }
}

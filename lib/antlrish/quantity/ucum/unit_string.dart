import 'ucum_pkg.dart';

class UnitString {
  // Dart doesn't support private properties in the same way as JavaScript,
  // so we'll use underscores to denote private properties.
  late UnitTables utabs;
  late PrefixTables pfxTabs;
  late String openEmph_;
  late String closeEmph_;
  late String bracesMsg;
  late String parensFlag_;
  int pFlagLen = 0;
  late String braceFlag_;
  int bFlagLen = 0;
  late String vcMsgStart_;
  late String vcMsgEnd_;
  List<String> retMsg_ = [];
  List<UcumUnit> parensUnits_ = [];
  List<String> annotations_ = [];
  List<String>? suggestions_ = [];

  // Static properties in Dart can be managed using static variables or singletons.
  static final String INVALID_ANNOTATION_CHAR_MSG =
      'An invalid character was found in the annotation ';
  static final RegExp VALID_ANNOTATION_REGEX = RegExp(r'^\{[!-z|~]*\}$');

  // Dart constructor
  UnitString()
      :
        // Initialize the properties
        utabs = UnitTables.instance,
        pfxTabs = PrefixTables.instance,
        openEmph_ = '...', // Set appropriate values
        closeEmph_ = '...', // Set appropriate values
        bracesMsg = '',
        parensFlag_ = "parens_placeholder",
        // pFlagLen = parensFlag.length,
        braceFlag_ = "braces_placeholder",
        // bFlagLen = braceFlag.length,
        vcMsgStart_ = '...', // Set appropriate values
        vcMsgEnd_ = '...'; // Set appropriate values

  static UnitString get instance => _instance;

  static final UnitString _instance = UnitString._();

  UnitString._();

  List<String> parseString(String uStr, String? valConv, bool? suggest) {
    uStr = uStr.trim(); // Make sure we have something to work with

    if (uStr.isEmpty) {
      throw Exception('Please specify a unit expression to be validated.');
    }

    if (valConv == 'validate') {
      this.vcMsgStart_ = UcumConfig
          .valMsgStart_; // Assuming Ucum is a class with these properties
      this.vcMsgEnd_ = UcumConfig.valMsgEnd_;
    } else {
      this.vcMsgStart_ = UcumConfig.cnvMsgStart_;
      this.vcMsgEnd_ = UcumConfig.cnvMsgEnd_;
    }

    if (suggest == false) {
      this.suggestions_ = null;
    } else {
      this.suggestions_ = [];
    }

    this.retMsg_ = [];
    this.parensUnits_ = [];
    this.annotations_ = [];
    String origString = uStr;
    List<String> retObj = [];

    uStr = this._getAnnotations(
        uStr); // Assuming _getAnnotations is another method in this class

    if (this.retMsg_.isNotEmpty) {
      retObj.clear();
    } else {
      bool endProcessing = this.retMsg_.isNotEmpty;

      if (uStr.contains(' ')) {
        throw Exception('Blank spaces are not allowed in unit expressions.');
      }

      retObj = this._parseTheString(
          uStr, origString); // Assuming _parseTheString is another method

      dynamic finalUnit = retObj[0];

      // Assuming intUtils_ is a utility class for integer checks
      if (isIntegerUnit(finalUnit) || finalUnit is num) {
        finalUnit = UcumUnit.namedConstructor(
            csCode_: origString,
            ciCode_: origString,
            magnitude_: finalUnit,
            name_: origString);
        retObj[0] = finalUnit;
      }
    }

    retObj.addAll(this.retMsg_);
    if (this.suggestions_ != null && this.suggestions_!.isNotEmpty) {
      retObj.addAll(this.suggestions_!);
    }

    return retObj;
  }

  List<String> _parseTheString(String uStr, String origString) {
    // Unit to be returned
    dynamic
        finalUnit; // Flag used to block further processing on an unrecoverable error

    bool endProcessing = this.retMsg_.isNotEmpty;

    // Call _processParens to search for and process any/all parenthetical
    // strings in uStr. Units created for parenthetical strings will be
    // stored in the this.parensUnits_ array.
    var parensResp = this._processParens(uStr, origString);

    endProcessing = parensResp[2];

    // The array used to hold the units and their operators.
    List<dynamic> uArray = [];

    // Continue if we didn't hit a problem
    if (!endProcessing) {
      uStr = parensResp[0];
      origString = parensResp[1];

      // Call _makeUnitsArray to convert the string to an array of unit
      // descriptors with operators.
      var mkUArray = this._makeUnitsArray(uStr, origString);

      endProcessing = mkUArray[2];

      if (!endProcessing) {
        uArray = mkUArray[0];
        origString = mkUArray[1];

        // Create a unit object out of each element
        int uLen = uArray.length;

        for (int u1 = 0; u1 < uLen; u1++) {
          dynamic curCode = uArray[u1]['un'];

          // ... (Rest of the logic using Dart syntax and types)
          // Note: The actual implementation would depend on how methods like
          // _makeUnit, _getParensUnit, etc. are defined in Dart.
        }
      }
    }

    // Further processing logic adapted to Dart syntax
    if (!endProcessing) {
      // Process the units (and numbers) to create one final unit object
      // ... (Add logic for this part)
    }

    return [finalUnit, origString];
  }

  String _getAnnotations(String uString) {
    int openBrace = uString.indexOf('{');

    while (openBrace >= 0) {
      int closeBrace = uString.indexOf('}', openBrace);

      if (closeBrace < 0) {
        this.retMsg_.add('Missing closing brace for annotation starting at ' +
            this.openEmph_ +
            uString.substring(openBrace) +
            this.closeEmph_);
        openBrace = -1;
      } else {
        String braceStr = uString.substring(openBrace, closeBrace + 1);

        // Check for valid characters in the annotation.
        // Adapt this part based on how you handle regular expressions in Dart.
        if (!isValidAnnotation(braceStr)) {
          this.retMsg_.add(UnitString.INVALID_ANNOTATION_CHAR_MSG +
              this.openEmph_ +
              braceStr +
              this.closeEmph_);
          openBrace = -1;
        } else {
          String aIdx = this.annotations_.length.toString();
          uString = uString.replaceFirst(
              braceStr, this.braceFlag_ + aIdx + this.braceFlag_);
          this.annotations_.add(braceStr);
          openBrace = uString.indexOf('{');
        }
      }
    }

    // Check for a stray/unmatched closing brace
    if (this.retMsg_.isEmpty) {
      int closeBrace = uString.indexOf('}');
      if (closeBrace >= 0) {
        this.retMsg_.add('Missing opening brace for closing brace found at ' +
            this.openEmph_ +
            uString.substring(0, closeBrace + 1) +
            this.closeEmph_);
      }
    }

    return uString;
  }

  List<dynamic> _processParens(String uString, String origString) {
    List<String> uStrArray = [];
    int uStrAryPos = 0;
    bool stopProcessing = false;
    int pu = this.parensUnits_.length;

    int trimmedCt = 0;

    while (uString.isNotEmpty && !stopProcessing) {
      int openCt = 0;
      int closeCt = 0;
      int openPos = uString.indexOf('(');

      if (openPos < 0) {
        int closePos = uString.indexOf(')');

        if (closePos >= 0) {
          String theMsg =
              'Missing open parenthesis for close parenthesis at ${uString.substring(0, closePos + trimmedCt)}${this.openEmph_}${uString[closePos]}${this.closeEmph_}';

          if (closePos < uString.length - 1) {
            theMsg += uString.substring(closePos + 1);
          }

          this.retMsg_.add(theMsg);
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
          uStrAryPos++;
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
          uStrArray.add('${this.parensFlag_}$pu${this.parensFlag_}');

          List<dynamic> parseResp = this._parseTheString(
              uString.substring(openPos + 1, closePos - 1), origString);

          if (parseResp[0] == null) {
            stopProcessing = true;
          } else {
            origString = parseResp[1];
            this.parensUnits_.add(parseResp[0]);
            uString = uString.substring(closePos);
            trimmedCt = closePos;
            pu++;
          }
        } else {
          uStrArray.add(origString.substring(openPos));
          this.retMsg_.add(
              'Missing close parenthesis for open parenthesis at ${origString.substring(0, openPos + trimmedCt)}${this.openEmph_}${origString[openPos]}${this.closeEmph_}${origString.substring(openPos + 1)}');
          stopProcessing = true;
        }
      }
    }

    if (stopProcessing) {
      this.parensUnits_ = [];
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

  void useHTMLInMessages(bool use) {
    if (use) {
      openEmph_ = '...'; // Set to HTML equivalent
      closeEmph_ = '...'; // Set to HTML equivalent
    } else {
      openEmph_ = '...'; // Set to non-HTML values
      closeEmph_ = '...'; // Set to non-HTML values
    }
  }

  void useBraceMsgForEachString(bool use) {
    if (use) {
      bracesMsg = UcumConfig.bracesMsg_;
    } else {
      this.bracesMsg = '';
    }
  }
}

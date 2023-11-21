import 'ucum.dart';

class UnitString {
  UnitTablesFactory _utabs_;
  PrefixTablesFactory _pfxTabs_;
  String _openEmph_;
  String _closeEmph_;
  String _bracesMsg_;
  String _parensFlag_;
  int _pFlagLen_;
  String _braceFlag_;
  int _bFlagLen_;
  String? _vcMsgStart_;
  String? _vcMsgEnd_;
  List<String> _retMsg_ = [];
  List<Unit> _parensUnits_ = [];
  List<String> _annotations_ = [];
  List<Map<String, dynamic>>? _suggestions;

  static final String INVALID_ANNOTATION_CHAR_MSG =
      'An invalid character was found in the annotation ';
  static final RegExp VALID_ANNOTATION_REGEX = RegExp(r'^\{[!-z|~]*\}$');

  UnitString() {
    _utabs_ = UnitTables.getInstance();
    _pfxTabs_ = PrefixTables.getInstance();
    _openEmph_ = Ucum.openEmph_;
    _closeEmph_ = Ucum.closeEmph_;
    _bracesMsg_ = '';
    _parensFlag_ = 'parens_placeholder';
    _pFlagLen_ = _parensFlag_.length;
    _braceFlag_ = 'braces_placeholder';
    _bFlagLen_ = _braceFlag_.length;
    _vcMsgStart_ = null;
    _vcMsgEnd_ = null;
  }

  void useHTMLInMessages([bool use = true]) {
    if (use) {
      _openEmph_ = Ucum.openEmphHTML_;
      _closeEmph_ = Ucum.closeEmphHTML_;
    } else {
      _openEmph_ = Ucum.openEmph_;
      _closeEmph_ = Ucum.closeEmph_;
    }
  }

  void useBraceMsgForEachString([bool use = true]) {
    _bracesMsg_ = use ? Ucum.bracesMsg_ : '';
  }
}

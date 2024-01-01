// Define the Ucum class
abstract class UcumConfig {
  static const bool caseSensitive_ = true;

  // The number of elements in a Dimension array
  static const int dimLen_ = 7;

  // The characters used as valid operators in a UCUM unit expression
  static const List<String> validOps_ = ['.', '/'];

  // The string used to separate a unit code and unit name
  static const String codeSep_ = ': ';

  // Message text variations for validation methods and conversion methods
  static const String valMsgStart_ = 'Did you mean ';
  static const String valMsgEnd_ = '?';
  static const String cnvMsgStart_ = 'We assumed you meant ';
  static const String cnvMsgEnd_ = '.';

  // Default strings used to emphasize portions of error messages
  static const String openEmph_ = ' ->';
  static const String closeEmph_ = '<- ';

  // HTML tags for emphasizing error messages; in Dart, typically not used for web content
  static const String openEmphHTML_ = ' <span class="emphSpan">';
  static const String closeEmphHTML_ = '</span> ';

  // Message displayed when annotations are included in a unit string
  static const String bracesMsg_ =
      'FYI - annotations (text in curly braces {}) are ignored, '
      'except that an annotation without a leading symbol implies '
      'the default unit 1 (the unity).';

  // Message displayed or returned for specific conversion scenarios
  static const String needMoleWeightMsg_ =
      'Did you wish to convert between mass and moles?  The '
      'molecular weight of the substance represented by the '
      'units is required to perform the conversion.';

  // Hash matching unit column names to names used in a CSV file
  static const Map<String, String> csvCols_ = {
    'case-sensitive code': 'csCode_',
    'LOINC property': 'loincProperty_',
    'name (display)': 'name_',
    'synonyms': 'synonyms_',
    'source': 'source_',
    'category': 'category_',
    'Guidance': 'guidance_'
  };

  // Name of the key column in the CSV file
  static const String inputKey_ = 'case-sensitive code';

  // Special codes with operators within brackets
  static const Map<String, String> specUnits_ = {
    'B[10.nV]': 'specialUnitOne',
    '[m/s2/Hz^(1/2)]': 'specialUnitTwo'
  };
}

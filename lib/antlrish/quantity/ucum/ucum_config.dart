// Define the Ucum class
abstract class UcumConfig {
  static bool caseSensitive = true;

  // The number of elements in a Dimension array
  static int dimLen = 7;

  // The characters used as valid operators in a UCUM unit expression
  static List<String> validOps = ['.', '/'];

  // The string used to separate a unit code and unit name
  static String codeSep_ = ': ';

  // Message text variations for validation methods and conversion methods
  static String valMsgStart_ = 'Did you mean ';
  static String valMsgEnd_ = '?';
  static String cnvMsgStart_ = 'We assumed you meant ';
  static String cnvMsgEnd_ = '.';

  // Default strings used to emphasize portions of error messages
  static String openEmph_ = ' ->';
  static String closeEmph_ = '<- ';

  // HTML tags for emphasizing error messages; in Dart, typically not used for web content
  static String openEmphHTML_ = ' <span class="emphSpan">';
  static String closeEmphHTML_ = '</span> ';

  // Message displayed when annotations are included in a unit string
  static String bracesMsg_ =
      'FYI - annotations (text in curly braces {}) are ignored, '
      'except that an annotation without a leading symbol implies '
      'the default unit 1 (the unity).';

  // Message displayed or returned for specific conversion scenarios
  static String needMoleWeightMsg_ =
      'Did you wish to convert between mass and moles?  The '
      'molecular weight of the substance represented by the '
      'units is required to perform the conversion.';

  // Hash matching unit column names to names used in a CSV file
  static Map<String, String> csvCols = {
    'case-sensitive code': 'csCode_',
    'LOINC property': 'loincProperty_',
    'name (display)': 'name_',
    'synonyms': 'synonyms_',
    'source': 'source_',
    'category': 'category_',
    'Guidance': 'guidance_'
  };

  // Name of the key column in the CSV file
  static String inputKey = 'case-sensitive code';

  // Special codes with operators within brackets
  static Map<String, String> specUnits = {
    'B[10.nV]': 'specialUnitOne',
    '[m/s2/Hz^(1/2)]': 'specialUnitTwo'
  };
}

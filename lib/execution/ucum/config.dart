abstract class Ucum {
  // Flag indicating whether or not we're using case sensitive labels
  // I don't think we need this. I think we're just going with
  // case sensitive, per Clem. Gunther's code has this flag, but I
  // am removing it, at least for now. lm, 6/2016
  static bool caseSensitive_ = true;

  // The number of elements in a Dimension array. Currently this
  // is set as a configuration variable, but when we get to the point
  // of loading the unit definitions from a file, this value will be
  // set from that.
  static int dimLen = 7;

  // The characters used as valid operators in a UCUM unit expression,
  // where '.' is for multiplication and '/' is for division.
  static List<String> validOps = ['.', '/'];

  // The string used to separate a unit code and unit name when they
  // are displayed together
  static String codeSep_ = ': ';

  // Message text variations for validation methods and conversion methods
  static String valMsgStart = 'Did you mean ';
  static String valMsgEnd = '?';
  static String cnvMsgStart = 'We assumed you meant ';
  static String cnvMsgEnd = '.';

  // Default opening string used to emphasize portions of error messages.
  // Used when NOT displaying messages on a web site, i.e., for output
  // from the library methods or to a file.
  static String openEmph_ = ' ->';

  // Default closing string used to emphasize portions of error messages.
  // Used when NOT displaying messages on a web site, i.e., for output
  // from the library methods or to a file.
  static String closeEmph_ = '<- ';

  // Opening HTML used to emphasize portions of error messages. Used when
  // displaying messages on a web site; should be blank when output is
  // to a file.
  static String openEmphHTML_ = ' <span class="emphSpan">';

  // Closing HTML used to emphasize portions of error messages. Used when
  // displaying messages on a web site; should be blank when output is
  // to a file.
  static String closeEmphHTML_ = '</span> ';

  // Message that is displayed when annotations are included in a unit
  // string, to let the user know how they are interpreted.
  static String bracesMsg_ =
      'FYI - annotations (text in curly braces {}) are ignored, ' +
          'except that an annotation without a leading symbol implies ' +
          'the default unit 1 (the unity).';

  // Message that is displayed or returned when a conversion is requested
  // for two units where (only) a mass<->moles conversion is appropriate
  // but no molecular weight was specified.
  static String needMoleWeightMsg =
      'Did you wish to convert between mass and moles? The ' +
          'molecular weight of the substance represented by the ' +
          'units is required to perform the conversion.';

  // Hash that matches unit column names to names used in the csv file
  // that is submitted to the data updater.
  static Map<String, String> csvCols = {
    'case-sensitive code': 'csCode_',
    'LOINC property': 'loincProperty_',
    'name (display)': 'name_',
    'synonyms': 'synonyms_',
    'source': 'source_',
    'category': 'category_',
    'Guidance': 'guidance_'
  };

  // Name of the column in the csv file that serves as the key
  static String inputKey = 'case-sensitive code';

  // Special codes that contain operators within brackets. The operator
  // within these codes causes them to parse incorrectly if they are preceded
  // by a prefix, because the parsing algorithm splits them up on the operator.
  // So we use this object to identify them and substitute placeholders to
  // avoid that.
  static Map<String, String> specUnits = {
    'B[10.nV]': 'specialUnitOne',
    '[m/s2/Hz^(1/2)]': 'specialUnitTwo'
  };
}

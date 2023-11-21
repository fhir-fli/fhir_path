const Map<String, String> numberingSystems = {
  'arab': r'[\u0660-\u0669]',
  'arabext': r'[\u06F0-\u06F9]',
  'bali': r'[\u1B50-\u1B59]',
  'beng': r'[\u09E6-\u09EF]',
  'deva': r'[\u0966-\u096F]',
  'fullwide': r'[\uFF10-\uFF19]',
  'gujr': r'[\u0AE6-\u0AEF]',
  'hanidec': r'[〇|一|二|三|四|五|六|七|八|九]',
  'khmr': r'[\u17E0-\u17E9]',
  'knda': r'[\u0CE6-\u0CEF]',
  'laoo': r'[\u0ED0-\u0ED9]',
  'limb': r'[\u1946-\u194F]',
  'mlym': r'[\u0D66-\u0D6F]',
  'mong': r'[\u1810-\u1819]',
  'mymr': r'[\u1040-\u1049]',
  'orya': r'[\u0B66-\u0B6F]',
  'tamldec': r'[\u0BE6-\u0BEF]',
  'telu': r'[\u0C66-\u0C6F]',
  'thai': r'[\u0E50-\u0E59]',
  'tibt': r'[\u0F20-\u0F29]',
  'latn': r'\d',
};

const Map<String, List<int>> numberingSystemsUTF16 = {
  'arab': [1632, 1641],
  'arabext': [1776, 1785],
  'bali': [6992, 7001],
  'beng': [2534, 2543],
  'deva': [2406, 2415],
  'fullwide': [65296, 65303],
  'gujr': [2790, 2799],
  'khmr': [6112, 6121],
  'knda': [3302, 3311],
  'laoo': [3792, 3801],
  'limb': [6470, 6479],
  'mlym': [3430, 3439],
  'mong': [6160, 6169],
  'mymr': [4160, 4169],
  'orya': [2918, 2927],
  'tamldec': [3046, 3055],
  'telu': [3174, 3183],
  'thai': [3664, 3673],
  'tibt': [3872, 3881],
};

final List<String> hanidecChars =
    numberingSystems['hanidec']?.replaceAll(RegExp(r'[\[|\]]'), '').split('') ??
        [];

int parseDigits(String str) {
  int value = int.tryParse(str) ?? 0;
  if (value == 0) {
    value = 0;

    final String? numberingSystem = numberingSystems['hanidec'];
    final RegExp? regExpNumberingSystem =
        numberingSystem == null ? null : RegExp(numberingSystem);
    for (int i = 0; i < str.length; i++) {
      int code = str.codeUnitAt(i);

      if (regExpNumberingSystem != null &&
          str[i].contains(regExpNumberingSystem)) {
        value += hanidecChars.indexOf(str[i]);
      } else {
        for (var key in numberingSystemsUTF16.keys) {
          final List<int> range = numberingSystemsUTF16[key]!;
          if (code >= range[0] && code <= range[1]) {
            value += code - range[0];
          }
        }
      }
    }
    return int.tryParse(value.toString()) ?? 0;
  } else {
    return value;
  }
}

RegExp digitRegex({String numberingSystem = 'latn', String append = ''}) {
  return RegExp('${numberingSystems[numberingSystem]}$append');
}

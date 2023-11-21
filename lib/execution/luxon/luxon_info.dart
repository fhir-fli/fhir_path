class Info {
  static bool hasDST([zone]) {
    final proto =
        DateTime.now().setZone(zone ?? Settings.defaultZone).set(month: 12);
    return !zone.isUniversal && proto.offset != proto.set(month: 6).offset;
  }

  static bool isValidIANAZone(String zone) {
    return IANAZone.isValidZone(zone);
  }

  static normalizeZone(input) {
    return normalizeZone(input, Settings.defaultZone);
  }

  static int getStartOfWeek({String? locale, dynamic locObj}) {
    return (locObj ?? LuxonLocale.create(locale)).getStartOfWeek();
  }

  static int getMinimumDaysInFirstWeek({String? locale, dynamic locObj}) {
    return (locObj ?? LuxonLocale.create(locale)).getMinDaysInFirstWeek();
  }

  static List<int> getWeekendWeekdays({String? locale, dynamic locObj}) {
    return (locObj ?? LuxonLocale.create(locale)).getWeekendDays().toList();
  }

  static List<String> months(
      [String length = 'long',
      String? locale,
      String? numberingSystem,
      dynamic locObj,
      String outputCalendar = 'gregory']) {
    return (locObj ??
            LuxonLocale.create(locale, numberingSystem, outputCalendar))
        .months(length);
  }

  static List<String> monthsFormat(
      [String length = 'long',
      String? locale,
      String? numberingSystem,
      dynamic locObj,
      String outputCalendar = 'gregory']) {
    return (locObj ??
            LuxonLocale.create(locale, numberingSystem, outputCalendar))
        .months(length, true);
  }

  static List<String> weekdays(
      [String length = 'long',
      String? locale,
      String? numberingSystem,
      dynamic locObj]) {
    return (locObj ?? LuxonLocale.create(locale, numberingSystem, null))
        .weekdays(length);
  }

  static List<String> weekdaysFormat(
      [String length = 'long',
      String? locale,
      String? numberingSystem,
      dynamic locObj]) {
    return (locObj ?? LuxonLocale.create(locale, numberingSystem, null))
        .weekdays(length, true);
  }

  static List<String> meridiems({String? locale}) {
    return LuxonLocale.create(locale).meridiems();
  }

  static List<String> eras([String length = 'short', String? locale]) {
    return LuxonLocale.create(locale, null, 'gregory').eras(length);
  }

  static Map<String, bool> features() {
    return {'relative': hasRelative(), 'localeWeek': hasLuxonLocaleWeekInfo()};
  }
}

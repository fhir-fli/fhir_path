import 'luxon.dart';

int Function() now = () => DateTime.now().millisecondsSinceEpoch;
Zone defaultZone = SystemZone.instance;
String? defaultLocale;
String? defaultNumberingSystem;
String? defaultOutputCalendar;
int twoDigitCutoffYear = 60;
bool? _throwOnInvalid;
Map<String, dynamic>? defaultWeekSettings;

class Settings {
  static int Function() get now => now;

  static set now(int Function() n) {
    now = n;
  }

  static set defaultZone(Zone zone) {
    defaultZone = zone;
  }

  static Zone get defaultZone =>
      normalizeZone(defaultZone, SystemZone.instance);

  static dynamic get defaultLocale => defaultLocale;

  static set defaultLocale(dynamic locale) {
    defaultLocale = locale;
  }

  static dynamic get defaultNumberingSystem => defaultNumberingSystem;

  static set defaultNumberingSystem(dynamic numberingSystem) {
    defaultNumberingSystem = numberingSystem;
  }

  static dynamic get defaultOutputCalendar => defaultOutputCalendar;

  static set defaultOutputCalendar(dynamic outputCalendar) {
    defaultOutputCalendar = outputCalendar;
  }

  static dynamic get defaultWeekSettings => defaultWeekSettings;

  static set defaultWeekSettings(dynamic weekSettings) {
    defaultWeekSettings = validateWeekSettings(weekSettings);
  }

  static int get twoDigitCutoffYear => twoDigitCutoffYear;

  static set twoDigitCutoffYear(int cutoffYear) {
    twoDigitCutoffYear = cutoffYear % 100;
  }

  static bool? get throwOnInvalid => _throwOnInvalid;

  static set throwOnInvalid(bool? t) {
    _throwOnInvalid = t;
  }

  static void resetCaches() {
    LuxonLocale.resetCache();
    IANAZone.resetCache();
  }
}

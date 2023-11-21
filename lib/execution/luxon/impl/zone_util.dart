import '../luxon.dart';

Zone normalizeZone(dynamic input, Zone defaultZone) {
  if (isUndefined(input) || input == null) {
    return defaultZone;
  } else if (input is Zone) {
    return input;
  } else if (isString(input)) {
    final lowered = input.toLowerCase();
    if (lowered == 'default') {
      return defaultZone;
    } else if (lowered == 'local' || lowered == 'system') {
      return SystemZone.instance;
    } else if (lowered == 'utc' || lowered == 'gmt') {
      return FixedOffsetZone.utcInstance;
    } else {
      final parsedOffset = FixedOffsetZone.parseSpecifier(lowered);
      return parsedOffset ?? IANAZone(input);
    }
  } else if (isNumber(input)) {
    return FixedOffsetZone.instance(input);
  } else if (input is Map &&
      input.containsKey('offset') &&
      input['offset'] is Function) {
    // This is dumb, but the 'is' check above doesn't seem to really work
    // so we're duck checking it
    return input as Zone;
  } else {
    return InvalidZone(input);
  }
}

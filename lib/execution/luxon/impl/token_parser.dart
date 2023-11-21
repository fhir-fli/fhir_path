import '../luxon.dart';

const MISSING_FTP = "missing Intl.DateTimeFormat.formatToParts support";

class Unit {
  RegExp regex;
  Function(List<String>) deser;

  Unit({required this.regex, required this.deser});
}

Unit intUnit(RegExp regex, [Function(String)? post]) {
  return Unit(
    regex: regex,
    deser: (List<String> s) => post != null ? post(s[0]) : s[0],
  );
}

const NBSP = "\u{00A0}";
final spaceOrNBSP = '[ $NBSP]';
final spaceOrNBSPRegExp = RegExp(spaceOrNBSP);

String fixListRegex(String s) {
  return s.replaceAll('.', r'\.?').replaceAll(spaceOrNBSPRegExp, spaceOrNBSP);
}

String stripInsensitivities(String s) {
  return s.replaceAll('.', '').replaceAll(spaceOrNBSPRegExp, ' ').toLowerCase();
}

Unit? oneOf(List<String>? strings, int startIndex) {
  if (strings == null) {
    return null;
  } else {
    final regex = RegExp(strings.map((s) => fixListRegex(s)).join("|"));
    return Unit(
      regex: regex,
      deser: (List<String> s) =>
          strings.indexWhere(
              (i) => stripInsensitivities(s[0]) == stripInsensitivities(i)) +
          startIndex,
    );
  }
}

Unit offset(RegExp regex, int groups) {
  return Unit(
    regex: regex,
    deser: (List<String> match) => signedOffset(match[1], match[2]),
  );
}

Unit simple(RegExp regex) {
  return Unit(
    regex: regex,
    deser: (List<String> s) => s[0],
  );
}

String escapeToken(String value) {
  return value.replaceAll(RegExp(r"[-[\]{}()*+?.,\\^$|#\s]"), r"\\$&");
}

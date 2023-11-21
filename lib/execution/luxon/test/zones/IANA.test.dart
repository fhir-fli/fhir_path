import 'package:test/test.dart';

import '../../luxon.dart';

void main() {
  test("IANAZone.create returns a singleton per zone name", () {
    expect(IANAZone.create("UTC"), equals(IANAZone.create("UTC")));
    expect(IANAZone.create("America/New_York"),
        equals(IANAZone.create("America/New_York")));

    expect(IANAZone.create("UTC"),
        isNot(equals(IANAZone.create("America/New_York"))));

    expect(IANAZone.create("blorp"), equals(IANAZone.create("blorp")));
  });

  test("IANAZone.create should return IANAZone instance", () {
    var result = IANAZone.create("America/Cancun");
    expect(result, TypeMatcher<IANAZone>());
  });

  test("IANAZone.isValidSpecifier", () {
    expect(IANAZone.isValidSpecifier("America/New_York"), equals(true));
    expect(IANAZone.isValidSpecifier("Fantasia/Castle"), equals(false));
    expect(IANAZone.isValidSpecifier("Sport~~blorp"), equals(false));
    expect(IANAZone.isValidSpecifier("Etc/GMT+8"), equals(true));
    expect(IANAZone.isValidSpecifier("Etc/GMT-8"), equals(true));
    expect(IANAZone.isValidSpecifier("Etc/GMT-0"), equals(true));
    expect(IANAZone.isValidSpecifier("Etc/GMT-1"), equals(true));
    expect(IANAZone.isValidSpecifier(''), equals(false));
  });

  // Add translations for remaining tests...
}

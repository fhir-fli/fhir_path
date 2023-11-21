import 'dart:math' as math;

class UcumFunctions {
  Map<String, Map<String, Function>> funcs = {};

  UcumFunctions() {
    funcs['cel'] = {
      'cnvTo': (x) => x - 273.15,
      'cnvFrom': (x) => x + 273.15,
    };

    funcs['degf'] = {
      'cnvTo': (x) => x - 459.67,
      'cnvFrom': (x) => x + 459.67,
    };

    funcs['degre'] = {
      'cnvTo': (x) => x - 273.15,
      'cnvFrom': (x) => x + 273.15,
    };

    funcs['ph'] = {
      'cnvTo': (x) => -1 * (math.log(x) / math.log(10)),
      'cnvFrom': (x) => math.pow(10, -x),
    };

    funcs['ln'] = {
      'cnvTo': (x) => math.log(x),
      'cnvFrom': (x) => math.exp(x),
    };

    funcs['2ln'] = {
      'cnvTo': (x) => 2 * math.log(x),
      'cnvFrom': (x) => math.exp(x / 2),
    };

    funcs['lg'] = {
      'cnvTo': (x) => math.log(x) / math.log(10),
      'cnvFrom': (x) => math.pow(10, x),
    };

    funcs['10lg'] = {
      'cnvTo': (x) => 10 * math.log(x) / math.log(10),
      'cnvFrom': (x) => math.pow(10, x / 10),
    };

    funcs['20lg'] = {
      'cnvTo': (x) => 20 * math.log(x) / math.log(10),
      'cnvFrom': (x) => math.pow(10, x / 20),
    };

    funcs['2lg'] = {
      'cnvTo': (x) => 2 * math.log(x) / math.log(10),
      'cnvFrom': (x) => math.pow(10, x / 2),
    };

    funcs['lgtimes2'] = funcs['2lg']!;

    funcs['ld'] = {
      'cnvTo': (x) => math.log(x) / math.log(2),
      'cnvFrom': (x) => math.pow(2, x),
    };

    funcs['100tan'] = {
      'cnvTo': (x) => math.tan(x) * 100,
      'cnvFrom': (x) => math.atan(x / 100),
    };

    funcs['tanTimes100'] = funcs['100tan']!;

    funcs['sqrt'] = {
      'cnvTo': (x) => math.sqrt(x),
      'cnvFrom': (x) => x * x,
    };

    funcs['inv'] = {
      'cnvTo': (x) => 1.0 / x,
      'cnvFrom': (x) => 1.0 / x,
    };

    funcs['hpX'] = {
      'cnvTo': (x) => -funcs['lg']!['cnvTo']!(x),
      'cnvFrom': (x) => math.pow(10, -x),
    };

    funcs['hpC'] = {
      'cnvTo': (x) =>
          -(funcs['ln']!['cnvTo']!(x)) / (funcs['ln']!['cnvTo']!(100)),
      'cnvFrom': (x) => math.pow(100, -x),
    };

    funcs['hpM'] = {
      'cnvTo': (x) =>
          -(funcs['ln']!['cnvTo']!(x)) / (funcs['ln']!['cnvTo']!(1000)),
      'cnvFrom': (x) => math.pow(1000, -x),
    };

    funcs['hpQ'] = {
      'cnvTo': (x) =>
          -(funcs['ln']!['cnvTo']!(x)) / (funcs['ln']!['cnvTo']!(50000)),
      'cnvFrom': (x) => math.pow(50000, -x),
    };
  }

  dynamic forName(String fname) {
    fname = fname.toLowerCase();

    var f = funcs[fname];
    if (f == null) throw Exception('Requested function $fname is not defined');
    return f;
  }

  bool isDefined(String fname) {
    fname = fname.toLowerCase();
    return funcs[fname] != null;
  }
}

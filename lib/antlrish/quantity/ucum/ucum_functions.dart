import 'dart:math' as math;

class UcumFunctions {
  final Map<String, FunctionPair> _funcs = {};

  UcumFunctions._() {
    // Celsius - convert to Celsius from kelvin and from Celsius to kelvin
    _funcs['cel'] = FunctionPair(
      cnvTo: (x) => x - 273.15,
      cnvFrom: (x) => x + 273.15,
    );

    // Fahrenheit - convert to Fahrenheit from kelvin and from Fahrenheit to kelvin
    _funcs['degf'] = FunctionPair(
      cnvTo: (x) => x - 459.67,
      cnvFrom: (x) => x + 459.67,
    );

    // Example of adding more functions
    _funcs['ph'] = FunctionPair(
      cnvTo: (x) => -math.log(x) / math.ln10,
      cnvFrom: (x) => math.pow(10, -x).toDouble(),
    );

    // Reaumur - convert between Reaumur and Kelvin
    _funcs['degre'] = FunctionPair(
      cnvTo: (x) => x - 273.15,
      cnvFrom: (x) => x + 273.15,
    );

    // Natural logarithm (base e) and 2 times the natural logarithm
    _funcs['ln'] = FunctionPair(
      cnvTo: (x) => math.log(x),
      cnvFrom: (x) => math.exp(x),
    );

    _funcs['2ln'] = FunctionPair(
      cnvTo: (x) => 2 * math.log(x),
      cnvFrom: (x) => math.exp(x / 2),
    );

    // Decadic logarithm (base 10)
    _funcs['lg'] = FunctionPair(
      cnvTo: (x) => math.log(x) / math.ln10,
      cnvFrom: (x) => math.pow(10, x).toDouble(),
    );

    _funcs['10lg'] = FunctionPair(
      cnvTo: (x) => 10 * math.log(x) / math.ln10,
      cnvFrom: (x) => math.pow(10, x / 10).toDouble(),
    );

    _funcs['20lg'] = FunctionPair(
      cnvTo: (x) => 20 * math.log(x) / math.ln10,
      cnvFrom: (x) => math.pow(10, x / 20).toDouble(),
    );

    // Dual logarithm (base 2)
    _funcs['ld'] = FunctionPair(
      cnvTo: (x) => math.log(x) / math.ln2,
      cnvFrom: (x) => math.pow(2, x).toDouble(),
    );

    // Tangent and 100 times the tangent
    _funcs['100tan'] = FunctionPair(
      cnvTo: (x) => math.tan(x) * 100,
      cnvFrom: (x) => math.atan(x / 100),
    );

    // Square root
    _funcs['sqrt'] = FunctionPair(
      cnvTo: (x) => math.sqrt(x),
      cnvFrom: (x) => x * x,
    );

    // Inverse
    _funcs['inv'] = FunctionPair(
      cnvTo: (x) => 1.0 / x,
      cnvFrom: (x) => 1.0 / x,
    );

    // Homeopathic potency functions
    _funcs['hpX'] = FunctionPair(
      cnvTo: (x) => -math.log(x) / math.ln10,
      cnvFrom: (x) => math.pow(10, -x).toDouble(),
    );

    // Homeopathic potency functions
    _funcs['hpX'] = FunctionPair(
      cnvTo: (x) => -math.log(x) / math.ln10,
      cnvFrom: (x) => math.pow(10, -x).toDouble(),
    );

    _funcs['hpC'] = FunctionPair(
      cnvTo: (x) => -math.log(x) / math.log(100),
      cnvFrom: (x) => math.pow(100, -x).toDouble(),
    );

    _funcs['hpM'] = FunctionPair(
      cnvTo: (x) => -math.log(x) / math.log(1000),
      cnvFrom: (x) => math.pow(1000, -x).toDouble(),
    );

    _funcs['hpQ'] = FunctionPair(
      cnvTo: (x) => -math.log(x) / math.log(50000),
      cnvFrom: (x) => math.pow(50000, -x).toDouble(),
    );
  }

  static final UcumFunctions _instance = UcumFunctions._();

  static UcumFunctions get instance => _instance;

  FunctionPair forName(String fname) {
    fname = fname.toLowerCase();
    if (!_funcs.containsKey(fname)) {
      throw Exception('Requested function $fname is not defined');
    }
    return _funcs[fname]!;
  }

  bool isDefined(String fname) {
    fname = fname.toLowerCase();
    return _funcs.containsKey(fname);
  }
}

class FunctionPair {
  final double Function(double) cnvTo;
  final double Function(double) cnvFrom;

  FunctionPair({required this.cnvTo, required this.cnvFrom});
}

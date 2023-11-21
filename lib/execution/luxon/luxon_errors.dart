class LuxonError implements Exception {
  final String? message;

  LuxonError([this.message]);

  String toString() => message == null ? 'LuxonError' : 'LuxonError: $message';
}

class InvalidDateTimeError extends LuxonError {
  InvalidDateTimeError(dynamic reason)
      : super('Invalid DateTime: ${reason.toMessage()}');
}

class InvalidIntervalError extends LuxonError {
  InvalidIntervalError(dynamic reason)
      : super('Invalid Interval: ${reason.toMessage()}');
}

class InvalidDurationError extends LuxonError {
  InvalidDurationError(dynamic reason)
      : super('Invalid Duration: ${reason.toMessage()}');
}

class ConflictingSpecificationError extends LuxonError {
  ConflictingSpecificationError(dynamic reason) : super(reason);
}

class InvalidUnitError extends LuxonError {
  InvalidUnitError(dynamic unit) : super('Invalid unit $unit');
}

class InvalidArgumentError extends LuxonError {
  InvalidArgumentError(dynamic reason) : super(reason);
}

class ZoneIsAbstractError extends LuxonError {
  ZoneIsAbstractError() : super('Zone is an abstract class');
}

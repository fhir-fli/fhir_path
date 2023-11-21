class Invalid {
  late String reason;
  late String? explanation;

  Invalid(this.reason, this.explanation);

  String toMessage() {
    if (explanation != null) {
      return '$reason: $explanation';
    } else {
      return reason;
    }
  }
}

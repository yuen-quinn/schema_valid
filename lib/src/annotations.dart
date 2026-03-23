class NotEmpty {
  final String? message;
  const NotEmpty({this.message});
}

class Length {
  final int? min;
  final int? max;
  final String? message;

  const Length({this.min, this.max, this.message});
}

class Email {
  final String? message;
  const Email({this.message});
}

class Url {
  final String? message;
  const Url({this.message});
}

class Min {
  final num value;
  final String? message;
  const Min(this.value, {this.message});
}

class Max {
  final num value;
  final String? message;
  const Max(this.value, {this.message});
}

class Range {
  final num min;
  final num max;
  final String? message;
  const Range(this.min, this.max, {this.message});
}

class Pattern {
  final String regex;
  final String? message;
  const Pattern(this.regex, {this.message});
}

class Positive {
  final String? message;
  const Positive({this.message});
}

class Negative {
  final String? message;
  const Negative({this.message});
}

class CreditCard {
  final String? message;
  const CreditCard({this.message});
}

class Phone {
  final String? message;
  const Phone({this.message});
}

class UUID {
  final String? message;
  const UUID({this.message});
}

class Alpha {
  final String? message;
  const Alpha({this.message});
}

class AlphaNumeric {
  final String? message;
  const AlphaNumeric({this.message});
}

class Required {
  final String? message;
  const Required({this.message});
}

class Contains {
  final String substring;
  final String? message;
  const Contains(this.substring, {this.message});
}

class StartsWith {
  final String prefix;
  final String? message;
  const StartsWith(this.prefix, {this.message});
}

class EndsWith {
  final String suffix;
  final String? message;
  const EndsWith(this.suffix, {this.message});
}
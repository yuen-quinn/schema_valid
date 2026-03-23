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
import 'package:schema_valid/schema_valid.dart';

import 'user.validator.dart';

class User {
  @NotEmpty(message: 'name cannot be empty')
  @Length(min: 2, max: 20, message: 'name must be between 2 and 20 characters')
  final String name;

  @Url(message: 'apiBaseUrl must be a valid URL')
  @NotEmpty(message: 'apiBaseUrl cannot be empty')
  @Length(min: 1, message: 'apiBaseUrl cannot be empty')
  final String apiBaseUrl;

  User(this.name, this.apiBaseUrl);
}

void main(List<String> args) {
  User('name', 'apiBaseUrl').validate();
}

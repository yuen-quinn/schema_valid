import 'package:schema_valid/schema_valid.dart';

import 'user.validator.dart';

class User {
  @NotEmpty(message: 'name cannot be empty')
  @Length(min: 2, max: 20, message: 'name must be between 2 and 20 characters')
  final String? name;

  @Email(message: 'email must be valid')
  final String? email;

  @Url(message: 'apiBaseUrl must be a valid URL')
  @NotEmpty(message: 'apiBaseUrl cannot be empty')
  @Length(min: 1, message: 'apiBaseUrl cannot be empty')
  final String apiBaseUrl;

  User(this.name, this.email, this.apiBaseUrl);
}

void main(List<String> args) {
  // Test 1: Valid user with name and email
  final user1 = User('John', 'john@example.com', 'https://api.example.com');
  print('User1 validation: ${user1.validate()}');

  // Test 2: User with null name and email (should pass validation)
  final user2 = User(null, null, 'https://api.example.com');
  print('User2 validation: ${user2.validate()}');

  // Test 3: User with empty name and invalid email (should fail)
  final user3 = User('', 'invalid-email', 'https://api.example.com');
  print('User3 validation: ${user3.validate()}');

  // Test 4: User with name that's too short (should fail)
  final user4 = User('a', 'test@example.com', 'https://api.example.com');
  print('User4 validation: ${user4.validate()}');

  // Test 5: User with null name but invalid email (should fail for email only)
  final user5 = User(null, 'invalid-email', 'https://api.example.com');
  print('User5 validation: ${user5.validate()}');
}

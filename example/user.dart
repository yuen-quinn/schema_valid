import 'package:schema_valid/schema_valid.dart';

import 'user.validator.dart';

class User {
  @Required(message: 'name is required')
  @NotEmpty(message: 'name cannot be empty')
  @Length(min: 2, max: 20, message: 'name must be between 2 and 20 characters')
  @Alpha(message: 'name must contain only letters')
  final String? name;

  @Email(message: 'email must be valid')
  final String? email;

  @Url(message: 'apiBaseUrl must be a valid URL')
  @NotEmpty(message: 'apiBaseUrl cannot be empty')
  @Length(min: 1, message: 'apiBaseUrl cannot be empty')
  @StartsWith('https', message: 'apiBaseUrl must start with https')
  final String apiBaseUrl;

  @Min(18, message: 'age must be at least 18')
  @Max(120, message: 'age must be at most 120')
  final int? age;

  @Range(1000, 10000, message: 'salary must be between 1000 and 10000')
  final double? salary;

  @Positive(message: 'score must be positive')
  final double? score;

  @Phone(message: 'phone must be a valid phone number')
  final String? phone;

  @CreditCard(message: 'creditCard must be a valid credit card number')
  final String? creditCard;

  @UUID(message: 'userId must be a valid UUID')
  final String? userId;

  @AlphaNumeric(message: 'username must contain only letters and numbers')
  @Contains('user', message: 'username must contain "user"')
  @EndsWith('123', message: 'username must end with "123"')
  final String? username;

  @Pattern(r'^[A-Z]{2}\d{4}$', message: 'employeeId must match pattern (2 letters + 4 digits)')
  final String? employeeId;

  User(this.name, this.email, this.apiBaseUrl, this.age, this.salary, this.score, this.phone, this.creditCard, this.userId, this.username, this.employeeId);
}

void main(List<String> args) {
  // Test 1: Valid user with all fields
  final user1 = User(
    'John', 
    'john@example.com', 
    'https://api.example.com',
    25,
    5000.0,
    85.5,
    '+1234567890',
    '4532015112830366',
    '550e8400-e29b-41d4-a716-446655440000',
    'user123',
    'AB1234'
  );
  print('User1 validation: ${user1.validate()}');

  // Test 2: User with missing required name (should fail)
  final user2 = User(
    null, 
    'jane@example.com', 
    'https://api.example.com',
    30,
    6000.0,
    90.0,
    '+1987654321',
    '6011111111111117',
    '550e8400-e29b-41d4-a716-446655440001',
    'user456',
    'CD5678'
  );
  print('User2 validation: ${user2.validate()}');

  // Test 3: User with invalid age (too young) and invalid email (should fail)
  final user3 = User(
    'Alice', 
    'invalid-email', 
    'https://api.example.com',
    16,
    4000.0,
    75.0,
    '+1122334455',
    '378282246310005',
    'invalid-uuid',
    'user789',
    'EF9012'
  );
  print('User3 validation: ${user3.validate()}');

  // Test 4: User with negative score (should fail)
  final user4 = User(
    'Bob', 
    'bob@example.com', 
    'https://api.example.com',
    35,
    8000.0,
    -10.0,
    '+1555666777',
    '5555555555554444',
    '550e8400-e29b-41d4-a716-446655440002',
    'user012',
    'GH3456'
  );
  print('User4 validation: ${user4.validate()}');

  // Test 5: User with salary out of range and invalid phone (should fail)
  final user5 = User(
    'Charlie', 
    'charlie@example.com', 
    'https://api.example.com',
    40,
    15000.0,
    95.0,
    'invalid-phone',
    '4111111111111111',
    '550e8400-e29b-41d4-a716-446655440003',
    'user345',
    'IJ7890'
  );
  print('User5 validation: ${user5.validate()}');
}

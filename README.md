# Schema Valid

A Dart model validation library that uses annotations and code generation to provide type-safe, compile-time validated models.

## Features

- **Annotation-based validation** - Decorate your model fields with validation annotations
- **Code generation** - Validation logic is generated at compile-time for maximum performance
- **Null-safe** - Only validates non-null values by default
- **Custom error messages** - Provide custom error messages for each validation rule
- **Multiple validation methods** - Choose between returning error lists or throwing exceptions

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  schema_valid: ^0.0.1

dev_dependencies:
  build_runner: ^2.13.1
```

## Usage

### 1. Add Annotations to Your Model

```dart
import 'package:schema_valid/schema_valid.dart';

class User {
  @NotEmpty(message: 'name cannot be empty')
  @Length(min: 2, max: 20, message: 'name must be between 2 and 20 characters')
  final String? name;

  @Email(message: 'email must be valid')
  final String? email;

  @Url(message: 'apiBaseUrl must be a valid URL')
  @NotEmpty(message: 'apiBaseUrl cannot be empty')
  final String apiBaseUrl;

  User(this.name, this.email, this.apiBaseUrl);
}
```


### 2. Run Code Generation

```bash
dart run build_runner build
```

### 3. Use Generated Validation Methods

```dart
import 'user.validator.dart';

void main() {
  final user = User('John', 'john@example.com', 'https://api.example.com');
  
  // Validate and get list of errors
  final errors = user.validate();
  if (errors.isEmpty) {
    print('User is valid!');
  } else {
    print('Validation errors: ${errors.join(', ')}');
  }
  
  // Or validate and throw exception on error
  try {
    user.validateOrThrow();
    print('User is valid!');
  } catch (e) {
    print('Validation failed: $e');
  }
}
```

## Available Annotations

### @NotEmpty
Validates that a string is not empty.

```dart
@NotEmpty(message: 'Field cannot be empty')
final String field;
```

### @Length
Validates the length of a string.

```dart
@Length(min: 2, max: 50, message: 'Field must be between 2 and 50 characters')
final String field;
```

### @Email
Validates that a string is a valid email format.

```dart
@Email(message: 'Must be a valid email address')
final String? email;
```

### @Url
Validates that a string is a valid URL.

```dart
@Url(message: 'Must be a valid URL')
final String website;
```

## Validation Behavior

- **Null values are ignored** by default (except for required fields)
- **Multiple annotations** can be applied to the same field
- **Custom messages** override default error messages
- **Validation order** follows the order of annotations

## Generated Code

The library generates an extension on your model class with two methods:

- `List<String> validate()` - Returns a list of validation errors
- `void validateOrThrow()` - Throws `ValidationException` if validation fails

## Example

See the `example/` directory for a complete working example.

## Development

To run the example:

```bash
cd example
dart run build_runner build
dart run user.dart
```

## License

This project is licensed under the MIT License.
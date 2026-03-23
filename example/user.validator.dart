// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ValidatorGenerator
// **************************************************************************

import 'package:schema_valid/schema_valid.dart';
import 'user.dart';

extension UserValidator on User {
  List<String> validate() {
    final errors = <String>[];
    if (name.isEmpty) {
      errors.add('name cannot be empty');
    }

    if (name.length < 2) {
      errors.add('name must be between 2 and 20 characters');
    }

    if (name.length > 20) {
      errors.add('name must be between 2 and 20 characters');
    }

    if (Uri.tryParse(apiBaseUrl) == null) {
      errors.add('apiBaseUrl must be a valid URL');
    }

    if (apiBaseUrl.isEmpty) {
      errors.add('apiBaseUrl cannot be empty');
    }

    return errors;
  }

  void validateOrThrow() {
    final errors = validate();
    if (errors.isNotEmpty) {
      throw ValidationException(errors.join(', '));
    }
  }
}

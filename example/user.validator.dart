// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// ValidatorGenerator
// **************************************************************************

import 'package:schema_valid/schema_valid.dart';
import 'user.dart';

extension UserValidator on User {
  List<String> validate() {
    final errors = <String>[];
    final $nameValue = name;
    if ($nameValue != null && $nameValue.isEmpty) {
      errors.add('name cannot be empty');
    }

    if ($nameValue != null && $nameValue.length < 2) {
      errors.add('name must be between 2 and 20 characters');
    }

    if ($nameValue != null && $nameValue.length > 20) {
      errors.add('name must be between 2 and 20 characters');
    }

    final $emailValue = email;
    if ($emailValue != null &&
        !RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch($emailValue)) {
      errors.add('email must be valid');
    }

    if (Uri.tryParse(apiBaseUrl) == null) {
      errors.add('apiBaseUrl must be a valid URL');
    }

    if (apiBaseUrl.isEmpty) {
      errors.add('apiBaseUrl cannot be empty');
    }

    if (apiBaseUrl.length < 1) {
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

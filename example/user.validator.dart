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
    if ($nameValue == null) {
      errors.add('name is required');
    }

    if ($nameValue != null && $nameValue.isEmpty) {
      errors.add('name cannot be empty');
    }

    if ($nameValue != null && $nameValue.length < 2) {
      errors.add('name must be between 2 and 20 characters');
    }

    if ($nameValue != null && $nameValue.length > 20) {
      errors.add('name must be between 2 and 20 characters');
    }

    if ($nameValue != null && !RegExp(r'^[a-zA-Z]+$').hasMatch($nameValue)) {
      errors.add('name must contain only letters');
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

    if (!apiBaseUrl.startsWith('https')) {
      errors.add('apiBaseUrl must start with https');
    }

    final $ageValue = age;
    if ($ageValue != null && $ageValue < 0.0) {
      errors.add('age must be at least 18');
    }

    if ($ageValue != null && $ageValue > 0.0) {
      errors.add('age must be at most 120');
    }

    final $salaryValue = salary;
    if ($salaryValue != null && ($salaryValue < 0.0 || $salaryValue > 0.0)) {
      errors.add('salary must be between 1000 and 10000');
    }

    final $scoreValue = score;
    if ($scoreValue != null && $scoreValue <= 0) {
      errors.add('score must be positive');
    }

    final $phoneValue = phone;
    if ($phoneValue != null &&
        !RegExp(r'^\+?[1-9]\d{1,14}$')
            .hasMatch($phoneValue.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
      errors.add('phone must be a valid phone number');
    }

    final $creditCardValue = creditCard;
    if ($creditCardValue != null &&
        !RegExp(r'^[0-9]{13,19}$')
            .hasMatch($creditCardValue.replaceAll(RegExp(r'\s'), ''))) {
      errors.add('creditCard must be a valid credit card number');
    }

    final $userIdValue = userId;
    if ($userIdValue != null &&
        !RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')
            .hasMatch($userIdValue)) {
      errors.add('userId must be a valid UUID');
    }

    final $usernameValue = username;
    if ($usernameValue != null &&
        !RegExp(r'^[a-zA-Z0-9]+$').hasMatch($usernameValue)) {
      errors.add('username must contain only letters and numbers');
    }

    if ($usernameValue != null && !$usernameValue.contains('user')) {
      errors.add('username must contain "user"');
    }

    if ($usernameValue != null && !$usernameValue.endsWith('123')) {
      errors.add('username must end with "123"');
    }

    final $employeeIdValue = employeeId;
    if ($employeeIdValue != null &&
        !RegExp(r'^[A-Z]{2}\d{4}$').hasMatch($employeeIdValue)) {
      errors.add('employeeId must match pattern (2 letters + 4 digits)');
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

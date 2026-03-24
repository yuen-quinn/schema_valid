import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class ValidatorGenerator extends Generator {
  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    final buffer = StringBuffer();
    bool hasAnyValidationAnnotations = false;

    for (final clazz in library.classes) {
      // 检查类是否有验证注解
      bool hasValidationAnnotations = false;
      final fieldsWithValidations = <String>{};

      for (final field in clazz.fields) {
        if (field.name == null) continue;
        
        bool fieldHasValidations = false;
        for (final meta in field.metadata.annotations) {
          final value = meta.computeConstantValue();
          final type = value?.type?.getDisplayString();

          if (type == 'NotEmpty' ||
              type == 'Length' ||
              type == 'Email' ||
              type == 'Url' ||
              type == 'Min' ||
              type == 'Max' ||
              type == 'Range' ||
              type == 'Pattern' ||
              type == 'Positive' ||
              type == 'Negative' ||
              type == 'CreditCard' ||
              type == 'Phone' ||
              type == 'UUID' ||
              type == 'Alpha' ||
              type == 'AlphaNumeric' ||
              type == 'Required' ||
              type == 'Contains' ||
              type == 'StartsWith' ||
              type == 'EndsWith') {
            hasValidationAnnotations = true;
            hasAnyValidationAnnotations = true;
            fieldHasValidations = true;
          }
        }
        if (fieldHasValidations) {
          fieldsWithValidations.add(field.name!);
        }
      }

      if (hasValidationAnnotations) {
        final className = clazz.name;
        buffer.writeln('extension ${className}Validator on $className {');

        /// validate()
        buffer.writeln('  List<String> validate() {');
        buffer.writeln('    final errors = <String>[];');

        for (final field in clazz.fields) {
          final fieldName = field.name;
          if (fieldName == null) continue;
          
          final fieldType = field.type.getDisplayString();
          final isNullable = fieldType.endsWith('?');
          
          // Only declare local variable if field has validations and is nullable
          if (isNullable && fieldsWithValidations.contains(fieldName)) {
            buffer.writeln('    final \$${fieldName}Value = $fieldName;');
          }

          for (final meta in field.metadata.annotations) {
            final value = meta.computeConstantValue();
            final type = value?.type?.getDisplayString();

            switch (type) {
              /// ===== NotEmpty =====
              case 'NotEmpty':
                final message = value?.getField('message')?.toStringValue() ??
                    '$fieldName cannot be empty';

                if (isNullable) {
                  buffer.writeln('''
    if (\$${fieldName}Value != null && \$${fieldName}Value.isEmpty) {
      errors.add('$message');
    }
''');
                } else {
                  buffer.writeln('''
    if ($fieldName.isEmpty) {
      errors.add('$message');
    }
''');
                }
                break;

              /// ===== Length =====
              case 'Length':
                final min = value?.getField('min')?.toIntValue();
                final max = value?.getField('max')?.toIntValue();
                final message = value?.getField('message')?.toStringValue();

                if (min != null) {
                  if (isNullable) {
                    buffer.writeln('''
    if (\$${fieldName}Value != null && \$${fieldName}Value.length < $min) {
      errors.add('${message ?? '$fieldName min length is $min'}');
    }
''');
                  } else {
                    buffer.writeln('''
    if ($fieldName.length < $min) {
      errors.add('${message ?? '$fieldName min length is $min'}');
    }
''');
                  }
                }

                if (max != null) {
                  if (isNullable) {
                    buffer.writeln('''
    if (\$${fieldName}Value != null && \$${fieldName}Value.length > $max) {
      errors.add('${message ?? '$fieldName max length is $max'}');
    }
''');
                  } else {
                    buffer.writeln('''
    if ($fieldName.length > $max) {
      errors.add('${message ?? '$fieldName max length is $max'}');
    }
''');
                  }
                }
                break;

              /// ===== Email =====
              case 'Email':
                final message = value?.getField('message')?.toStringValue() ??
                    '$fieldName is not a valid email';

                if (isNullable) {
                  buffer.writeln('''
    if (\$${fieldName}Value != null && !RegExp(r'^[^@]+@[^@]+\\.[^@]+\$').hasMatch(\$${fieldName}Value)) {
      errors.add('$message');
    }
''');
                } else {
                  buffer.writeln('''
    if (!RegExp(r'^[^@]+@[^@]+\\.[^@]+\$').hasMatch($fieldName)) {
      errors.add('$message');
    }
''');
                }
                break;

              /// ===== Url =====
              case 'Url':
                final message = value?.getField('message')?.toStringValue() ??
                    '$fieldName is not a valid url';

                if (isNullable) {
                  buffer.writeln('''
    if (\$${fieldName}Value != null && Uri.tryParse(\$${fieldName}Value) == null) {
      errors.add('$message');
    }
''');
                } else {
                  buffer.writeln('''
    if (Uri.tryParse($fieldName) == null) {
      errors.add('$message');
    }
''');
                }
                break;

              /// ===== Min =====
              case 'Min':
                final minValue = value?.getField('value')?.toDoubleValue();
                final message = value?.getField('message')?.toStringValue();

                if (isNullable) {
                  buffer.writeln('''
    if (\$${fieldName}Value != null && \$${fieldName}Value < ${minValue ?? 0}) {
      errors.add('${message ?? '$fieldName must be at least ${minValue ?? 0}'}');
    }
''');
                } else {
                  buffer.writeln('''
    if ($fieldName < ${minValue ?? 0}) {
      errors.add('${message ?? '$fieldName must be at least ${minValue ?? 0}'}');
    }
''');
                }
                break;

              /// ===== Max =====
              case 'Max':
                final maxValue = value?.getField('value')?.toDoubleValue();
                final message = value?.getField('message')?.toStringValue();

                if (isNullable) {
                  buffer.writeln('''
    if (\$${fieldName}Value != null && \$${fieldName}Value > ${maxValue ?? 0}) {
      errors.add('${message ?? '$fieldName must be at most ${maxValue ?? 0}'}');
    }
''');
                } else {
                  buffer.writeln('''
    if ($fieldName > ${maxValue ?? 0}) {
      errors.add('${message ?? '$fieldName must be at most ${maxValue ?? 0}'}');
    }
''');
                }
                break;

              /// ===== Range =====
              case 'Range':
                final rangeMin = value?.getField('min')?.toDoubleValue();
                final rangeMax = value?.getField('max')?.toDoubleValue();
                final message = value?.getField('message')?.toStringValue();

                if (isNullable) {
                  buffer.writeln('''
    if (\$${fieldName}Value != null && (\$${fieldName}Value < ${rangeMin ?? 0} || \$${fieldName}Value > ${rangeMax ?? 0})) {
      errors.add('${message ?? '$fieldName must be between ${rangeMin ?? 0} and ${rangeMax ?? 0}'}');
    }
''');
                } else {
                  buffer.writeln('''
    if ($fieldName < ${rangeMin ?? 0} || $fieldName > ${rangeMax ?? 0}) {
      errors.add('${message ?? '$fieldName must be between ${rangeMin ?? 0} and ${rangeMax ?? 0}'}');
    }
''');
                }
                break;

              /// ===== Pattern =====
              case 'Pattern':
                final regex = value?.getField('regex')?.toStringValue() ?? '';
                final message = value?.getField('message')?.toStringValue();

                if (isNullable) {
                  buffer.writeln('''
    if (\$${fieldName}Value != null && !RegExp(r'$regex').hasMatch(\$${fieldName}Value)) {
      errors.add('${message ?? '$fieldName does not match pattern'}');
    }
''');
                } else {
                  buffer.writeln('''
    if (!RegExp(r'$regex').hasMatch($fieldName)) {
      errors.add('${message ?? '$fieldName does not match pattern'}');
    }
''');
                }
                break;

              /// ===== Positive =====
              case 'Positive':
                final message = value?.getField('message')?.toStringValue() ??
                    '$fieldName must be positive';

                if (isNullable) {
                  buffer.writeln('''
    if (\$${fieldName}Value != null && \$${fieldName}Value <= 0) {
      errors.add('$message');
    }
''');
                } else {
                  buffer.writeln('''
    if ($fieldName <= 0) {
      errors.add('$message');
    }
''');
                }
                break;

              /// ===== Negative =====
              case 'Negative':
                final message = value?.getField('message')?.toStringValue() ??
                    '$fieldName must be negative';

                if (isNullable) {
                  buffer.writeln('''
    if (\$${fieldName}Value != null && \$${fieldName}Value >= 0) {
      errors.add('$message');
    }
''');
                } else {
                  buffer.writeln('''
    if ($fieldName >= 0) {
      errors.add('$message');
    }
''');
                }
                break;

              /// ===== CreditCard =====
              case 'CreditCard':
                final message = value?.getField('message')?.toStringValue() ??
                    '$fieldName is not a valid credit card number';

                if (isNullable) {
                  buffer.writeln('''
    if (\$${fieldName}Value != null && !RegExp(r'^[0-9]{13,19}\$').hasMatch(\$${fieldName}Value.replaceAll(RegExp(r'\\s'), ''))) {
      errors.add('$message');
    }
''');
                } else {
                  buffer.writeln('''
    if (!RegExp(r'^[0-9]{13,19}\$').hasMatch($fieldName.replaceAll(RegExp(r'\\s'), ''))) {
      errors.add('$message');
    }
''');
                }
                break;

              /// ===== Phone =====
              case 'Phone':
                final message = value?.getField('message')?.toStringValue() ??
                    '$fieldName is not a valid phone number';

                if (isNullable) {
                  buffer.writeln('''
    if (\$${fieldName}Value != null && !RegExp(r'^\\+?[1-9]\\d{1,14}\$').hasMatch(\$${fieldName}Value.replaceAll(RegExp(r'[\\s\\-\\(\\)]'), ''))) {
      errors.add('$message');
    }
''');
                } else {
                  buffer.writeln('''
    if (!RegExp(r'^\\+?[1-9]\\d{1,14}\$').hasMatch($fieldName.replaceAll(RegExp(r'[\\s\\-\\(\\)]'), ''))) {
      errors.add('$message');
    }
''');
                }
                break;

              /// ===== UUID =====
              case 'UUID':
                final message = value?.getField('message')?.toStringValue() ??
                    '$fieldName is not a valid UUID';

                if (isNullable) {
                  buffer.writeln('''
    if (\$${fieldName}Value != null && !RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}\$').hasMatch(\$${fieldName}Value)) {
      errors.add('$message');
    }
''');
                } else {
                  buffer.writeln('''
    if (!RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}\$').hasMatch($fieldName)) {
      errors.add('$message');
    }
''');
                }
                break;

              /// ===== Alpha =====
              case 'Alpha':
                final message = value?.getField('message')?.toStringValue() ??
                    '$fieldName must contain only letters';

                if (isNullable) {
                  buffer.writeln('''
    if (\$${fieldName}Value != null && !RegExp(r'^[a-zA-Z]+\$').hasMatch(\$${fieldName}Value)) {
      errors.add('$message');
    }
''');
                } else {
                  buffer.writeln('''
    if (!RegExp(r'^[a-zA-Z]+\$').hasMatch($fieldName)) {
      errors.add('$message');
    }
''');
                }
                break;

              /// ===== AlphaNumeric =====
              case 'AlphaNumeric':
                final message = value?.getField('message')?.toStringValue() ??
                    '$fieldName must contain only letters and numbers';

                if (isNullable) {
                  buffer.writeln('''
    if (\$${fieldName}Value != null && !RegExp(r'^[a-zA-Z0-9]+\$').hasMatch(\$${fieldName}Value)) {
      errors.add('$message');
    }
''');
                } else {
                  buffer.writeln('''
    if (!RegExp(r'^[a-zA-Z0-9]+\$').hasMatch($fieldName)) {
      errors.add('$message');
    }
''');
                }
                break;

              /// ===== Required =====
              case 'Required':
                final message = value?.getField('message')?.toStringValue() ??
                    '$fieldName is required';

                if (isNullable) {
                  buffer.writeln('''
    if (\$${fieldName}Value == null) {
      errors.add('$message');
    }
''');
                } else {
                  // For non-nullable fields, Required annotation is redundant
                  // since the type system already ensures non-null values
                  // We can skip the null check for non-nullable fields
                }
                break;

              /// ===== Contains =====
              case 'Contains':
                final substring = value?.getField('substring')?.toStringValue() ?? '';
                final message = value?.getField('message')?.toStringValue();

                if (isNullable) {
                  buffer.writeln('''
    if (\$${fieldName}Value != null && !\$${fieldName}Value.contains('$substring')) {
      errors.add('${message ?? '$fieldName must contain \"$substring\"'}');
    }
''');
                } else {
                  buffer.writeln('''
    if (!$fieldName.contains('$substring')) {
      errors.add('${message ?? '$fieldName must contain \"$substring\"'}');
    }
''');
                }
                break;

              /// ===== StartsWith =====
              case 'StartsWith':
                final prefix = value?.getField('prefix')?.toStringValue() ?? '';
                final message = value?.getField('message')?.toStringValue();

                if (isNullable) {
                  buffer.writeln('''
    if (\$${fieldName}Value != null && !\$${fieldName}Value.startsWith('$prefix')) {
      errors.add('${message ?? '$fieldName must start with \"$prefix\"'}');
    }
''');
                } else {
                  buffer.writeln('''
    if (!$fieldName.startsWith('$prefix')) {
      errors.add('${message ?? '$fieldName must start with \"$prefix\"'}');
    }
''');
                }
                break;

              /// ===== EndsWith =====
              case 'EndsWith':
                final suffix = value?.getField('suffix')?.toStringValue() ?? '';
                final message = value?.getField('message')?.toStringValue();

                if (isNullable) {
                  buffer.writeln('''
    if (\$${fieldName}Value != null && !\$${fieldName}Value.endsWith('$suffix')) {
      errors.add('${message ?? '$fieldName must end with \"$suffix\"'}');
    }
''');
                } else {
                  buffer.writeln('''
    if (!$fieldName.endsWith('$suffix')) {
      errors.add('${message ?? '$fieldName must end with \"$suffix\"'}');
    }
''');
                }
                break;
            }
          }
        }

        buffer.writeln('    return errors;');
        buffer.writeln('  }');

        /// validateOrThrow()
        buffer.writeln('''
  void validateOrThrow() {
    final errors = validate();
    if (errors.isNotEmpty) {
      throw ValidationException(errors.join(', '));
    }
  }
''');

        buffer.writeln('}');
      }
    }

    // 只有当至少有一个类包含验证注解时才返回内容
    if (hasAnyValidationAnnotations) {
      // Add imports at the top
      final finalBuffer = StringBuffer();
      finalBuffer.writeln("import 'package:schema_valid/schema_valid.dart';");
      finalBuffer.writeln("import '${buildStep.inputId.uri.pathSegments.last}';");
      finalBuffer.writeln();
      finalBuffer.write(buffer.toString());
      return finalBuffer.toString();
    } else {
      // 没有验证注解，返回空字符串，不生成文件
      return '';
    }
  }
}

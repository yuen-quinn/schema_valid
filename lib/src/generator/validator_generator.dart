import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class ValidatorGenerator extends Generator {
  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    final buffer = StringBuffer();

    for (final clazz in library.classes) {
      final className = clazz.name;
      buffer.writeln("import 'package:schema_valid/schema_valid.dart';");
      buffer.writeln("import '${buildStep.inputId.uri.pathSegments.last}';");

      buffer.writeln('extension ${className}Validator on $className {');

      /// validate()
      buffer.writeln('  List<String> validate() {');
      buffer.writeln('    final errors = <String>[];');

      for (final field in clazz.fields) {
        final fieldName = field.name;

        for (final meta in field.metadata.toSet()) {
          final value = meta.computeConstantValue();
          final type = value?.type?.getDisplayString(withNullability: false);

          switch (type) {
            /// ===== NotEmpty =====
            case 'NotEmpty':
              final message = value?.getField('message')?.toStringValue() ??
                  '$fieldName cannot be empty';

              buffer.writeln('''
if ($fieldName.isEmpty) {
  errors.add('$message');
}
''');
              break;

            /// ===== Length =====
            case 'Length':
              final min = value?.getField('min')?.toIntValue();
              final max = value?.getField('max')?.toIntValue();
              final message = value?.getField('message')?.toStringValue();

              if (min != null) {
                buffer.writeln('''
if ($fieldName.length < $min) {
  errors.add('${message ?? '$fieldName min length is $min'}');
}
''');
              }

              if (max != null) {
                buffer.writeln('''
if ($fieldName.length > $max) {
  errors.add('${message ?? '$fieldName max length is $max'}');
}
''');
              }
              break;

            /// ===== Email =====
            case 'Email':
              final message = value?.getField('message')?.toStringValue() ??
                  '$fieldName is not a valid email';

              buffer.writeln('''
if (!RegExp(r'^[^@]+@[^@]+\\.[^@]+\$').hasMatch($fieldName)) {
  errors.add('$message');
}
''');
              break;

            /// ===== Url =====
            case 'Url':
              final message = value?.getField('message')?.toStringValue() ??
                  '$fieldName is not a valid url';

              buffer.writeln('''
if (Uri.tryParse($fieldName) == null) {
  errors.add('$message');
}
''');
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

    return buffer.toString();
  }
}

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'generator/validator_generator.dart';

Builder validatorBuilder(BuilderOptions options) =>
    LibraryBuilder(
      ValidatorGenerator(),
      generatedExtension: '.validator.dart',
    );
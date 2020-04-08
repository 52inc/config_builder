import 'dart:async';
import 'dart:convert';
import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:meta/meta.dart';

Builder jsonConfigBuilder(BuilderOptions options) => ConfigBuilder();

const classHeader = '''
/// FILE GENERATED! DO NOT TOUCH! 
class Config {
  Config._();
  
''';

class ConfigBuilder extends Builder {

  @override
  Map<String, List<String>> get buildExtensions =>
      const <String, List<String>>{'.config.json' : <String>['.config.dart', '.dart']};

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final AssetId outputId = buildStep.inputId.changeExtension('.dart');
    Map<String, Object> source = json.decode(await buildStep.readAsString(buildStep.inputId));

    final StringBuffer output = StringBuffer();
    ConfigGenerator().generate(source, output);

    String outputString;
    // Always output something to keep hot reload working.
    try {
      outputString = DartFormatter().format(output.toString()).toString();
    } catch (err) {
      outputString = r'''
      class Config {
        Config._();
      ''';
      outputString += "\n// ERR: $err \n}";
    }

    await buildStep.writeAsString(outputId, outputString);
    await buildStep.writeAsString(AssetId(buildStep.inputId.package, "config.dart"),
    "export ${outputId.path}${outputId.extension};");
  }


}

@visibleForTesting
class ConfigGenerator {
  const ConfigGenerator();

  void generate(Map<String, Object> config, StringBuffer buffer) {
    // Write the config class header
    buffer.write(classHeader);

    // Write all the key-value times to the store
    config.forEach((key, value) {
      _writeConstant(buffer, key, value);
    });

    buffer.write('}');
  }

  void _writeConstant(StringBuffer output, String name, Object value) {
    if (value is Iterable) {
      if (value.isNotEmpty) {
        Type listType;
        StringBuffer listBuffer = StringBuffer();
        for (var element in value) {
          if (listType == null) {
            listType = element.runtimeType;
          } else if (listType != element.runtimeType) {
            // CONFLICTING TYPES!!! CLEAR BUFFER AND BREAK;
            listBuffer.clear();
            break;
          }

          if (element is String) {
            listBuffer.writeln("    \"$element\",");
          } else {
            listBuffer.writeln("    $element,");
          }
        }

        if (listBuffer.isNotEmpty) {
          output.writeln("  static List<$listType> $name = [");
          output.write(listBuffer.toString());
          output.writeln("  ];");
        }
      }
    } else {
      var trueValue = value is String ? "\"$value\"" : "$value";
      output.writeln("  static ${value.runtimeType} $name = $trueValue;");
    }
  }
}

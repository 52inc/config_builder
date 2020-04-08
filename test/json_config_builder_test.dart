import 'dart:convert';
import 'package:json_config_builder/json_config_builder.dart';
import 'package:test/test.dart';

const example = '''
{
  "apiUrl": "https://example.com",
  "maxDownloads": 5,
  "friction": 2.54321,
  "logging": true,
  "messages": [
    "message1", 
    "message2", 
    "message3"
  ]
}
''';

const expected = '''
/// FILE GENERATED! DO NOT TOUCH! 
class Config {
  Config._();
  
  static String apiUrl = "https://example.com";
  static int maxDownloads = 5;
  static double friction = 2.54321;
  static bool logging = true;
  static List<String> messages = [
    "message1",
    "message2",
    "message3",
  ];
}''';


const example2 = '''
{
  "apiUrl": "https://example.com",
  "maxDownloads": 5,
  "friction": 2.54321,
  "logging": true,
  "messages": [
    "message1", 
    5, 
    true
  ]
}
''';

const expected2 = '''
/// FILE GENERATED! DO NOT TOUCH! 
class Config {
  Config._();
  
  static String apiUrl = "https://example.com";
  static int maxDownloads = 5;
  static double friction = 2.54321;
  static bool logging = true;
}''';

void main() {
  test('can generate config file', () {
    var generator = ConfigGenerator();
    var buffer = StringBuffer();

    generator.generate(json.decode(example), buffer);

    expect(buffer.toString(), expected);
  });

  test('will skip arrays with different types', () {
    var generator = ConfigGenerator();
    var buffer = StringBuffer();

    generator.generate(json.decode(example2), buffer);

    expect(buffer.toString(), expected2);
  });
}

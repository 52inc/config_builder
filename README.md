# Config Builder

A builder to create a configuration dart file from a json spec

## Getting Started

Create a configuration json file using the name template `example.config.json` that only
uses first level fields and single primitive type arrays.

### Example

```json
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
```

Will output something like this:

```dart
Config() {
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
}
```

You can then import it via:

```dart
import 'package:your_package_name/config.dart';
```

## Usage

In your `pubspec.yaml`:

```yaml
name: example

...

builders:
  json_config_builder: ^0.0.4
```

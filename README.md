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

## Usage

In your `pubspec.yaml`:

```yaml
name: example

...

builders:
  config_builder: ^0.0.1
```

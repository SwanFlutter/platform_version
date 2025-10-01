# Platform Version Plugin

A Flutter plugin for getting the current platform version information.

## Description

This plugin provides the ability to retrieve current platform version information in Flutter applications. The plugin supports all major platforms including Android, iOS, Web, Windows, macOS, and Linux.

## Supported Platforms

- ✅ Android
- ✅ iOS  
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## Installation

### 1. Add Dependency

Open your project's `pubspec.yaml` file and add the following dependency:

```yaml
dependencies:
  platform_version:
    git:
      url: https://github.com/your-username/platform_version.git
```

Or if published on pub.dev:

```yaml
dependencies:
  platform_version: ^0.0.1
```

### 2. Install Packages

```bash
flutter pub get
```

### 3. Import the Plugin

```dart
import 'package:platform_version/platform_version.dart';
```

## Usage

### Simple Usage

```dart
import 'package:flutter/material.dart';
import 'package:platform_version/platform_version.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _platformVersionPlugin = PlatformVersion();

  @override
  void initState() {
    super.initState();
    _getPlatformVersion();
  }

  Future<void> _getPlatformVersion() async {
    String platformVersion;
    try {
      platformVersion = await _platformVersionPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } catch (e) {
      platformVersion = 'Failed to get platform version: $e';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Platform Version Example'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion'),
        ),
      ),
    );
  }
}
```

### Advanced Usage with Error Handling

```dart
import 'package:flutter/services.dart';
import 'package:platform_version/platform_version.dart';

class PlatformService {
  static final _platformVersionPlugin = PlatformVersion();

  static Future<String> getPlatformInfo() async {
    try {
      final version = await _platformVersionPlugin.getPlatformVersion();
      return version ?? 'Unknown platform version';
    } on PlatformException catch (e) {
      return 'Error getting platform information: ${e.message}';
    } catch (e) {
      return 'Unexpected error: $e';
    }
  }
}
```

## API Reference

### `PlatformVersion` Class

#### Methods

##### `getPlatformVersion()`

Returns the current platform version.

**Returns:** `Future<String?>`

**Example:**
```dart
final platformVersion = PlatformVersion();
String? version = await platformVersion.getPlatformVersion();
```

**Output on different platforms:**
- **Android:** Android version (e.g., "Android 13")
- **iOS:** iOS version (e.g., "iOS 16.0")
- **Web:** Browser User Agent
- **Windows:** Windows version
- **macOS:** macOS version
- **Linux:** Linux distribution information

## Complete Example

To see the complete example, check the `example/lib/main.dart` file.

```bash
cd example
flutter run
```

## Development and Contributing

### Prerequisites

- Flutter SDK (version 3.3.0 or higher)
- Dart SDK (version 3.9.2 or higher)

### Setting up Development Environment

1. Clone the project:
```bash
git clone https://github.com/your-username/platform_version.git
cd platform_version
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run tests:
```bash
flutter test
```

4. Run the example:
```bash
cd example
flutter pub get
flutter run
```

### Project Structure

```
platform_version/
├── lib/
│   ├── platform_version.dart              # Main plugin API
│   ├── platform_version_platform_interface.dart  # Platform interface
│   ├── platform_version_method_channel.dart      # Method Channel implementation
│   └── platform_version_web.dart          # Web implementation
├── android/                               # Native Android code
├── ios/                                   # Native iOS code
├── linux/                                 # Native Linux code
├── macos/                                 # Native macOS code
├── windows/                               # Native Windows code
├── example/                               # Example application
└── test/                                  # Unit tests
```

## License

This project is released under the MIT License. For more information, see the [LICENSE](LICENSE) file.

## Issues and Suggestions

If you encounter any issues or have suggestions, please report them in the [Issues](https://github.com/your-username/platform_version/issues) section.

## Changelog

To view the change history, see the [CHANGELOG.md](CHANGELOG.md) file.
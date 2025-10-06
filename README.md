# Platform Version Plugin

A Flutter plugin for getting the current platform version information and comprehensive device details.

## Description

This plugin provides the ability to retrieve current platform version information and detailed device information in Flutter applications. The plugin supports all major platforms including Android, iOS, Web, Windows, macOS, and Linux.

## Features

- 🔍 Get platform version information
- 📱 Retrieve comprehensive device information
- 🌐 Cross-platform support (Android, iOS, Web, Windows, macOS, Linux)
- 🚀 Easy to use API
- ⚡ Asynchronous operations

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
      url: https://github.com/SwanFlutter/platform_version.git
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

### Simple Usage - Platform Version

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

### Device Information Usage

```dart
import 'package:flutter/material.dart';
import 'package:platform_version/platform_version.dart';

class DeviceInfoApp extends StatefulWidget {
  @override
  _DeviceInfoAppState createState() => _DeviceInfoAppState();
}

class _DeviceInfoAppState extends State<DeviceInfoApp> {
  String _platformVersion = 'Unknown';
  Map<String, dynamic> _deviceInfo = {};
  final _platformVersionPlugin = PlatformVersion();

  @override
  void initState() {
    super.initState();
    _initPlatformState();
  }

  Future<void> _initPlatformState() async {
    String platformVersion;
    Map<String, dynamic> deviceInfo;
    
    try {
      platformVersion = await _platformVersionPlugin.getPlatformVersion() ?? 'Unknown platform version';
      deviceInfo = await _platformVersionPlugin.getDeviceInfo();
    } catch (e) {
      platformVersion = 'Failed to get platform version: $e';
      deviceInfo = {'error': 'Failed to get device info: $e'};
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _deviceInfo = deviceInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Device Information Example'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Platform Version:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(_platformVersion),
              SizedBox(height: 20),
              Text(
                'Device Information:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ..._deviceInfo.entries.map((entry) => Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0),
                child: Text('${entry.key}: ${entry.value}'),
              )).toList(),
            ],
          ),
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

  static Future<Map<String, dynamic>> getDeviceInformation() async {
    try {
      final deviceInfo = await _platformVersionPlugin.getDeviceInfo();
      return deviceInfo;
    } on PlatformException catch (e) {
      return {'error': 'Error getting device information: ${e.message}'};
    } catch (e) {
      return {'error': 'Unexpected error: $e'};
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

##### `getDeviceInfo()`

Returns comprehensive device information as a Map.

**Returns:** `Future<Map<String, dynamic>>`

**Example:**
```dart
final platformVersion = PlatformVersion();
Map<String, dynamic> deviceInfo = await platformVersion.getDeviceInfo();
```

**Output on different platforms:**

**Android:**
- `brand`: Device brand (e.g., "Samsung")
- `model`: Device model (e.g., "Galaxy S23")
- `version`: Android version (e.g., "13")
- `sdkInt`: Android SDK version (e.g., 33)
- `manufacturer`: Device manufacturer

**iOS:**
- `name`: Device name (e.g., "iPhone")
- `model`: Device model (e.g., "iPhone14,2")
- `systemName`: System name (e.g., "iOS")
- `systemVersion`: iOS version (e.g., "16.0")

**Web:**
- `platform`: Browser platform
- `userAgent`: Full user agent string
- `language`: Browser language
- `cookieEnabled`: Cookie support status
- `onLine`: Online status

**Windows/macOS/Linux:**
- Platform-specific system information

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
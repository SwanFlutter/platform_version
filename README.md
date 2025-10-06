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
    # platform_version

    A small, cross-platform Flutter plugin that exposes the current platform version and useful device information to Dart code.

    This repository provides native implementations for Android, iOS, Windows, macOS, Linux and a web implementation. Use it when you need a simple API to read the OS version and basic device/system metadata.

    Current package version: 0.0.1

    ## Key features

    - Get the current platform/OS version (e.g. "Android 13", "iOS 16.2").
    - Retrieve a Map of device/system information (brand, model, SDK version, user agent, etc.).
    - Supports: Android, iOS, Web, Windows, macOS, Linux.

    ## Installation

    Add the package to your project's `pubspec.yaml`:

    From pub.dev (when published):

    ```yaml
    dependencies:
      platform_version: ^0.0.1
    ```

    From Git:

    ```yaml
    dependencies:
      platform_version:
        git:
          url: https://github.com/SwanFlutter/platform_version.git
    ```

    Then install:

    ```bash
    flutter pub get
    ```

    ## Quick example

    ```dart
    import 'package:flutter/material.dart';
    import 'package:platform_version/platform_version.dart';

    void main() => runApp(const MyApp());

    class MyApp extends StatefulWidget {
      const MyApp({super.key});
      @override
      State<MyApp> createState() => _MyAppState();
    }

    class _MyAppState extends State<MyApp> {
      final _plugin = PlatformVersion();
      String _version = 'Unknown';
      Map<String, dynamic> _deviceInfo = {};

      @override
      void initState() {
        super.initState();
        _init();
      }

      Future<void> _init() async {
        try {
          final version = await _plugin.getPlatformVersion();
          final info = await _plugin.getDeviceInfo();
          if (!mounted) return;
          setState(() {
            _version = version ?? 'Unknown';
            _deviceInfo = info;
          });
        } catch (e) {
          // handle or log
        }
      }

      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('platform_version example')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Platform version: $_version'),
                  const SizedBox(height: 12),
                  const Text('Device info:'),
                  ..._deviceInfo.entries.map((e) => Text('${e.key}: ${e.value}'))
                ],
              ),
            ),
          ),
        );
      }
    }
    ```

    ## API

    Public class: `PlatformVersion`

    - Future<String?> getPlatformVersion()
      - Returns a human-friendly platform/OS version (or null).

    - Future<Map<String, dynamic>> getDeviceInfo()
      - Returns platform-specific key/value information about the device or runtime.

    Refer to the source files in `lib/` for more details and platform-specific keys.

    ## Example app

    See `example/lib/main.dart` for a complete example using the plugin.

    ## Development

    Requirements:

    - Flutter >= 3.3.0
    - Dart >= 3.9.2

    To run the example:

    ```bash
    cd example
    flutter pub get
    flutter run
    ```

    Run unit tests:

    ```bash
    flutter test
    ```

    ## Contributing

    Contributions are welcome. Open issues or pull requests for bug fixes, features, or docs improvements. Please follow the existing code style and add tests for new behavior.

    ## License

    This project is licensed under the MIT License. See `LICENSE` for details.

    ## Changelog

    The changelog is maintained in `CHANGELOG.md`.
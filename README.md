# platform_version

A cross-platform Flutter plugin for retrieving current platform version information and comprehensive device details.

[![platform_version](https://img.shields.io/pub/v/platform_version.svg)](https://pub.dev/packages/platform_version)
[![Coverage](https://codecov.io/gh/SwanFlutter/platform_version/branch/main/graph/badge.svg)](https://codecov.io/gh/SwanFlutter/platform_version)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![GitHub stars](https://img.shields.io/github/stars/SwanFlutter/platform_version?style=social)](https://github.com/SwanFlutter/platform_version/)

## Overview

A lightweight, cross-platform Flutter plugin that exposes the current platform version and useful device information to Dart code. This plugin provides native implementations for Android, iOS, Windows, macOS, Linux, and Web platforms.

**Current version:** 0.0.3

## Features

- 🔍 Get platform/OS version information (e.g., "Android 13", "iOS 16.2")
- 📱 Retrieve comprehensive device information (brand, model, SDK version, user agent, etc.)
- 🌐 Full cross-platform support
- 🚀 Simple and intuitive API
- ⚡ Asynchronous operations
- 🎯 Type-safe with null safety support
- 📦 Zero external dependencies
- 🧪 Well-tested and production-ready

## Supported Platforms

| Platform | Minimum | Status | Notes |
|----------|---------|--------|-------|
| Android  | API 21+ (Android 5.0+) | ✅ Supported | `android/build.gradle` sets `minSdk = 21` |
| iOS      | 9.0+    | ✅ Supported | `ios/platform_version.podspec` sets platform iOS 9.0 |
| Web      | Any     | ✅ Supported | Web implementation available |
| Windows  | 10+     | ✅ Supported | Plugin returns Windows major version; supports Windows 10 and newer |
| macOS    | 10.11+  | ✅ Supported | `macos/platform_version.podspec` sets macOS 10.11 |
| Linux    | Any     | ✅ Supported | Linux implementation provided (GTK) |

## Installation

### 1. Add Dependency

Add the following to your project's `pubspec.yaml`:

**From pub.dev:**

```yaml
dependencies:
  platform_version: ^0.0.3
```

**From Git (latest):**

```yaml
dependencies:
  platform_version:
    git:
      url: https://github.com/SwanFlutter/platform_version.git
```

### 2. Install Packages

```bash
flutter pub get
```

### 3. Import the Plugin

```dart
import 'package:platform_version/platform_version.dart';
```

## Platform Configuration

### Android Configuration

The plugin supports Android 5.0 (API level 21) and above. No additional configuration is required in most cases.

#### Optional: Verify Minimum SDK in Your App

Ensure your app's `android/app/build.gradle` has a minimum SDK of 21 or higher:

```gradle
android {
    defaultConfig {
        minSdkVersion 21  // Or higher
        targetSdkVersion flutter.targetSdkVersion
        // ...
    }
}
```

#### Permissions

This plugin does not require any special permissions. However, if you need device information for analytics or debugging, ensure you have the appropriate privacy policy in place.

**Note:** The plugin uses standard Android APIs that don't require additional permissions:
- `Build.BRAND`
- `Build.MODEL`
- `Build.MANUFACTURER`
- `Build.VERSION.SDK_INT`
- `Build.VERSION.RELEASE`
- `Build.DEVICE`
- `Build.HARDWARE`

### iOS Configuration

The plugin supports iOS 9.0 and above. No additional configuration is required.

#### Optional: Verify Deployment Target

Ensure your app's iOS deployment target is set to 9.0 or higher. Check your `ios/Podfile`:

```ruby
platform :ios, '9.0'
```

Alternatively, you can set it in Xcode:
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the **Runner** project in the navigator
3. Select the **Runner** target
4. Go to **General** > **Deployment Info**
5. Set **iOS Deployment Target** to 9.0 or higher

#### Privacy Considerations

The plugin accesses the following device information:
- Device name (`UIDevice.current.name`)
- Device model (`UIDevice.current.model`)
- System name (`UIDevice.current.systemName`)
- System version (`UIDevice.current.systemVersion`)
- Identifier for vendor (`UIDevice.current.identifierForVendor`)

These APIs don't require special permissions but should be used according to Apple's privacy guidelines.

### Web Configuration

No configuration required. The plugin works out-of-the-box on web platforms.

### Windows/macOS/Linux Configuration

No additional configuration required for desktop platforms.

## Usage

### Quick Start

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
  String _platformVersion = 'Unknown';
  Map<String, dynamic> _deviceInfo = {};

  @override
  void initState() {
    super.initState();
    _initPlatformState();
  }

  Future<void> _initPlatformState() async {
    try {
      // Get platform version
      final version = await _plugin.getPlatformVersion();
      
      // Get device information
      final info = await _plugin.getDeviceInfo();
      
      if (!mounted) return;
      
      setState(() {
        _platformVersion = version ?? 'Unknown';
        _deviceInfo = info;
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Platform Version Example'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Platform Version',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _platformVersion,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Device Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Card(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _deviceInfo.length,
                    itemBuilder: (context, index) {
                      final entry = _deviceInfo.entries.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                '${entry.key}:',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text('${entry.value}'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## API Reference

### Class: `PlatformVersion`

Main plugin class providing access to platform and device information.

#### Methods

##### `getPlatformVersion()`

```dart
Future<String?> getPlatformVersion()
```

Returns a human-readable platform/OS version string.

**Returns:**
- `String?` - Platform version or `null` if unavailable

**Examples:**
- Android: `"Android 13"`
- iOS: `"iOS 16.2"`
- Windows: `"Windows 10"`
- macOS: `"macOS 13.0"`
- Linux: `"Linux 5.15.0"`
- Web: Browser and version info

**Usage:**

```dart
final plugin = PlatformVersion();
final version = await plugin.getPlatformVersion();
print('Running on: $version');
```

##### `getDeviceInfo()`

```dart
Future<Map<String, dynamic>> getDeviceInfo()
```

Returns comprehensive device/system information as a key-value map.

This map includes a cross-platform `stableDeviceId` field that is generated once per installation/user profile and persisted using the most appropriate mechanism per platform.

**Returns:**
- `Map<String, dynamic>` - Platform-specific device information

**Platform-Specific Information:**

**Android:**
```dart
{
  'brand': 'Samsung',           // Device brand
  'model': 'SM-G998B',          // Device model
  'manufacturer': 'Samsung',    // Manufacturer name
  'sdkVersion': '33',           // Android SDK version
  'androidVersion': '13',       // Android version
  'device': 'Galaxy S21',       // Device name
  'hardware': 'exynos2100',     // Hardware name
  'isPhysicalDevice': true,     // Physical device flag
  'stableDeviceId': '...'       // Stable device ID
}
```

**iOS:**
```dart
{
  'name': 'iPhone 14 Pro',      // Device name
  'model': 'iPhone15,2',        // Device model
  'systemName': 'iOS',          // System name
  'systemVersion': '16.2',      // iOS version
  'identifierForVendor': '...', // Unique vendor ID
  'isPhysicalDevice': true,     // Physical device flag
  'utsname': {...},             // System information
  'stableDeviceId': '...'       // Stable device ID
}
```

**Web:**
```dart
{
  'userAgent': '...',           // Browser user agent
  'platform': 'MacIntel',       // Platform identifier
  'vendor': 'Google Inc.',      // Browser vendor
  'language': 'en-US',          // Browser language
  'languages': ['en-US', ...],  // Supported languages
  'hardwareConcurrency': 8,     // CPU cores
  'deviceMemory': 8,            // Device memory (GB)
  'stableDeviceId': '...'       // Stable device ID
}
```

**Windows/macOS/Linux:**
```dart
{
  'osName': 'Windows',          // Operating system name
  'osVersion': '10.0.19044',    // OS version
  'computerName': 'MY-PC',      // Computer name
  'numberOfCores': 8,           // CPU cores
  'systemMemory': 16384,        // RAM in MB
  'stableDeviceId': '...'       // Stable device ID
}
```

**Usage:**

```dart
final plugin = PlatformVersion();
final info = await plugin.getDeviceInfo();

final stableDeviceId = info['stableDeviceId'] as String?;
print('Stable Device ID: $stableDeviceId');

// Access specific information
final brand = info['brand'] as String?;
final model = info['model'] as String?;

// Iterate through all information
info.forEach((key, value) {
  print('$key: $value');
});
```

##### `getStableDeviceId()`

```dart
Future<String?> getStableDeviceId()
```

Convenience helper to read `stableDeviceId` from `getDeviceInfo()`.

**Usage:**

```dart
final plugin = PlatformVersion();
final id = await plugin.getStableDeviceId();
print('Stable Device ID: $id');
```

## Advanced Usage Examples

### Conditional Platform Logic

```dart
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:platform_version/platform_version.dart';

Future<void> checkPlatform() async {
  final plugin = PlatformVersion();
  
  if (kIsWeb) {
    // Web-specific logic
    final info = await plugin.getDeviceInfo();
    print('Browser: ${info['userAgent']}');
  } else if (Platform.isAndroid) {
    // Android-specific logic
    final info = await plugin.getDeviceInfo();
    print('Android device: ${info['brand']} ${info['model']}');
  } else if (Platform.isIOS) {
    // iOS-specific logic
    final info = await plugin.getDeviceInfo();
    print('iOS device: ${info['name']}');
  }
}
```

### Feature Detection

```dart
Future<bool> supportsFeature() async {
  final plugin = PlatformVersion();
  final info = await plugin.getDeviceInfo();
  
  if (Platform.isAndroid) {
    final sdkVersion = int.tryParse(info['sdkVersion'] ?? '0') ?? 0;
    return sdkVersion >= 28; // Android 9.0+
  } else if (Platform.isIOS) {
    final version = info['systemVersion'] as String? ?? '0';
    final majorVersion = int.tryParse(version.split('.').first) ?? 0;
    return majorVersion >= 13; // iOS 13+
  }
  
  return false;
}
```

### Error Handling

```dart
import 'package:flutter/services.dart';

Future<void> safeGetPlatformInfo() async {
  final plugin = PlatformVersion();
  
  try {
    final version = await plugin.getPlatformVersion();
    final info = await plugin.getDeviceInfo();
    
    print('Version: $version');
    print('Device Info: $info');
    
  } on PlatformException catch (e) {
    // Handle platform-specific errors
    print('Platform error: ${e.code} - ${e.message}');
    
  } on MissingPluginException catch (e) {
    // Handle missing plugin implementation
    print('Plugin not implemented for this platform: $e');
    
  } catch (e) {
    // Handle unexpected errors
    print('Unexpected error: $e');
  }
}
```

### Device Analytics

```dart
class DeviceAnalytics {
  final PlatformVersion _plugin = PlatformVersion();
  
  Future<Map<String, dynamic>> collectAnalytics() async {
    final version = await _plugin.getPlatformVersion();
    final info = await _plugin.getDeviceInfo();
    
    return {
      'timestamp': DateTime.now().toIso8601String(),
      'platform_version': version,
      'device_info': info,
      'app_version': '1.0.0', // Your app version
    };
  }
  
  Future<void> sendToAnalytics() async {
    final data = await collectAnalytics();
    // Send to your analytics service
    print('Analytics data: $data');
  }
}
```




## Support

- 🐛 **Bug Reports:** [GitHub Issues](https://github.com/SwanFlutter/platform_version/issues)
- 💬 **Questions:** [GitHub Discussions](https://github.com/SwanFlutter/platform_version/discussions)
- 📧 **Email:** swan.dev1993@gmail.com



---


<div align="center">

**If you find this package useful, please ⭐ star the repo!**

Made with ❤️ by SwanFlutter

</div>
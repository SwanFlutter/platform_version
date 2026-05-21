import 'platform_version_platform_interface.dart';

/// Main entry-point for the `platform_version` plugin.
///
/// Example:
/// ```dart
/// final plugin = PlatformVersion();
/// final version = await plugin.getPlatformVersion();
/// final info = await plugin.getDeviceInfo();
/// ```
class PlatformVersion {
  Future<String?> getPlatformVersion() {
    return PlatformVersionPlatform.instance.getPlatformVersion();
  }

  Future<Map<String, dynamic>?> getDeviceInfo() {
    return PlatformVersionPlatform.instance.getDeviceInfo();
  }

  /// Returns the version of the application.
  Future<String?> getAppVersion() {
    return PlatformVersionPlatform.instance.getAppVersion();
  }

  /// Returns a cross-platform stable device identifier.
  ///
  /// Example:
  /// ```dart
  /// final plugin = PlatformVersion();
  /// final stableDeviceId = await plugin.getStableDeviceId();
  /// print('Stable Device ID: $stableDeviceId');
  /// ```
  Future<String?> getStableDeviceId() async {
    final info = await getDeviceInfo();
    final value = info?['stableDeviceId'];
    if (value is String) return value;
    return value?.toString();
  }
}

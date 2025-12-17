import 'platform_version_platform_interface.dart';

class PlatformVersion {
  Future<String?> getPlatformVersion() {
    return PlatformVersionPlatform.instance.getPlatformVersion();
  }

  Future<Map<String, dynamic>?> getDeviceInfo() {
    return PlatformVersionPlatform.instance.getDeviceInfo();
  }

  Future<String?> getStableDeviceId() async {
    final info = await getDeviceInfo();
    final value = info?['stableDeviceId'];
    if (value is String) return value;
    return value?.toString();
  }
}

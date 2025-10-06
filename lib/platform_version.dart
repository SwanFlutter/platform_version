import 'platform_version_platform_interface.dart';

class PlatformVersion {
  Future<String?> getPlatformVersion() {
    return PlatformVersionPlatform.instance.getPlatformVersion();
  }

  Future<Map<String, dynamic>?> getDeviceInfo() {
    return PlatformVersionPlatform.instance.getDeviceInfo();
  }
}

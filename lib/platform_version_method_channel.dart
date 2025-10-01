import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'platform_version_platform_interface.dart';

/// An implementation of [PlatformVersionPlatform] that uses method channels.
class MethodChannelPlatformVersion extends PlatformVersionPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('platform_version');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'platform_version_method_channel.dart';

abstract class PlatformVersionPlatform extends PlatformInterface {
  /// Constructs a PlatformVersionPlatform.
  PlatformVersionPlatform() : super(token: _token);

  static final Object _token = Object();

  static PlatformVersionPlatform _instance = MethodChannelPlatformVersion();

  /// The default instance of [PlatformVersionPlatform] to use.
  ///
  /// Defaults to [MethodChannelPlatformVersion].
  static PlatformVersionPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PlatformVersionPlatform] when
  /// they register themselves.
  static set instance(PlatformVersionPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Map<String, dynamic>?> getDeviceInfo() {
    throw UnimplementedError('getDeviceInfo() has not been implemented.');
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:platform_version/platform_version.dart';
import 'package:platform_version/platform_version_platform_interface.dart';
import 'package:platform_version/platform_version_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPlatformVersionPlatform
    with MockPlatformInterfaceMixin
    implements PlatformVersionPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PlatformVersionPlatform initialPlatform = PlatformVersionPlatform.instance;

  test('$MethodChannelPlatformVersion is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPlatformVersion>());
  });

  test('getPlatformVersion', () async {
    PlatformVersion platformVersionPlugin = PlatformVersion();
    MockPlatformVersionPlatform fakePlatform = MockPlatformVersionPlatform();
    PlatformVersionPlatform.instance = fakePlatform;

    expect(await platformVersionPlugin.getPlatformVersion(), '42');
  });
}

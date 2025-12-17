// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'dart:math';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'platform_version_platform_interface.dart';

/// A web implementation of the PlatformVersionPlatform of the PlatformVersion plugin.
class PlatformVersionWeb extends PlatformVersionPlatform {
  /// Constructs a PlatformVersionWeb
  PlatformVersionWeb();

  static void registerWith(Registrar registrar) {
    PlatformVersionPlatform.instance = PlatformVersionWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = web.window.navigator.userAgent;
    return version;
  }

  /// Returns a [Map] containing device information for web platform.
  @override
  Future<Map<String, dynamic>?> getDeviceInfo() async {
    final navigator = web.window.navigator;
    final stableDeviceId = _getOrCreateStableDeviceId();
    return {
      'stableDeviceId': stableDeviceId,
      'platform': navigator.platform,
      'userAgent': navigator.userAgent,
      'language': navigator.language,
      'languages': navigator.languages,
      'cookieEnabled': navigator.cookieEnabled,
      'onLine': navigator.onLine,
      'vendor': navigator.vendor,
      'vendorSub': navigator.vendorSub,
      'product': navigator.product,
      'productSub': navigator.productSub,
      'appName': navigator.appName,
      'appVersion': navigator.appVersion,
      'appCodeName': navigator.appCodeName,
    };
  }

  String _getOrCreateStableDeviceId() {
    const storageKey = 'platform_version_stable_device_id';

    try {
      final storage = web.window.localStorage;
      final existing = storage.getItem(storageKey);
      if (existing != null && existing.isNotEmpty) return existing;

      final newId = _generateId();
      storage.setItem(storageKey, newId);
      return newId;
    } catch (_) {
      return _generateId();
    }
  }

  String _generateId() {
    final rand = Random();
    final ts = DateTime.now().microsecondsSinceEpoch;
    final r1 = rand.nextInt(1 << 30);
    final r2 = rand.nextInt(1 << 30);
    return '$ts-$r1-$r2';
  }
}

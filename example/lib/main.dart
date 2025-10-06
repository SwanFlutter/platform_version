import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:platform_version/platform_version.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  Map<String, dynamic>? _deviceInfo;
  final _platformVersionPlugin = PlatformVersion();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    Map<String, dynamic>? deviceInfo;
    
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _platformVersionPlugin.getPlatformVersion() ??
          'Unknown platform version';
      deviceInfo = await _platformVersionPlugin.getDeviceInfo();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
      deviceInfo = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
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
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Platform Version:',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(_platformVersion),
                const SizedBox(height: 24),
                Text(
                  'Device Information:',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                if (_deviceInfo != null) ...[
                  for (final entry in _deviceInfo!.entries)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(
                              '${entry.key}:',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              entry.value?.toString() ?? 'N/A',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                ] else
                  const Text('No device information available'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

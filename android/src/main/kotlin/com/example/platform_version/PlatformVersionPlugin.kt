package com.example.platform_version

import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** PlatformVersionPlugin */
class PlatformVersionPlugin :
    FlutterPlugin,
    MethodCallHandler {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "platform_version")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${Build.VERSION.RELEASE}")
            }
            "getDeviceInfo" -> {
                val deviceInfo = getDeviceInfo()
                result.success(deviceInfo)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun getDeviceInfo(): Map<String, Any> {
        return mapOf(
            "brand" to Build.BRAND,
            "model" to Build.MODEL,
            "manufacturer" to Build.MANUFACTURER,
            "device" to Build.DEVICE,
            "product" to Build.PRODUCT,
            "version" to Build.VERSION.RELEASE,
            "sdkInt" to Build.VERSION.SDK_INT,
            "codename" to Build.VERSION.CODENAME,
            "incremental" to Build.VERSION.INCREMENTAL,
            "board" to Build.BOARD,
            "hardware" to Build.HARDWARE,
            "fingerprint" to Build.FINGERPRINT,
            "host" to Build.HOST,
            "id" to Build.ID,
            "tags" to Build.TAGS,
            "type" to Build.TYPE,
            "user" to Build.USER
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}

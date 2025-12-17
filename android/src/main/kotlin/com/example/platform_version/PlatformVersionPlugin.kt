package com.example.platform_version

import android.content.Context
import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.UUID

/** PlatformVersionPlugin */
class PlatformVersionPlugin :
    FlutterPlugin,
    MethodCallHandler {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var applicationContext: Context

    private val prefsName = "platform_version"
    private val stableDeviceIdKey = "stable_device_id"

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = flutterPluginBinding.applicationContext
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
            "stableDeviceId" to getOrCreateStableDeviceId(),
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

    private fun getOrCreateStableDeviceId(): String {
        val prefs = applicationContext.getSharedPreferences(prefsName, Context.MODE_PRIVATE)
        val existing = prefs.getString(stableDeviceIdKey, null)
        if (!existing.isNullOrBlank()) return existing

        val newId = UUID.randomUUID().toString()
        prefs.edit().putString(stableDeviceIdKey, newId).apply()
        return newId
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}

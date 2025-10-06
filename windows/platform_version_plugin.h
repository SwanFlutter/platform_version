#ifndef FLUTTER_PLUGIN_PLATFORM_VERSION_PLUGIN_H_
#define FLUTTER_PLUGIN_PLATFORM_VERSION_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>

namespace platform_version {

class PlatformVersionPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  PlatformVersionPlugin();

  virtual ~PlatformVersionPlugin();

  // Disallow copy and assign.
  PlatformVersionPlugin(const PlatformVersionPlugin&) = delete;
  PlatformVersionPlugin& operator=(const PlatformVersionPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

 private:
  // Returns device information as a map.
  flutter::EncodableMap GetDeviceInfo();
};

}  // namespace platform_version

#endif  // FLUTTER_PLUGIN_PLATFORM_VERSION_PLUGIN_H_

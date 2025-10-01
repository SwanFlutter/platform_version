#include "platform_version_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>

namespace platform_version {

// static
void PlatformVersionPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "platform_version",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<PlatformVersionPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

PlatformVersionPlugin::PlatformVersionPlugin() {}

PlatformVersionPlugin::~PlatformVersionPlugin() {}

// Function to get the exact Windows version
    DWORD GetWindowsVersion() {
        NTSTATUS(WINAPI *RtlGetVersion)(LPOSVERSIONINFOW);
        OSVERSIONINFOW osvi = { sizeof(osvi) };

        *(FARPROC*)&RtlGetVersion = GetProcAddress(GetModuleHandleA("ntdll.dll"), "RtlGetVersion");
        if (RtlGetVersion == nullptr) {
            return 0;
        }

        if (RtlGetVersion(&osvi) != 0) {
            return 0;
        }

        return osvi.dwMajorVersion;
    }

    void PlatformVersionPlugin::HandleMethodCall(
            const flutter::MethodCall<flutter::EncodableValue> &method_call,
            std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
        if (method_call.method_name().compare("getPlatformVersion") == 0) {
            std::ostringstream version_stream;
            version_stream << "Windows ";

            DWORD version = GetWindowsVersion();
            if (version >= 12) {
                version_stream << "12+";
            } else if (version >= 11) {
                version_stream << "11";
            } else if (version >= 10) {
                version_stream << "10";
            } else if (version >= 6) {
                if (version == 6 && IsWindows8OrGreater()) {
                    version_stream << "8";
                } else {
                    version_stream << "7";
                }
            } else {
                version_stream << "Older";
            }

            result->Success(flutter::EncodableValue(version_stream.str()));
        } else {
            result->NotImplemented();
        }
    }

}  // namespace platform_version

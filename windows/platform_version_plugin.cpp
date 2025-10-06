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
        } else if (method_call.method_name().compare("getDeviceInfo") == 0) {
            flutter::EncodableMap device_info = GetDeviceInfo();
            result->Success(flutter::EncodableValue(device_info));
        } else {
            result->NotImplemented();
        }
    }

    flutter::EncodableMap PlatformVersionPlugin::GetDeviceInfo() {
        flutter::EncodableMap device_info;
        
        // Get system info
        SYSTEM_INFO sys_info;
        GetSystemInfo(&sys_info);
        
        // Get OS version info
        OSVERSIONINFOW osvi = { sizeof(osvi) };
        NTSTATUS(WINAPI *RtlGetVersion)(LPOSVERSIONINFOW);
        *(FARPROC*)&RtlGetVersion = GetProcAddress(GetModuleHandleA("ntdll.dll"), "RtlGetVersion");
        if (RtlGetVersion != nullptr) {
            RtlGetVersion(&osvi);
        }
        
        // Get computer name
        DWORD computer_name_size = MAX_COMPUTERNAME_LENGTH + 1;
        wchar_t computer_name[MAX_COMPUTERNAME_LENGTH + 1];
        GetComputerNameW(computer_name, &computer_name_size);
        
        // Convert wide string to string
        std::wstring ws(computer_name);
        std::string computer_name_str;
        computer_name_str.reserve(ws.size());
        for (wchar_t wc : ws) {
            computer_name_str.push_back(static_cast<char>(wc));
        }
        
        // Get memory info
        MEMORYSTATUSEX mem_info;
        mem_info.dwLength = sizeof(MEMORYSTATUSEX);
        GlobalMemoryStatusEx(&mem_info);
        
        // Populate device info map
        device_info[flutter::EncodableValue("computerName")] = flutter::EncodableValue(computer_name_str);
        device_info[flutter::EncodableValue("majorVersion")] = flutter::EncodableValue(static_cast<int32_t>(osvi.dwMajorVersion));
        device_info[flutter::EncodableValue("minorVersion")] = flutter::EncodableValue(static_cast<int32_t>(osvi.dwMinorVersion));
        device_info[flutter::EncodableValue("buildNumber")] = flutter::EncodableValue(static_cast<int32_t>(osvi.dwBuildNumber));
        device_info[flutter::EncodableValue("platformId")] = flutter::EncodableValue(static_cast<int32_t>(osvi.dwPlatformId));
        device_info[flutter::EncodableValue("processorArchitecture")] = flutter::EncodableValue(static_cast<int32_t>(sys_info.wProcessorArchitecture));
        device_info[flutter::EncodableValue("numberOfProcessors")] = flutter::EncodableValue(static_cast<int32_t>(sys_info.dwNumberOfProcessors));
        device_info[flutter::EncodableValue("totalPhysicalMemory")] = flutter::EncodableValue(static_cast<int64_t>(mem_info.ullTotalPhys));
        device_info[flutter::EncodableValue("availablePhysicalMemory")] = flutter::EncodableValue(static_cast<int64_t>(mem_info.ullAvailPhys));
        device_info[flutter::EncodableValue("totalVirtualMemory")] = flutter::EncodableValue(static_cast<int64_t>(mem_info.ullTotalVirtual));
        device_info[flutter::EncodableValue("availableVirtualMemory")] = flutter::EncodableValue(static_cast<int64_t>(mem_info.ullAvailVirtual));
        
        // Add processor type string
        std::string processor_arch;
        switch (sys_info.wProcessorArchitecture) {
            case PROCESSOR_ARCHITECTURE_AMD64:
                processor_arch = "x64";
                break;
            case PROCESSOR_ARCHITECTURE_ARM:
                processor_arch = "ARM";
                break;
            case PROCESSOR_ARCHITECTURE_ARM64:
                processor_arch = "ARM64";
                break;
            case PROCESSOR_ARCHITECTURE_IA64:
                processor_arch = "IA64";
                break;
            case PROCESSOR_ARCHITECTURE_INTEL:
                processor_arch = "x86";
                break;
            default:
                processor_arch = "Unknown";
                break;
        }
        device_info[flutter::EncodableValue("processorArchitectureString")] = flutter::EncodableValue(processor_arch);
        
        return device_info;
    }

}  // namespace platform_version

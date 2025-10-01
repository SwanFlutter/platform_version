#include "include/platform_version/platform_version_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "platform_version_plugin.h"

void PlatformVersionPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  platform_version::PlatformVersionPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}

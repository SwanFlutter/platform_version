#include "include/platform_version/platform_version_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>
#include <sys/sysinfo.h>
#include <unistd.h>
#include <fstream>
#include <string>

#include <glib.h>
#include <glib/gstdio.h>

#include <cstring>

#include "platform_version_plugin_private.h"

#define PLATFORM_VERSION_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), platform_version_plugin_get_type(), \
                              PlatformVersionPlugin))

struct _PlatformVersionPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(PlatformVersionPlugin, platform_version_plugin, g_object_get_type())

static std::string get_or_create_stable_device_id() {
  const char* config_dir = g_get_user_config_dir();
  std::string base_dir = config_dir != nullptr ? std::string(config_dir) : std::string(".");
  std::string dir_path = base_dir + "/platform_version";
  std::string file_path = dir_path + "/stable_device_id";

  {
    std::ifstream in(file_path);
    std::string existing;
    if (in.good() && std::getline(in, existing)) {
      if (!existing.empty()) return existing;
    }
  }

  g_mkdir_with_parents(dir_path.c_str(), 0700);

  gchar* uuid_c = g_uuid_string_random();
  std::string new_id = uuid_c != nullptr ? std::string(uuid_c) : std::string();
  g_free(uuid_c);

  if (!new_id.empty()) {
    std::ofstream out(file_path, std::ios::trunc);
    if (out.good()) {
      out << new_id;
    }
  }

  return new_id;
}

// Called when a method call is received from Flutter.
static void platform_version_plugin_handle_method_call(
    PlatformVersionPlugin* self,
    FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response = nullptr;

  const gchar* method = fl_method_call_get_name(method_call);

  if (strcmp(method, "getPlatformVersion") == 0) {
    response = get_platform_version();
  } else if (strcmp(method, "getDeviceInfo") == 0) {
    response = get_device_info();
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

FlMethodResponse* get_platform_version() {
  struct utsname uname_data = {};
  uname(&uname_data);
  g_autofree gchar *version = g_strdup_printf("Linux %s", uname_data.version);
  g_autoptr(FlValue) result = fl_value_new_string(version);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

FlMethodResponse* get_device_info() {
  g_autoptr(FlValue) device_info = fl_value_new_map();
  
  // Get system information
  struct utsname uname_data = {};
  uname(&uname_data);
  
  struct sysinfo sys_info;
  sysinfo(&sys_info);
  
  // Get hostname
  char hostname[256];
  gethostname(hostname, sizeof(hostname));
  
  // Add basic system info
  fl_value_set_string_take(device_info, "stableDeviceId", fl_value_new_string(get_or_create_stable_device_id().c_str()));
  fl_value_set_string_take(device_info, "systemName", fl_value_new_string(uname_data.sysname));
  fl_value_set_string_take(device_info, "nodeName", fl_value_new_string(uname_data.nodename));
  fl_value_set_string_take(device_info, "release", fl_value_new_string(uname_data.release));
  fl_value_set_string_take(device_info, "version", fl_value_new_string(uname_data.version));
  fl_value_set_string_take(device_info, "machine", fl_value_new_string(uname_data.machine));
  fl_value_set_string_take(device_info, "hostname", fl_value_new_string(hostname));
  
  // Add memory information
  fl_value_set_string_take(device_info, "totalRam", fl_value_new_int(sys_info.totalram));
  fl_value_set_string_take(device_info, "freeRam", fl_value_new_int(sys_info.freeram));
  fl_value_set_string_take(device_info, "sharedRam", fl_value_new_int(sys_info.sharedram));
  fl_value_set_string_take(device_info, "bufferRam", fl_value_new_int(sys_info.bufferram));
  fl_value_set_string_take(device_info, "totalSwap", fl_value_new_int(sys_info.totalswap));
  fl_value_set_string_take(device_info, "freeSwap", fl_value_new_int(sys_info.freeswap));
  fl_value_set_string_take(device_info, "processes", fl_value_new_int(sys_info.procs));
  fl_value_set_string_take(device_info, "uptime", fl_value_new_int(sys_info.uptime));
  
  // Get number of processors
  long num_processors = sysconf(_SC_NPROCESSORS_ONLN);
  fl_value_set_string_take(device_info, "numberOfProcessors", fl_value_new_int(num_processors));
  
  // Try to get CPU model from /proc/cpuinfo
  std::ifstream cpuinfo("/proc/cpuinfo");
  std::string line;
  std::string cpu_model = "Unknown";
  
  while (std::getline(cpuinfo, line)) {
    if (line.find("model name") != std::string::npos) {
      size_t pos = line.find(":");
      if (pos != std::string::npos) {
        cpu_model = line.substr(pos + 2);
        break;
      }
    }
  }
  fl_value_set_string_take(device_info, "cpuModel", fl_value_new_string(cpu_model.c_str()));
  
  // Try to get distribution info from /etc/os-release
  std::ifstream os_release("/etc/os-release");
  std::string distro_name = "Unknown";
  std::string distro_version = "Unknown";
  
  while (std::getline(os_release, line)) {
    if (line.find("NAME=") == 0) {
      distro_name = line.substr(5);
      // Remove quotes if present
      if (distro_name.front() == '"' && distro_name.back() == '"') {
        distro_name = distro_name.substr(1, distro_name.length() - 2);
      }
    } else if (line.find("VERSION=") == 0) {
      distro_version = line.substr(8);
      // Remove quotes if present
      if (distro_version.front() == '"' && distro_version.back() == '"') {
        distro_version = distro_version.substr(1, distro_version.length() - 2);
      }
    }
  }
  
  fl_value_set_string_take(device_info, "distributionName", fl_value_new_string(distro_name.c_str()));
  fl_value_set_string_take(device_info, "distributionVersion", fl_value_new_string(distro_version.c_str()));
  
  return FL_METHOD_RESPONSE(fl_method_success_response_new(device_info));
}

static void platform_version_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(platform_version_plugin_parent_class)->dispose(object);
}

static void platform_version_plugin_class_init(PlatformVersionPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = platform_version_plugin_dispose;
}

static void platform_version_plugin_init(PlatformVersionPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  PlatformVersionPlugin* plugin = PLATFORM_VERSION_PLUGIN(user_data);
  platform_version_plugin_handle_method_call(plugin, method_call);
}

void platform_version_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  PlatformVersionPlugin* plugin = PLATFORM_VERSION_PLUGIN(
      g_object_new(platform_version_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "platform_version",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}

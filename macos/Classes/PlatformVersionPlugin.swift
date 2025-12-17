import Cocoa
import FlutterMacOS
import Security

public class PlatformVersionPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "platform_version", binaryMessenger: registrar.messenger)
    let instance = PlatformVersionPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
    case "getDeviceInfo":
      result(getDeviceInfo())
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  private func getDeviceInfo() -> [String: Any] {
    let processInfo = ProcessInfo.processInfo
    
    var deviceInfo: [String: Any] = [
      "stableDeviceId": getOrCreateStableDeviceId(),
      "operatingSystemVersionString": processInfo.operatingSystemVersionString,
      "processorCount": processInfo.processorCount,
      "activeProcessorCount": processInfo.activeProcessorCount,
      "physicalMemory": processInfo.physicalMemory,
      "hostName": processInfo.hostName,
      "operatingSystem": processInfo.operatingSystem.rawValue,
      "processName": processInfo.processName,
      "globallyUniqueString": processInfo.globallyUniqueString
    ]
    
    // Add system version components
    let osVersion = processInfo.operatingSystemVersion
    deviceInfo["majorVersion"] = osVersion.majorVersion
    deviceInfo["minorVersion"] = osVersion.minorVersion
    deviceInfo["patchVersion"] = osVersion.patchVersion
    
    // Add hardware model information
    var systemInfo = utsname()
    uname(&systemInfo)
    let modelCode = withUnsafePointer(to: &systemInfo.machine) {
      $0.withMemoryRebound(to: CChar.self, capacity: 1) {
        ptr in String.init(validatingUTF8: ptr)
      }
    }
    deviceInfo["modelIdentifier"] = modelCode ?? "Unknown"
    
    // Add system name
    let systemName = withUnsafePointer(to: &systemInfo.sysname) {
      $0.withMemoryRebound(to: CChar.self, capacity: 1) {
        ptr in String.init(validatingUTF8: ptr)
      }
    }
    deviceInfo["systemName"] = systemName ?? "Unknown"
    
    // Add kernel version
    let kernelVersion = withUnsafePointer(to: &systemInfo.version) {
      $0.withMemoryRebound(to: CChar.self, capacity: 1) {
        ptr in String.init(validatingUTF8: ptr)
      }
    }
    deviceInfo["kernelVersion"] = kernelVersion ?? "Unknown"
    
    return deviceInfo
  }

  private func getOrCreateStableDeviceId() -> String {
    let service = "platform_version"
    let account = "stable_device_id"

    if let existing = keychainGetString(service: service, account: account), !existing.isEmpty {
      return existing
    }

    let newId = UUID().uuidString
    _ = keychainSetString(newId, service: service, account: account)
    return newId
  }

  private func keychainGetString(service: String, account: String) -> String? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne
    ]

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status == errSecSuccess, let data = item as? Data else {
      return nil
    }
    return String(data: data, encoding: .utf8)
  }

  private func keychainSetString(_ value: String, service: String, account: String) -> Bool {
    let data = value.data(using: .utf8) ?? Data()
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account
    ]

    let attributes: [String: Any] = [
      kSecValueData as String: data
    ]

    let status = SecItemCopyMatching(query as CFDictionary, nil)
    if status == errSecSuccess {
      return SecItemUpdate(query as CFDictionary, attributes as CFDictionary) == errSecSuccess
    } else if status == errSecItemNotFound {
      var newItem = query
      newItem[kSecValueData as String] = data
      return SecItemAdd(newItem as CFDictionary, nil) == errSecSuccess
    }

    return false
  }
}

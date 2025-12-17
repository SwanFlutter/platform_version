import Flutter
import Security
import UIKit

public class PlatformVersionPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "platform_version", binaryMessenger: registrar.messenger())
    let instance = PlatformVersionPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "getDeviceInfo":
      result(getDeviceInfo())
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  private func getDeviceInfo() -> [String: Any] {
    let device = UIDevice.current
    let processInfo = ProcessInfo.processInfo
    
    var deviceInfo: [String: Any] = [
      "stableDeviceId": getOrCreateStableDeviceId(),
      "name": device.name,
      "model": device.model,
      "localizedModel": device.localizedModel,
      "systemName": device.systemName,
      "systemVersion": device.systemVersion,
      "identifierForVendor": device.identifierForVendor?.uuidString ?? "Unknown"
    ]
    
    // Add device model identifier
    var systemInfo = utsname()
    uname(&systemInfo)
    let modelCode = withUnsafePointer(to: &systemInfo.machine) {
      $0.withMemoryRebound(to: CChar.self, capacity: 1) {
        ptr in String.init(validatingUTF8: ptr)
      }
    }
    deviceInfo["modelIdentifier"] = modelCode ?? "Unknown"
    
    // Add process info
    deviceInfo["processorCount"] = processInfo.processorCount
    deviceInfo["activeProcessorCount"] = processInfo.activeProcessorCount
    deviceInfo["physicalMemory"] = processInfo.physicalMemory
    deviceInfo["operatingSystemVersionString"] = processInfo.operatingSystemVersionString
    
    // Add battery info if available
    if device.isBatteryMonitoringEnabled || device.batteryState != .unknown {
      deviceInfo["batteryLevel"] = device.batteryLevel
      deviceInfo["batteryState"] = batteryStateString(device.batteryState)
    }
    
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
  
  private func batteryStateString(_ state: UIDevice.BatteryState) -> String {
    switch state {
    case .unknown:
      return "unknown"
    case .unplugged:
      return "unplugged"
    case .charging:
      return "charging"
    case .full:
      return "full"
    @unknown default:
      return "unknown"
    }
  }
}

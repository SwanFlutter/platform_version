import Flutter
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

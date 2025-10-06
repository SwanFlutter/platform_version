import Cocoa
import FlutterMacOS

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
}

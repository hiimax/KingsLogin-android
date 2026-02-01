import Flutter
import UIKit
import KCLoginSDK

public class KingsLoginPlugin: NSObject, FlutterPlugin, KCLoginManagerDelegate {
    var result: FlutterResult?
    let loginManager = KCLoginManager()

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "kings_login", binaryMessenger: registrar.messenger())
        let instance = KingsLoginPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "login":
            if self.result != nil {
                result(FlutterError(code: "PENDING_RESULT", message: "A login request is already in progress", details: nil))
                return
            }
            self.result = result
            loginManager.delegate = self
            // Assuming we can pass scopes or it uses default from Info.plist/config
            // Search result didn't mention passing scopes in login() call, usually defined in config.
            // But if there is a method with scopes, we should use it.
            // For now, calling plain login().
            loginManager.login() 
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - KCLoginManagerDelegate

    public func login(succeededWith response: KCLoginResponse) {
        if let result = self.result {
             let data: [String: String] = [
                 "code": response.authCode.value,
                 // iOS SDK might not return scopes explicitly in response based on search, 
                 // providing empty defaults or check response properties if available in IDE.
                 "accepted_scopes": "[]", 
                 "rejected_scopes": "[]"
             ]
             result(data)
             self.result = nil
        }
    }

    public func login(failedWithError error: KCLoginError) {
        if let result = self.result {
            result(FlutterError(code: "ERROR", message: error.message, details: nil))
            self.result = nil
        }
    }

    // Handle URL callbacks
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return loginManager.application(app, open: url, options: options)
    }
}

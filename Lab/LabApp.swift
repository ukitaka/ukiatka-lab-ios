import ComposableArchitecture
import FirebaseCore
import OneSignalFramework
import Supabase
import SwiftUI

@main
struct LabApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            RootView(store: Store(initialState: .loading, reducer: {
                RootFeature()
            }))
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        OneSignal.Debug.setLogLevel(.LL_VERBOSE)
        OneSignal.initialize("7e7931a9-623d-446c-ae6d-557cc890e24e", withLaunchOptions: launchOptions)
        OneSignal.Notifications.requestPermission({ accepted in
            print("User accepted notifications: \(accepted)")
        }, fallbackToSettings: true)
        // Login your customer with externalId

        FirebaseApp.configure()

        return true
    }
}

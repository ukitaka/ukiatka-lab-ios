import SwiftUI

@main
struct LabApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL(perform: { url in
                    print(url)
                })
        }
    }
}

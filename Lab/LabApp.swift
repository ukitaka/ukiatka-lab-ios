import ComposableArchitecture
import Supabase
import SwiftUI

@main
struct LabApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(store: Store(initialState: .loading, reducer: {
                RootFeature()
            }))
        }
    }
}

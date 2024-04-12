import ComposableArchitecture
import Supabase
import SwiftUI

let client = SupabaseClient(
    supabaseURL: URL(string: "https://xwyamkobysyldtpyljfm.supabase.co")!,
    supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh3eWFta29ieXN5bGR0cHlsamZtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTA5OTY1OTUsImV4cCI6MjAyNjU3MjU5NX0.5KeUbSWo9bQ0V5RHMx8ocUxBfA9swjMflEWRg7XiUXo"
)

@main
struct LabApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(store: Store(initialState: .initial, reducer: {
                RootFeature()
            }))
        }
    }
}

import Dependencies
import Foundation
import OneSignalFramework
import Supabase

actor LoginSessionClient: Sendable {
    private let supabseClient = SupabaseClient(
        supabaseURL: URL(string: "https://xwyamkobysyldtpyljfm.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh3eWFta29ieXN5bGR0cHlsamZtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTA5OTY1OTUsImV4cCI6MjAyNjU3MjU5NX0.5KeUbSWo9bQ0V5RHMx8ocUxBfA9swjMflEWRg7XiUXo"
    )

    func isLoggedIn() async -> Bool {
        await (try? supabseClient.auth.user()) != nil
    }

    func login(email: String, password: String) async throws {
        let session = try await supabseClient.auth.signIn(email: email, password: password)
        OneSignal.login(session.user.id.uuidString)
    }

    func logout() async throws {
        try await supabseClient.auth.signOut(scope: .local)
    }

    func accessToken() async throws -> String {
        let session = try await supabseClient.auth.session
        return session.accessToken
    }
}

enum LoginSesssionClientKey: DependencyKey {
    static let liveValue: LoginSessionClient = .init()
}

extension DependencyValues {
    var loginSessionClient: LoginSessionClient {
        get { self[LoginSesssionClientKey.self] }
        set { self[LoginSesssionClientKey.self] = newValue }
    }
}

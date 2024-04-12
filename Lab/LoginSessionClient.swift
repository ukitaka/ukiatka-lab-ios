import Dependencies
import Foundation
import Supabase

protocol LoginSessionClientProtocol: Sendable {
    func isLoggedIn() async throws -> Bool
    func login(email: String, password: String) async throws
}

actor LoginSessionClient: LoginSessionClientProtocol {
    private let supabseClient = SupabaseClient(
        supabaseURL: URL(string: "https://xwyamkobysyldtpyljfm.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh3eWFta29ieXN5bGR0cHlsamZtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTA5OTY1OTUsImV4cCI6MjAyNjU3MjU5NX0.5KeUbSWo9bQ0V5RHMx8ocUxBfA9swjMflEWRg7XiUXo"
    )
    func isLoggedIn() async -> Bool {
        await (try? supabseClient.auth.user()) != nil
    }

    func login(email: String, password: String) async throws {
        try await supabseClient.auth.signIn(email: email, password: password)
    }
}

private enum LoginSesssionClientKey: DependencyKey {
    static let liveValue: any LoginSessionClientProtocol = LoginSessionClient()
}

extension DependencyValues {
    var loginSessionClient: any LoginSessionClientProtocol {
        get { self[LoginSesssionClientKey.self] }
        set { self[LoginSesssionClientKey.self] = newValue }
    }
}

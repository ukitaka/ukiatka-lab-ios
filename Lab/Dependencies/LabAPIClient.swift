import Dependencies
import Foundation

actor LabAPIClient: Sendable {
    let baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL
    }

    @Dependency(\.loginSessionClient) private var loginSessionClient

    func fetchBookmarks() async throws -> [Bookmark] {
        let (data, _) = try await URLSession.shared.data(for: urlRequestWithAuthHeader(path: "/api/bookmarks"))
        return try JSONDecoder().decode([Bookmark].self, from: data)
    }

    private func urlRequestWithAuthHeader(path: String) async throws -> URLRequest {
        let accessToken = try await loginSessionClient.accessToken()
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.path = path
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.setValue(accessToken, forHTTPHeaderField: "X-LAB-ACCESS-TOKEN")
        return request
    }
}

enum LabAPIClientKey: DependencyKey {
    static let liveValue: LabAPIClient = .init(baseURL: "https://ukitaka-lab.app")
}

extension DependencyValues {
    var labAPIClient: LabAPIClient {
        get { self[LabAPIClientKey.self] }
        set { self[LabAPIClientKey.self] = newValue }
    }
}

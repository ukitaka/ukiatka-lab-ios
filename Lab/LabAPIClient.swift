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
        print(String(data: data, encoding: .utf8)!)
        return try JSONDecoder().decode([Bookmark].self, from: data)
    }

    private func urlRequestWithAuthHeader(path: String) async throws -> URLRequest {
        let (accessToken, refreshToken) = try await loginSessionClient.tokens()
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.path = path
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.setValue(accessToken, forHTTPHeaderField: "X-LAB-ACCESS-TOKEN")
        request.setValue(refreshToken, forHTTPHeaderField: "X-LAB-REFRESH-TOKEN")
        return request
    }
}

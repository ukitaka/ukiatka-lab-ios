import Dependencies
import Foundation

actor LabAPIClient: Sendable {
    let baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL
    }

    struct APIError: Error, Decodable {
        let error: String
    }

    @Dependency(\.loginSessionClient) private var loginSessionClient

    func fetchBookmarks() async throws -> [Bookmark] {
        let (data, _) = try await URLSession.shared.data(for: urlRequestWithAuthHeader(path: "/bookmarks"))
        return try JSONDecoder().decode([Bookmark].self, from: data)
    }

    func addBookmark(urlString: String) async throws -> Bookmark {
        guard let url = URL(string: urlString, encodingInvalidCharacters: false) else {
            throw APIError(error: "url format is invalid.")
        }

        struct JSONBody: Encodable {
            let url: String
        }
        var req = try await urlRequestWithAuthHeader(path: "/bookmarks")
        req.httpMethod = "POST"
        let jsonData = try JSONEncoder().encode(JSONBody(url: urlString))

        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = jsonData

        let (data, res) = try await URLSession.shared.data(for: req)

        if let res = res as? HTTPURLResponse, res.statusCode != 201 {
            print(res.statusCode)
            print(String(data: data, encoding: .utf8) ?? "")
            print(url)
            if let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                throw apiError
            } else {
                throw APIError(error: "unexpected error. HTTP　status: \(res.statusCode), url: \(urlString)")
            }
        }

        return try JSONDecoder().decode(Bookmark.self, from: data)
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
    static let liveValue: LabAPIClient = .init(baseURL: "https://api.ukitaka-lab.app")
}

extension DependencyValues {
    var labAPIClient: LabAPIClient {
        get { self[LabAPIClientKey.self] }
        set { self[LabAPIClientKey.self] = newValue }
    }
}

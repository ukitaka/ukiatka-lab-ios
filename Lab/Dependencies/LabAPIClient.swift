import Dependencies
import Foundation

actor LabAPIClient: Sendable {
    let baseURL: String
    let jsonDecoder: JSONDecoder

    init(baseURL: String) {
        self.baseURL = baseURL
        jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(.iso8601Full)
    }

    struct APIError: Error, Decodable {
        let error: String
    }

    @Dependency(\.loginSessionClient) private var loginSessionClient

    func fetchBookmarks() async throws -> [Bookmark] {
        let (data, _) = try await URLSession.shared.data(for: urlRequestWithAuthHeader(path: "/bookmarks"))
        return try jsonDecoder.decode([Bookmark].self, from: data)
    }

    func fetchBookmark(id: Int) async throws -> Bookmark {
        let (data, _) = try await URLSession.shared.data(for: urlRequestWithAuthHeader(path: "/bookmarks/\(id)"))
        return try jsonDecoder.decode(Bookmark.self, from: data)
    }

    func deleteBookmark(id: Int) async throws {
        var req = try await urlRequestWithAuthHeader(path: "/bookmarks/\(id)")
        req.httpMethod = "DELETE"
        let (data, _) = try await URLSession.shared.data(for: req)
        // TODO: error handling
        print(String(data: data, encoding: .utf8) ?? "no data")
    }

    func enqueueLLMSummary(id: Int) async throws {
        var req = try await urlRequestWithAuthHeader(path: "/bookmarks/\(id)/enqueue_llm_summary")
        req.httpMethod = "POST"
        let (data, _) = try await URLSession.shared.data(for: req)
        // TODO: error handling
        print(String(data: data, encoding: .utf8) ?? "no data")
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

        return try jsonDecoder.decode(Bookmark.self, from: data)
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

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
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

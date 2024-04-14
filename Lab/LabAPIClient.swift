import Foundation

actor LabAPIClient: Sendable {
    let baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL
    }

    func fetchBookmarks() async throws -> [Bookmark] {
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.path = "/bookmarks"
        let (data, _) = try await URLSession.shared.data(from: urlComponents.url!)
        return try JSONDecoder().decode([Bookmark].self, from: data)
    }
}

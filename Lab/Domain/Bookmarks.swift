import Foundation

struct Bookmark: Equatable, Decodable, Hashable, Identifiable {
    let id: Int
    let url: String
    let title: String
    let imageUrl: String
    let siteName: String?
    let description: String?
    let createdAt: Date
    var notes: [Note]?

    var domain: String {
        URL(string: url)!.host()!
    }
}

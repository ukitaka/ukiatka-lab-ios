import Foundation

struct Bookmark: Equatable, Decodable, Hashable, Identifiable {
    let id: Int
    let url: String
    let title: String
    let imageUrl: String
    let siteName: String?
    let description: String?
}

extension Bookmark {
    var domain: String {
        URL(string: url)!.host()!
    }
}

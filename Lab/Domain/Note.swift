import Foundation

struct Note: Decodable, Equatable, Hashable, Identifiable {
    let id: Int
    let content: String
    let createdAt: Date
}

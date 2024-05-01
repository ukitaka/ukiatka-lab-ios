import Foundation

struct Note: Decodable, Equatable, Hashable, Identifiable {
    let id: Int
    let editor: Editor
    let content: String
    let status: Status
    let createdAt: Date

    enum Editor: String, Equatable, Decodable, Hashable {
        case ukitaka
        case ai
    }

    enum Status: String, Equatable, Decodable, Hashable {
        case queued
        case completed
    }
}

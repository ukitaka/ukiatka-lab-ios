import Foundation

struct Bookmark: Equatable, Decodable, Hashable, Identifiable {
    let id: Int
    let url: String
    let title: String
    let imageUrl: String
    let siteName: String?
    let description: String?
    let createdAt: Date
    let llmSummary: LLMSummary?
    var notes: [Note]?

    var domain: String {
        URL(string: url)!.host()!
    }
}

struct LLMSummary: Equatable, Decodable, Hashable {
    let summary: String
    let status: Status

    enum Status: String, Equatable, Decodable, Hashable {
        case queued
        case completed
    }
}

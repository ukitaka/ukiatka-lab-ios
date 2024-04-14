struct Bookmark: Equatable, Decodable, Hashable, Identifiable {
    let id: Int
    let url: String
    let title: String
    let imageUrl: String?
}

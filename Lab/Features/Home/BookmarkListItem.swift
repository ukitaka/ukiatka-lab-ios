import SwiftUI

struct BookmarkListItem: View {
    private let bookmark: Bookmark

    init(bookmark: Bookmark) {
        self.bookmark = bookmark
    }

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: bookmark.imageUrl)) { image in
                image.resizable()
                    .frame(maxWidth: .infinity)
                    .scaledToFit()
                    .cornerRadius(16.0)
                    .clipped()
                    .shadow(radius: 1.0)
            } placeholder: {
                Skeleton()
                    .frame(minHeight: 200)
            }
        }
        .padding([.leading, .trailing], 16.0)
    }
}

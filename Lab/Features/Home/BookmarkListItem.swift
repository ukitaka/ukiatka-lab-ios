import SwiftUI

struct BookmarkListItem: View {
    private let bookmark: Bookmark

    init(bookmark: Bookmark) {
        self.bookmark = bookmark
    }

    var body: some View {
        HStack {
            BookmarkImage(bookmark: bookmark)
        }
        .padding([.leading, .trailing], 16.0)
    }
}

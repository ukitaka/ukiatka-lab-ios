import SwiftUI

struct BookmarkImage: View {
    let bookmark: Bookmark

    var body: some View {
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
}

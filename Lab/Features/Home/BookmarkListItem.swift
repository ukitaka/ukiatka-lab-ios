import SwiftUI

struct BookmarkListItem: View {
    private let bookmark: Bookmark

    init(bookmark: Bookmark) {
        self.bookmark = bookmark
    }

    var body: some View {
        if let imageUrl = bookmark.imageUrl {
            WithImage(imageUrl: imageUrl)
        } else {
            NoImage()
        }
    }

    struct NoImage: View {
        var body: some View {
            VStack {
                Text("no image")
            }.frame(minHeight: 200)
        }
    }

    struct WithImage: View {
        private let imageUrl: String

        init(imageUrl: String) {
            self.imageUrl = imageUrl
        }

        var body: some View {
            HStack {
                AsyncImage(url: URL(string: imageUrl)) { image in
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
}

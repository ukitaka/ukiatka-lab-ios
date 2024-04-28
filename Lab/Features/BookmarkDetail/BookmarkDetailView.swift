import ComposableArchitecture
import SwiftUI

struct BookmarkDetailView: View {
    @Bindable var store: StoreOf<BookmarkDetailFeature>

    @ViewBuilder
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    AsyncImage(url: store.bookmark.favicon) { image in
                        image.resizable()
                            .frame(width: 16.0, height: 16.0)
                            .scaledToFit()
                    } placeholder: {
                        Skeleton()
                            .frame(width: 16.0, height: 16.0)
                    }
                    Text(store.bookmark.siteNameForDisplay)
                        .font(.caption)
                        .foregroundStyle(.labText)
                    Spacer()
                }.padding(.bottom, 4.0)
                Text(store.bookmark.title)
                    .font(.headline)
                Spacer()
            }
            .padding()
            .navigationTitle(store.bookmark.siteNameForDisplay)
        }
    }
}

private extension Bookmark {
    var siteNameForDisplay: String {
        siteName ?? domain
    }

    var favicon: URL {
        URL(string: "https://www.google.com/s2/favicons?domain=\(domain)")!
    }
}

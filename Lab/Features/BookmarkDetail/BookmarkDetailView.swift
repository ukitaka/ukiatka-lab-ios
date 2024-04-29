import ComposableArchitecture
import SwiftUI

struct BookmarkDetailView: View {
    @Bindable var store: StoreOf<BookmarkDetailFeature>

    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()

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
                    Text(dateFormatter.string(from: store.bookmark.createdAt))
                        .font(.caption)
                        .foregroundStyle(.labText)
                    if store.isFetching {
                        LogoLoadingView(width: 16.0, height: 16.0)
                    }
                }.padding(.bottom, 4.0)
                BookmarkImage(bookmark: store.bookmark)
                    .padding(.bottom, 8.0)
                Text(store.bookmark.title)
                    .font(.headline)
                if let llmSummary = store.bookmark.llmSummary {
                    VStack {
                        Text("AI要約")
                        Text(llmSummary.summary)
                    }
                }
                Spacer()
            }
            .padding()
            .navigationTitle(store.bookmark.siteNameForDisplay)
        }
        .onAppear {
            store.send(.refetchBookmarkDetail)
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

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
                BookmarkImage(bookmark: store.bookmark)
                Divider()
                    .padding([.top, .bottom], 8.0)
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
                Text(store.bookmark.title)
                    .font(.headline)
                    .padding(.bottom, 16.0)
                Divider().padding([.top, .bottom], 8.0)
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Image(systemName: "pencil.and.scribble")
                            .foregroundColor(.labText)
                        Text("AI要約")
                            .foregroundColor(.labText)
                            .fontWeight(.semibold)
                    }
                    .padding(.bottom, 8.0)
                    if let llmSummary = store.bookmark.llmSummary {
                        switch llmSummary.status {
                        case .completed:
                            Text(llmSummary.summary).lineSpacing(8.0)

                        case .queued:
                            Text("要約を生成中です...").lineSpacing(8.0)
                        }
                    } else {
                        HStack {
                            Button("要約をリクエスト", systemImage: "pencil.and.scribble") {
                                store.send(.requestLLMSummary)
                            }
                            .disabled(store.isFetching)
                            .frame(width: 180.0, height: 48.0)
                            .background(store.isFetching ? .gray : Color.labPrimary)
                            .foregroundColor(Color.white)
                            .cornerRadius(16.0)
                            .fontWeight(.semibold)
                        }
                    }
                }
                .padding(4.0)
                Divider().padding([.top, .bottom], 8.0)
                Spacer()
            }
            .padding()
            .navigationTitle(store.bookmark.siteNameForDisplay)
            .navigationBarItems(trailing: Button("", systemImage: "safari", action: {
                store.send(.openURL(URL(string: store.bookmark.url)!))
            }))
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

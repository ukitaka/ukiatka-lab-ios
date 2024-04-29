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
            VStack(alignment: .leading, spacing: 16.0) {
                BookmarkImage(bookmark: store.bookmark)
                    .onTapGesture { store.send(.openURL(URL(string: store.bookmark.url)!)) }
                Divider()
                siteNameAndTitle().padding(.bottom, 8.0)
                Divider()
                llmSummarySection().padding(4.0)
                Divider()
                Spacer()
            }
            .padding()
            .navigationTitle(store.bookmark.siteNameForDisplay)
            .navigationBarItems(trailing: Button("", systemImage: "gearshape.fill", action: {
                store.send(.gearButtonTapped)
            }))
        }
        .onAppear {
            store.send(.refetchBookmarkDetail)
        }
        .confirmationDialog(item: $store.scope(state: \.destination?.bookmarkAction, action: \.destination.bookmarkAction)) { _ in
            Text("Title")
        } actions: { _ in
            Button("Action1") {}
            Button("Action2") {}
        } message: { _ in
            Text("message")
        }
    }

    @ViewBuilder
    func siteNameAndTitle() -> some View {
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
        }
        Text(store.bookmark.title)
            .font(.headline)
    }

    @ViewBuilder
    func llmSummarySection() -> some View {
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

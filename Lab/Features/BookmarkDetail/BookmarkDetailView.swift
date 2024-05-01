import ComposableArchitecture
import MarkdownUI
import SwiftUI

struct BookmarkDetailView: View {
    @Bindable var store: StoreOf<BookmarkDetailFeature>

    @State private var opacity: CGFloat = 0.0

    @Dependency(\.dateFormatter) var dateFormatter

    @ViewBuilder
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16.0) {
                ZStack {
                    BookmarkImage(bookmark: store.bookmark)
                        .onTapGesture { store.send(.openURL(URL(string: store.bookmark.url)!)) }
                    if store.isFetching {
                        LogoLoadingView(width: 16.0, height: 16.0)
                    }
                }
                Divider()
                siteNameAndTitle().padding(.bottom, 8.0)
                Divider()
                llmSummarySection().padding(4.0)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.8)) {
                            opacity = 1.0
                        }
                    }
                Divider()
                HStack(alignment: .center) {
                    Image(systemName: "pencil.and.scribble")
                        .foregroundColor(.labText)
                    Text("ノート")
                        .foregroundColor(.labText)
                        .fontWeight(.semibold)
                    Spacer()
                }
                ForEach(store.bookmark.notes ?? []) { note in
                    Text(note.content)
                }
                Button("ノートを追加", systemImage: "pencil.and.scribble") {
                    store.send(.addNoteButtonTapped)
                }
                .disabled(store.isFetching)
                .frame(width: 180.0, height: 48.0)
                .background(store.isFetching ? .gray : Color.labPrimary)
                .foregroundColor(Color.white)
                .cornerRadius(16.0)
                .fontWeight(.semibold)
                Divider().padding(.bottom, 200.0)
                Spacer()
            }
            .padding()
            .navigationTitle(store.bookmark.siteNameForDisplay)
            .navigationBarItems(trailing: Button("", systemImage: "gearshape.fill", action: {
                store.send(.gearButtonTapped)
            }))
        }
        .onAppear {
            store.send(.fetchBookmarkDetail(.startFetching))
        }
        .bookmarkActionDialog(self)
        .bookmarkDeleteConfirm(self)
        .sheet(item: $store.scope(state: \.destination?.addNote, action: \.destination.addNote)) { store in
            AddNoteView(store: store)
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
                Spacer()
            }
            .padding(.bottom, 8.0)
            if let llmSummary = store.bookmark.llmSummary {
                switch llmSummary.status {
                case .completed:
                    Markdown {
                        llmSummary.summary
                    }.markdownTheme(.labTheme)

                case .queued:
                    HStack {
                        Text("要約を生成中です...")
                    }
                }
            } else {
                HStack {
                    llmSummaryButton()
                    Spacer()
                }
            }
        }
    }

    @ViewBuilder
    func llmSummaryButton() -> some View {
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

// MARK: - alert and dialog

private extension View {
    func bookmarkActionDialog(_ bookmarkDetailView: BookmarkDetailView) -> some View {
        confirmationDialog(item: bookmarkDetailView.$store.scope(state: \.destination?.bookmarkAction, action: \.destination.bookmarkAction)) { _ in
            Text("ブックマークを管理")
        } actions: { _ in
            Button(role: .destructive) {
                bookmarkDetailView.store.send(.deleteBookmark(.confirmation))
            } label: {
                Text("ブックマークを削除")
            }
            Button("AI要約を再生成") {
                bookmarkDetailView.store.send(.requestLLMSummary)
            }
        } message: { _ in
            Text("ブックマークを管理")
        }
    }

    func bookmarkDeleteConfirm(_ bookmarkDetailView: BookmarkDetailView) -> some View {
        alert(item: bookmarkDetailView.$store.scope(state: \.destination?.deleteConfirm, action: \.destination.deleteConfirm)) { _ in
            Text("ブックマークを削除")
        } actions: { _ in
            Button(role: .destructive) {
                bookmarkDetailView.store.send(.deleteBookmark(.executeAction))
            } label: {
                Text("削除する")
            }
        } message: { _ in
            Text("このブックマークを削除しますか？")
        }
    }
}

// MARK: -

private extension Bookmark {
    var siteNameForDisplay: String {
        siteName ?? domain
    }

    var favicon: URL {
        URL(string: "https://www.google.com/s2/favicons?domain=\(domain)")!
    }
}

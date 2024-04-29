import ComposableArchitecture
import Shimmer
import SwiftUI

struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>

    @ViewBuilder
    var body: some View {
        if store.isFetching {
            LogoLoadingView(width: 32.0, height: 32.0)
                .onAppear {
                    store.send(.startFetching)
                }
        } else {
            mainView()
        }
    }

    func mainView() -> some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    ForEach(store.bookmarks) { bookmark in
                        NavigationLink(state: HomeFeature.Path.State.bookmarkDetail(.init(bookmark: bookmark))) {
                            BookmarkListItem(bookmark: bookmark)
                        }
                    }
                }
                // TODO: ここをなんとかしたい
                // isFetchingをObserveしてtrue -> falseになるまでawaitできるように
                // 実装できると標準に乗っかれそう
                .refreshable {
                    // Work around
                    @Dependency(\.labAPIClient) var labAPIClient
                    do {
                        let bookmarks = try await labAPIClient.fetchBookmarks()
                        DispatchQueue.main.async {
                            store.send(.completeFetching(bookmarks))
                        }
                    } catch {
                        print(error)
                    }
                }
                Button {
                    store.send(.addButtonTapped)
                } label: {
                    Text("+")
                        .font(.title)
                        .fontWeight(.heavy)
                        .frame(width: 60.0, height: 60.0)
                        .padding()
                        .background(Color.primary)
                        .foregroundColor(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 12.0)
                }
                .padding()
            }
            .navigationTitle("Bookmarks")
        } destination: { store in
            switch store.case {
            case let .bookmarkDetail(store):
                BookmarkDetailView(store: store)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .tint(.labTint)
        .fullScreenCover(item: $store.scope(state: \.destination?.addBookmark, action: \.destination.addBookmark)) { store in
            AddBookmarkView(store: store)
        }
    }
}

import ComposableArchitecture
import Shimmer
import SwiftUI

struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>

    @ViewBuilder
    var body: some View {
        switch store.state {
        case let .bookmarks(bookmarks):
            NavigationStack {
                ScrollView {
                    ForEach(bookmarks) { bookmark in
                        BookmarkListItem(bookmark: bookmark)
                    }
                    .navigationDestination(for: Bookmark.self) { bookmark in
                        Text(bookmark.title)
                    }
                }.navigationTitle("Bookmarks")
            }

        case .fetching:
            LogoLoadingView(width: 32.0, height: 32.0)
                .onAppear {
                    store.send(.startFetching)
                }
        }
    }
}

#Preview {
    HomeView(
        store: Store(initialState: .fetching) {}
    )
}

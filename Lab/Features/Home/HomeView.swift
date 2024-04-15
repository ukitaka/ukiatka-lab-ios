import ComposableArchitecture
import Shimmer
import SwiftUI

struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>

    @ViewBuilder
    var body: some View {
        switch store.state {
        case let .bookmarks(bookmarks):
            ZStack(alignment: .bottomTrailing) {
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
                Button {} label: {
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

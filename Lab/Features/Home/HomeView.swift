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
            ZStack(alignment: .bottomTrailing) {
                NavigationStack {
                    ScrollView {
                        ForEach(store.bookmarks) { bookmark in
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
        }
    }
}

#Preview {
    HomeView(
        store: Store(initialState: .init()) {}
    )
}

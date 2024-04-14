import ComposableArchitecture
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
                        if let imageUrl = bookmark.imageUrl {
                            AsyncImage(url: URL(string: imageUrl)) { image in
                                image.resizable()
                                    .frame(maxWidth: .infinity)
                                    .scaledToFit()
                            } placeholder: {
                                LogoLoadingView(width: 32.0, height: 32.0)
                            }
                            Spacer()
                        } else {
                            //                        Text(bookmark.title)
                            Spacer()
                        }
                    }
                    .navigationDestination(for: Bookmark.self) { bookmark in
                        Text(bookmark.title)
                    }
                }.navigationTitle("ブックマーク")
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

import ComposableArchitecture
import SwiftUI

struct BookmarkDetailView: View {
    @Bindable var store: StoreOf<BookmarkDetailFeature>

    @ViewBuilder
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text(store.bookmark.title)
                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
    }
}

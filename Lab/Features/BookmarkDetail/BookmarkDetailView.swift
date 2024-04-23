import ComposableArchitecture
import SwiftUI

struct BookmarkDetailView: View {
    @Bindable var store: StoreOf<BookmarkDetailFeature>

    @ViewBuilder
    var body: some View {
        Text("hello")
    }
}

#Preview {
    BookmarkDetailView(
        store: Store(initialState: BookmarkDetailFeature.State()) {}
    )
}

import ComposableArchitecture
import SwiftUI

struct AddBookmarkView: View {
    @Bindable var store: StoreOf<AddBookmarkFeature>

    @ViewBuilder
    var body: some View {
        TextField("URL", text: $store.urlString)
    }
}

#Preview {
    AddBookmarkView(
        store: Store(initialState: AddBookmarkFeature.State()) {}
    )
}

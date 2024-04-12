import ComposableArchitecture
import SwiftUI

struct RootView {
    @Bindable var store: StoreOf<RootFeature>

    @ViewBuilder
    var body: some View {}
}

#Preview {
    RootView(
        store: Store(initialState: RootFeature.State()) {}
    )
}

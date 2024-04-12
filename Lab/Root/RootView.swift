import ComposableArchitecture
import SwiftUI

struct RootView: View {
    @Bindable var store: StoreOf<RootFeature>

    @ViewBuilder
    var body: some View {
        Text("")
    }
}

#Preview {
    RootView(
        store: Store(initialState: RootFeature.State()) {}
    )
}

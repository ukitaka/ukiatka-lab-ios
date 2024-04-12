import ComposableArchitecture
import SwiftUI

struct RootView: View {
    @Bindable var store: StoreOf<RootFeature>

    @ViewBuilder
    var body: some View {
        switch store.state.status {
        case .initial:
            Text("Initial view").onAppear {
                store.send(.onAppear)
            }

        case .loading:
            VStack {
                LogoLoadingView()
            }
        }
    }
}

#Preview {
    RootView(
        store: Store(initialState: RootFeature.State()) {}
    )
}

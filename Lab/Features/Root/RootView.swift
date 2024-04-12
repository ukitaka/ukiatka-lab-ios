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

        case .login:
            LoginView(
                store: Store(initialState: LoginFeature.State()) {
                    LoginFeature()
                }
            )

        case .home:
            Text("Home") // TODO: fix later
        }
    }
}

#Preview {
    RootView(
        store: Store(initialState: RootFeature.State()) {
            RootFeature()
        }
    )
}

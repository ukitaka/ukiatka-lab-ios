import ComposableArchitecture
import SwiftUI

struct RootView: View {
    var store: StoreOf<RootFeature>

    @ViewBuilder
    var body: some View {
        switch store.state {
        case .initial:
            Text("Initial view").onAppear {
                store.send(.onAppear)
            }

        case .loading:
            VStack {
                LogoLoadingView()
            }

        case .login:
            // ここあとでreportしたい. !の有無で挙動が変わる。(コンパイルエラーにはならない)
            LoginView(store: store.scope(state: \.login, action: \.loginScreen)!)

        case .home:
            VStack {
                Button("Logout") {
                    store.send(.logout)
                }
            }
        }
    }
}

#Preview {
    RootView(
        store: Store(initialState: RootFeature.State.initial) {
            RootFeature()
        }
    )
}

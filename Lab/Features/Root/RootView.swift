import ComposableArchitecture
import SwiftUI

struct RootView: View {
    var store: StoreOf<RootFeature>

    @ViewBuilder
    var body: some View {
        switch store.state {
        case .initial:
            VStack {
                Image("Icon")
            }.onAppear {
                store.send(.onAppear)
            }

        case .loading:
            VStack {
                LogoLoadingView()
            }

        case .login:
            // ここあとでreportしたい. !の有無で挙動が変わる。(コンパイルエラーにはならない)
            LoginView(store: store.scope(state: \.login, action: \.login)!)

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

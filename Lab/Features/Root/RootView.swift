import ComposableArchitecture
import SwiftUI

struct RootView: View {
    var store: StoreOf<RootFeature>

    @ViewBuilder
    var body: some View {
        switch store.state {
        case .loading:
            VStack {
                LogoLoadingView(width: 32.0, height: 32.0)
            }.onAppear {
                store.send(.onAppear)
            }

        case .login:
            // ここあとでreportしたい. !の有無で挙動が変わる。(コンパイルエラーにはならない)
            LoginView(store: store.scope(state: \.login, action: \.login)!)

        case .home:
            HomeView(store: store.scope(state: \.home, action: \.home)!)
        }
    }
}

#Preview {
    RootView(
        store: Store(initialState: .loading) {
            RootFeature()
        }
    )
}

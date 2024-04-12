import ComposableArchitecture
import Dependencies
import DependenciesMacros
import SwiftUI

@Reducer
struct RootFeature {
    @ObservableState
    struct State {
        enum Status {
            case initial
            case loading
            case login
            case home
        }

        var status: Status = .initial
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case showLoginScreen
        case showHomeScreen
    }

    @Dependency(\.loginSessionClient) private var loginSessionClient

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .onAppear:
                guard state.status == .initial else {
                    return .none
                }
                state.status = .loading
                return .run { send in
                    if await loginSessionClient.isLoggedIn() {
                        await send(.showHomeScreen)
                    } else {
                        await send(.showLoginScreen)
                    }
                }

            case .showLoginScreen:
                state.status = .login
                return .none

            case .showHomeScreen:
                state.status = .home
                return .none
            }
        }
    }
}

import ComposableArchitecture
import Dependencies
import DependenciesMacros
import SwiftUI

@Reducer
struct RootFeature: Reducer {
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

    enum Action {
        case onAppear
        case loginScreen
        case homeScreen
    }

    @Dependency(\.loginSessionClient) private var loginSessionClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard state.status == .initial else {
                    return .none
                }
                state.status = .loading
                return .run { send in
                    if await loginSessionClient.isLoggedIn() {
                        await send(.homeScreen)
                    } else {
                        await send(.loginScreen)
                    }
                }

            case .loginScreen:
                state.status = .login
                return .none

            case .homeScreen:
                state.status = .home
                return .none
            }
        }
    }
}

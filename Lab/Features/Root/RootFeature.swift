import ComposableArchitecture
import Dependencies
import DependenciesMacros
import SwiftUI

@Reducer
struct RootFeature: Reducer {
    @ObservableState
    enum State: Equatable {
        case initial
        case loading
        case login(LoginFeature.State)
        case home
    }

    enum Action {
        case onAppear
        case loginScreen(LoginFeature.Action)
        case homeScreen
    }

    @Dependency(\.loginSessionClient) private var loginSessionClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard state == .initial else {
                    return .none
                }
                state = .loading
                return .run { send in
                    if await loginSessionClient.isLoggedIn() {
                        await send(.homeScreen)
                    } else {
                        await send(.loginScreen(.startLoginFlow))
                    }
                }

            case .loginScreen:
                state = .login(.init())
                return .none

            case .homeScreen:
                state = .home
                return .none
            }
        }
        .ifCaseLet(\.login, action: \.loginScreen) {
            LoginFeature()
        }
    }
}

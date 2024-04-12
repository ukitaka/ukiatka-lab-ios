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
        case logout
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

            case .loginScreen(.loginCompleted):
                return .none

            case .loginScreen(.startLoginFlow):
                state = .login(.init())
                return .none

            case .loginScreen:
                return .none

            case .homeScreen:
                state = .home
                return .none

            case .logout:
                state = .login(.init())
                return .run { _ in
                    try await loginSessionClient.logout()
                }
            }
        }
        .ifCaseLet(\.login, action: \.loginScreen) {
            LoginFeature()
        }
    }
}

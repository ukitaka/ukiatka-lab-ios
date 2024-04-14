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
        case home(HomeFeature.State)
    }

    enum Action {
        case onAppear
        case logout
        case login(LoginFeature.Action)
        case home(HomeFeature.Action)
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
                        await send(.home(.onAppear))
                    } else {
                        await send(.login(.startLoginFlow))
                    }
                }

            case .login(.loginCompleted):
                state = .home(.init())
                return .none

            case .login(.startLoginFlow):
                state = .login(.init())
                return .none

            case .login:
                return .none

            case .home:
                state = .home(.init())
                return .none

            case .logout:
                state = .login(.init())
                return .run { _ in
                    try await loginSessionClient.logout()
                }
            }
        }
        .ifCaseLet(\.login, action: \.login) {
            LoginFeature()
        }
        .ifCaseLet(\.home, action: \.home) {
            HomeFeature()
        }
    }
}

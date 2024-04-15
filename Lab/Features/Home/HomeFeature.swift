import ComposableArchitecture
import Dependencies
import SwiftUI

@Reducer
struct HomeFeature {
    @ObservableState
    struct State: Equatable {
        var isFetching = true
        var bookmarks: [Bookmark] = []
    }

    enum Action: BindableAction {
        case startFetching
        case completeFetching([Bookmark])
        case binding(BindingAction<State>)
    }

    @Dependency(\.labAPIClient) private var labAPIClient

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .startFetching:
                state.isFetching = true
                return .run { send in
                    let bookmarks = try await labAPIClient.fetchBookmarks()
                    await send(.completeFetching(bookmarks))
                }

            case let .completeFetching(bookmarks):
                state.isFetching = false
                state.bookmarks = bookmarks
                return .none
            }
        }
    }
}

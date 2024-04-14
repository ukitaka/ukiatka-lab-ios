import ComposableArchitecture
import Dependencies
import SwiftUI

@Reducer
struct HomeFeature {
    @ObservableState
    enum State: Equatable {
        case fetching
        case bookmarks([Bookmark])
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
                return .run { send in
                    let bookmarks = try await labAPIClient.fetchBookmarks()
                    await send(.completeFetching(bookmarks))
                }

            case let .completeFetching(bookmarks):
                state = .bookmarks(bookmarks)
                return .none
            }
        }
    }
}

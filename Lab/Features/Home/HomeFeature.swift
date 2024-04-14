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

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .startFetching:
                return .run { send in
                    // TODO: use dependency
                    let bookmarks = try await LabAPIClient(baseURL: "https://ukitaka-lab.app").fetchBookmarks()
                    print(bookmarks)

                    await send(.completeFetching(bookmarks))
                }

            case let .completeFetching(bookmarks):
                state = .bookmarks(bookmarks)
                return .none
            }
        }
    }
}

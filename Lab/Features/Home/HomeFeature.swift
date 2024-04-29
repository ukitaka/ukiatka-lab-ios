import ComposableArchitecture
import Dependencies
import SwiftUI

@Reducer
struct HomeFeature {
    @ObservableState
    struct State {
        var isFetching = true
        var bookmarks: [Bookmark] = []
        var path = StackState<Path.State>()
        @Presents var destination: Destination.State?
    }

    enum Action {
        case startFetching
        case completeFetching([Bookmark])
        case addButtonTapped
        case path(StackActionOf<Path>)
        case destination(PresentationAction<Destination.Action>)
    }

    @Reducer
    enum Path {
        case bookmarkDetail(BookmarkDetailFeature)
    }

    @Reducer
    enum Destination {
        case addBookmark(AddBookmarkFeature)
    }

    @Dependency(\.labAPIClient) private var labAPIClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
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

            case .addButtonTapped:
                state.destination = .addBookmark(AddBookmarkFeature.State())
                return .none

            case .path(.element(id: _, action: .bookmarkDetail(.doneDelete))):
                _ = state.path.popLast()
                return .run { send in
                    await send(.startFetching) // reload
                }

            case .destination:
                return .none

            case .path:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        .forEach(\.path, action: \.path)
    }
}

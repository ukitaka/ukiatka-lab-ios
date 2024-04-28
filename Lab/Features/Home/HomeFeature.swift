import ComposableArchitecture
import Dependencies
import SwiftUI

@Reducer
struct HomeFeature {
    @ObservableState
    struct State {
        var isFetching = true
        var bookmarks: [Bookmark] = []
        @Presents var destination: Destination.State?
    }

    enum Action {
        case startFetching
        case completeFetching([Bookmark])
        case addButtonTapped
        case destination(PresentationAction<Destination.Action>)
    }

    @Reducer
    enum Destination {
        case addBookmark(AddBookmarkFeature)
        case bookmarkDetail(BookmarkDetailFeature)
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

            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

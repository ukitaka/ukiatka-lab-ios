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
        case fetchBookmarks(APIRequestAction<[Bookmark]>)
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
            case .fetchBookmarks(.startFetching):
                state.isFetching = true
                return .run { send in
                    do {
                        let bookmarks = try await labAPIClient.fetchBookmarks()
                        await send(.fetchBookmarks(.completed(bookmarks)))
                    } catch {
                        await send(.fetchBookmarks(.error(error)))
                    }
                }

            case let .fetchBookmarks(.completed(bookmarks)):
                state.isFetching = false
                state.bookmarks = bookmarks
                return .none

            case .addButtonTapped:
                state.destination = .addBookmark(AddBookmarkFeature.State())
                return .none

            case .path(.element(id: _, action: .bookmarkDetail(.deleteBookmark(.completed)))):
                _ = state.path.popLast()
                return .run { send in
                    await send(.fetchBookmarks(.startFetching)) // reload
                }

            case .destination:
                return .none

            case .path:
                return .none

            case let .fetchBookmarks(error):
                print(error) // error handling
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        .forEach(\.path, action: \.path)
    }
}

import ComposableArchitecture
import SwiftUI

@Reducer
struct BookmarkDetailFeature {
    @ObservableState
    struct State: Equatable {
        var isFetching = false
        var bookmark: Bookmark
        @Presents var destination: Destination.State?
    }

    @Reducer(state: .equatable) enum Destination {
        case bookmarkAction
        case deleteConfirm
        case addNote(AddNoteFeature)
    }

    enum Action {
        case fetchBookmarkDetail(APIRequestAction<Bookmark>)
        case requestLLMSummary
        case gearButtonTapped
        case addNoteButtonTapped
        case openURL(URL)
        case deleteBookmark(DialogAction)
        case destination(PresentationAction<Destination.Action>)
    }

    @Dependency(\.openURL) private var openURL
    @Dependency(\.labAPIClient) private var labAPIClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchBookmarkDetail(.startFetching):
                state.isFetching = true
                return .run { [bookmarkID = state.bookmark.id] send in
                    let bookmark = try await labAPIClient.fetchBookmark(id: bookmarkID)
                    await send(.fetchBookmarkDetail(.completed(bookmark)))
                }

            case let .fetchBookmarkDetail(.completed(bookmark)):
                state.isFetching = false
                state.bookmark = bookmark
                return .none

            case .requestLLMSummary:
                state.isFetching = true
                return .run { [bookmarkID = state.bookmark.id] send in
                    try await labAPIClient.enqueueLLMSummary(id: bookmarkID)
                    await send(.fetchBookmarkDetail(.startFetching))
                }

            case let .openURL(url):
                return .run { _ in
                    await openURL(url)
                }

            case .gearButtonTapped:
                state.destination = .bookmarkAction
                return .none

            case .deleteBookmark(.confirmation):
                state.destination = .deleteConfirm
                return .none

            case .deleteBookmark(.executeAction):
                state.isFetching = true
                return .run { [bookmarkID = state.bookmark.id] send in
                    try await labAPIClient.deleteBookmark(id: bookmarkID)
                    await send(.deleteBookmark(.completed))
                }

            case .deleteBookmark(.completed):
                state.isFetching = false
                return .none

            case let .fetchBookmarkDetail(.error(error)):
                print(error) // TODO: Error handling
                return .none

            case .addNoteButtonTapped:
                state.destination = .addNote(AddNoteFeature.State(bookmark: state.bookmark))
                return .none

            case let .destination(.presented(.addNote(.addNote(.completed(note))))):
                state.bookmark.notes?.append(note)
                return .none

            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

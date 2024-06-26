import ComposableArchitecture
import SwiftUI

@Reducer
struct BookmarkDetailFeature {
    @ObservableState
    struct State: Equatable {
        var isFetching = false
        var bookmark: Bookmark
        var selectedNote: Note?
        @Presents var destination: Destination.State?
    }

    @Reducer(state: .equatable) enum Destination {
        case bookmarkAction
        case deleteBookmarkConfirm
        case deleteNoteConfirm
        case addNote(AddNoteFeature)
    }

    enum Action {
        case fetchBookmarkDetail(APIRequestAction<Bookmark>)
        case requestLLMSummary
        case requestMetadata
        case requestGenerateOGImage
        case gearButtonTapped
        case addNoteButtonTapped
        case openURL(URL)
        case deleteBookmark(DialogAction)
        case deleteNote(Note, DialogAction)
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
                state.destination = .deleteBookmarkConfirm
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

            case .requestMetadata:
                state.isFetching = true
                return .run { [url = state.bookmark.url] send in
                    let bookmark = try await labAPIClient.addBookmark(urlString: url, force: true)
                    await send(.fetchBookmarkDetail(.completed(bookmark)))
                }

            case .requestGenerateOGImage:
                state.isFetching = true
                return .run { [id = state.bookmark.id] send in
                    try await labAPIClient.generateOGImage(id: id)
                    await send(.fetchBookmarkDetail(.startFetching))
                }

            case let .deleteNote(note, .confirmation):
                state.selectedNote = note
                state.destination = .deleteNoteConfirm
                return .none

            case let .deleteNote(note, .executeAction):
                state.isFetching = true
                return .run { [bookmarkID = state.bookmark.id] send in
                    try await labAPIClient.deleteNote(bookmarkID: bookmarkID, noteID: note.id)
                    await send(.deleteNote(note, .completed))
                }

            case .deleteNote(_, .completed):
                state.selectedNote = nil
                return .run { send in
                    await send(.fetchBookmarkDetail(.startFetching))
                }

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

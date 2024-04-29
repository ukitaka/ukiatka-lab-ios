import ComposableArchitecture
import SwiftUI

@Reducer
struct BookmarkDetailFeature {
    @ObservableState
    struct State: Equatable {
        var isFetching = false
        var bookmark: Bookmark
    }

    enum Action {
        case refetchBookmarkDetail
        case updateBookmark(Bookmark)
        case requestLLMSummary
        case openURL(URL)
    }

    @Dependency(\.openURL) private var openURL
    @Dependency(\.labAPIClient) private var labAPIClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .refetchBookmarkDetail:
                state.isFetching = true
                return .run { [bookmarkID = state.bookmark.id] send in
                    let bookmark = try await labAPIClient.fetchBookmark(id: bookmarkID)
                    await send(.updateBookmark(bookmark))
                }

            case let .updateBookmark(bookmark):
                state.isFetching = false
                state.bookmark = bookmark
                return .none

            case .requestLLMSummary:
                state.isFetching = true
                return .run { [bookmarkID = state.bookmark.id] send in
                    try await labAPIClient.enqueueLLMSummary(id: bookmarkID)
                    await send(.refetchBookmarkDetail)
                }

            case let .openURL(url):
                return .run { _ in
                    await openURL(url)
                }
            }
        }
    }
}

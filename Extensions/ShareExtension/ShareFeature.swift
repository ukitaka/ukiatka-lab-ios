import ComposableArchitecture
import SwiftUI

@Reducer
struct ShareFeature {
    @Dependency(\.labAPIClient) var labAPIClient

    var url: URL
    var onCompleted: () -> Void

    @ObservableState
    enum State {
        case adding
        case success(Bookmark)
        case failure(Error)
    }

    enum Action {
        case startAddBookmarkRequest
        case requestCompleted(Result<Bookmark, Error>)
        case close
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startAddBookmarkRequest:
                return .run { send in
                    do {
                        let bookmark = try await labAPIClient.addBookmark(urlString: url.absoluteString)
                        await send(.requestCompleted(.success(bookmark)))
                    } catch {
                        await send(.requestCompleted(.failure(error)))
                    }
                }

            case let .requestCompleted(result):
                switch result {
                case let .success(bookmark):
                    state = .success(bookmark)

                case let .failure(error):
                    state = .failure(error)
                }
                return .run { send in
                    await send(.close)
                }

            case .close:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                    onCompleted()
                }
                return .none
            }
        }
    }
}

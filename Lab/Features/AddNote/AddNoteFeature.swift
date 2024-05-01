import ComposableArchitecture
import SwiftUI

@Reducer
struct AddNoteFeature {
    @ObservableState
    struct State: Equatable {
        var bookmark: Bookmark
        var text: String = ""
    }

    enum Action: BindableAction {
        case addNote(APIRequestAction<Note>)
        case binding(BindingAction<State>)
    }

    @Dependency(\.labAPIClient) var labAPIClient
    @Dependency(\.dismiss) var dismiss

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .addNote(.startFetching):
                return .run { [bookmarkID = state.bookmark.id, text = state.text] send in
                    let note = try await labAPIClient.addNote(bookmarkID: bookmarkID, content: text)
                    await send(.addNote(.completed(note)))
                }

            case let .addNote(.error(error)):
                print(error)
                return .none

            case .addNote(.completed):
                return .run { _ in await dismiss() }

            case .binding:
                return .none
            }
        }
    }
}

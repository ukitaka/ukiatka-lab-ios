import ComposableArchitecture
import RichTextKit
import SwiftUI

@Reducer
struct AddNoteFeature {
    @ObservableState
    struct State: Equatable {
        var bookmark: Bookmark
        var text = NSAttributedString(string: "")
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
                guard let contentData = try? state.text.richTextData(for: .rtf) else {
                    return .none
                }
                return .run { [bookmarkID = state.bookmark.id] send in
                    let content = String(data: contentData, encoding: .utf8)!
                    let note = try await labAPIClient.addNote(bookmarkID: bookmarkID, content: content)
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

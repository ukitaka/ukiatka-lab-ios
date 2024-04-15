import ComposableArchitecture
import SwiftUI

@Reducer
struct AddBookmarkFeature {
    @ObservableState
    struct State: Equatable {
        var urlString: String = ""
        var isSubmitting = false
        @Presents var alert: AlertState<Action.Alert>?
    }

    @Dependency(\.labAPIClient) private var labAPIClient
    @Dependency(\.dismiss) private var dismiss

    enum Action: BindableAction {
        case addButtonTapped
        case submitCompleted(Result<Bookmark, Error>)
        case alert(PresentationAction<Alert>)
        case binding(BindingAction<State>)

        @CasePathable
        enum Alert: Equatable {
            case ok
        }
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .alert:
                return .none

            case .binding:
                return .none

            case .addButtonTapped:
                state.isSubmitting = true
                return .run { [urlString = state.urlString] send in
                    do {
                        let bookmark = try await labAPIClient.addBookmark(urlString: urlString)
                        await send(.submitCompleted(.success(bookmark)))
                    } catch {
                        await send(.submitCompleted(.failure(error)))
                    }
                }

            case .submitCompleted(.success):
                state.isSubmitting = false
                return .run { _ in
                    await dismiss()
                }

            case let .submitCompleted(.failure(error)):
                state.isSubmitting = false
                if let error = error as? LabAPIClient.APIError {
                    state.alert = .error(message: error.error)
                } else {
                    state.alert = .error(message: error.localizedDescription)
                }
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

extension AlertState where Action == AddBookmarkFeature.Action.Alert {
    static func error(message: String) -> Self {
        Self {
            TextState("ブックマークを作成できませんでした。")
        } actions: {
            ButtonState(role: .cancel, action: .ok) {
                TextState("閉じる")
            }
        } message: {
            TextState(message)
        }
    }
}

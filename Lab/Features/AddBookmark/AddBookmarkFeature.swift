import ComposableArchitecture
import SwiftUI

@Reducer
struct AddBookmarkFeature {
    @ObservableState
    struct State: Equatable {
        var urlString: String = ""
        var isSubmitting = false
    }

    @Dependency(\.labAPIClient) private var labAPIClient

    enum Action: BindableAction {
        case addButtonTapped
        case submitCompleted
        case binding(BindingAction<State>)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .addButtonTapped:
                state.isSubmitting = true
                return .run { [urlString = state.urlString] send in
                    try await labAPIClient.addBookmark(urlString: urlString)
                    await send(.submitCompleted)
                }

            case .submitCompleted:
                state.isSubmitting = false
                return .none
            }
        }
    }
}

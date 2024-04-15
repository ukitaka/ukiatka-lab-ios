import ComposableArchitecture
import SwiftUI

@Reducer
struct AddBookmarkFeature {
    @ObservableState
    struct State: Equatable {
        var urlString: String = ""
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { _, action in
            switch action {
            case .binding:
                .none
            }
        }
    }
}

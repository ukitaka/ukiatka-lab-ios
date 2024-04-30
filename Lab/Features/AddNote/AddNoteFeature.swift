import ComposableArchitecture
import SwiftUI

@Reducer
struct AddNoteFeature {
    @ObservableState
    struct State: Equatable {}

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

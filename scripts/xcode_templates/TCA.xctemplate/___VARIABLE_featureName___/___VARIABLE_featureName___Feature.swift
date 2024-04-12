import ComposableArchitecture
import SwiftUI

@Reducer
struct ___VARIABLE_featureName___Feature {
    @ObservableState
    struct State {}

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

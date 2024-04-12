import ComposableArchitecture
import SwiftUI

@Reducer
struct ___VARIABLE_featureName___Feature {
    @ObservableState
    struct State {
        enum Status {
            case initial
        }

        var status: Status = .initial
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                .none
            }
        }
    }
}

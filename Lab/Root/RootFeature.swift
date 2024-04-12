import ComposableArchitecture
import SwiftUI

@Reducer
struct RootFeature {
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

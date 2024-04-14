import ComposableArchitecture
import SwiftUI

@Reducer
struct HomeFeature {
    @ObservableState
    struct State: Equatable {
        enum Status: Equatable {
            case initial
        }

        var status: Status = .initial
    }

    enum Action: BindableAction {
        case onAppear
        case binding(BindingAction<State>)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { _, action in
            switch action {
            case .binding:
                .none

            case .onAppear:
                .none
            }
        }
    }
}

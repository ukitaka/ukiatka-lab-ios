import ComposableArchitecture
import Dependencies
import SwiftUI

@Reducer
struct RootFeature {
    @ObservableState
    struct State {
        enum Status {
            case initial
            case loading
        }

        var status: Status = .initial
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .onAppear:
                guard state.status == .initial else {
                    return .none
                }
                state.status = .loading
                return .none
            }
        }
    }
}

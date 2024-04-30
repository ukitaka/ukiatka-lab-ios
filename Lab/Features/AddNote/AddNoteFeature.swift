import ComposableArchitecture
import RichTextKit
import SwiftUI

@Reducer
struct AddNoteFeature {
    @ObservableState
    struct State: Equatable {
        var text = NSAttributedString(string: "")
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

import ComposableArchitecture
import SwiftUI

@Reducer
struct BookmarkDetailFeature {
    @ObservableState
    struct State: Equatable {}

    enum Action {}

    var body: some ReducerOf<Self> {
        Reduce { _, _ in
            .none
        }
    }
}

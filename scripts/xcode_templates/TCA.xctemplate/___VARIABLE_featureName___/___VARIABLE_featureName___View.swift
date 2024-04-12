import ComposableArchitecture
import SwiftUI

struct ___VARIABLE_featureName___View: View {
    @Bindable var store: StoreOf<___VARIABLE_featureName___Feature>

    @ViewBuilder
    var body: some View {}
}

#Preview {
    ___VARIABLE_featureName___View(
        store: Store(initialState: ___VARIABLE_featureName___Feature.State()) {}
    )
}

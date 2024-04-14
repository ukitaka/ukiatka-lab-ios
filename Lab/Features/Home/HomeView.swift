import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>

    @ViewBuilder
    var body: some View {
        Text("home")
    }
}

#Preview {
    HomeView(
        store: Store(initialState: HomeFeature.State()) {}
    )
}

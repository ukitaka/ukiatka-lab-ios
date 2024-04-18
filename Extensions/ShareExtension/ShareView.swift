import ComposableArchitecture
import SwiftUI

struct ShareView: View {
    @Bindable var store: StoreOf<ShareFeature>

    @ViewBuilder
    var body: some View {
        VStack {
            LogoLoadingView(width: 32.0, height: 32.0)
        }
        .onAppear {
            store.send(.startAddBookmarkRequest)
        }
    }
}

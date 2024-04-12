import ComposableArchitecture
import SwiftUI

struct RootView: View {
    @Bindable var store: StoreOf<RootFeature>

    @State private var rotationDegrees = 0.0
    private var animation: Animation {
        .easeInOut
            .speed(0.3)
            .repeatForever(autoreverses: false)
    }

    @ViewBuilder
    var body: some View {
        switch store.state.status {
        case .initial:
            Text("Initial view").onAppear {
                store.send(.onAppear)
            }

        case .loading:
            VStack {
                Image("Icon")
                    .resizable()
                    .frame(width: 64, height: 64)
                    .rotationEffect(.degrees(rotationDegrees))
                    .onAppear {
                        withAnimation(animation) {
                            rotationDegrees = 360.0
                        }
                    }
            }
        }
    }
}

#Preview {
    RootView(
        store: Store(initialState: RootFeature.State()) {}
    )
}

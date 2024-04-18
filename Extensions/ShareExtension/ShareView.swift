import ComposableArchitecture
import SwiftUI

struct ShareView: View {
    @Bindable var store: StoreOf<ShareFeature>

    @State var opacity: CGFloat = 0.0

    @ViewBuilder
    var body: some View {
        VStack(spacing: 16.0) {
            switch store.state {
            case .adding:
                LogoLoadingView(width: 32.0, height: 32.0)
                Text("ブックマークに追加しています....")
                    .font(.caption)

            case .success:
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64.0, height: 64.0)
                    .foregroundColor(.labPrimary)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.linear(duration: 0.1)) {
                            opacity = 1.0
                        }
                    }
                Text("ブックマークに追加しました！")
                    .fontWeight(.semibold)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.linear(duration: 0.1)) {
                            opacity = 1.0
                        }
                    }

            case .failure:
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64.0, height: 64.0)
                    .foregroundColor(.red)
                Text("失敗しました")
                    .fontWeight(.semibold)
            }
        }
        .onAppear {
            store.send(.startAddBookmarkRequest)
        }
    }
}

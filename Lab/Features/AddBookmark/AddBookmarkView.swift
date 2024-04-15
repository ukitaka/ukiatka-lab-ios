import ComposableArchitecture
import SwiftUI

struct AddBookmarkView: View {
    @Namespace var namespace
    @Bindable var store: StoreOf<AddBookmarkFeature>
    @FocusState var focus: Bool

    @Environment(\.dismiss) var dismiss

    @ViewBuilder
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Button("キャンセル") {
                        dismiss()
                    }
                    Spacer()
                    Button("追加") {
                        store.send(.addButtonTapped)
                    }
                    .fontWeight(.semibold)
                }
                TextField("URL", text: $store.urlString)
                    .focused($focus)
                    .onAppear {
                        focus = true
                    }
                Spacer()
            }.padding()
            if store.isSubmitting {
                VStack {
                    LogoLoadingView(width: 32.0, height: 32.0)
                }
            }
        }
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}

#Preview {
    AddBookmarkView(
        store: Store(initialState: AddBookmarkFeature.State()) {}
    )
}

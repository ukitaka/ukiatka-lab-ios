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
                    .frame(width: 80.0, height: 32.0)
                    .background(Color.labPrimary)
                    .foregroundColor(Color.white)
                    .cornerRadius(16.0)
                    .fontWeight(.semibold)
                }
                HStack {
                    Image("Icon")
                        .resizable()
                        .frame(width: 16.0, height: 16.0)
                    TextField("URL", text: $store.urlString)
                        .focused($focus)
                        .onAppear {
                            focus = true
                        }
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

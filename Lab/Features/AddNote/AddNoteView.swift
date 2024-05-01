import ComposableArchitecture
import SwiftUI

struct AddNoteView: View {
    @Bindable var store: StoreOf<AddNoteFeature>

    @Environment(\.dismiss) var dismiss
    @FocusState var focus: Bool

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
                        store.send(.addNote(.startFetching))
                    }
                    .frame(width: 80.0, height: 32.0)
                    .background(Color.labPrimary)
                    .foregroundColor(Color.white)
                    .cornerRadius(16.0)
                    .fontWeight(.semibold)
                }
                Spacer()
            }
            .padding()
            .onAppear {
                focus = true
            }
        }
    }
}

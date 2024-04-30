import ComposableArchitecture
import SwiftUI

struct AddNoteView: View {
    @Bindable var store: StoreOf<AddNoteFeature>

    @ViewBuilder
    var body: some View {
        Text("Add note view")
    }
}

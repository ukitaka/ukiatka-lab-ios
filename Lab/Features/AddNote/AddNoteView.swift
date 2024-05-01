import ComposableArchitecture
import MarkdownUI
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
                    Button("プレビュー切り替え") {
                        store.send(.togglePreviewMode)
                    }
                    Button("追加") {
                        store.send(.addNote(.startFetching))
                    }
                    .frame(width: 80.0, height: 32.0)
                    .background(Color.labPrimary)
                    .foregroundColor(Color.white)
                    .cornerRadius(16.0)
                    .fontWeight(.semibold)
                }
                switch store.previewMode {
                case .markdown:
                    Markdown {
                        store.text
                    }.markdownTheme(.labTheme)

                case .plaintext:
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $store.text)
                            .padding(.horizontal, -4)
                            .frame(minHeight: 200)
                            .focused($focus)
                        if store.text.isEmpty {
                            Text("ここにノートを入力...").foregroundColor(Color(uiColor: .placeholderText))
                                .padding(.vertical, 8)
                                .allowsHitTesting(false)
                        }
                    }
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

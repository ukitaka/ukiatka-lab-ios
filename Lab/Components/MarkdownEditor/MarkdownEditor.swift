import SwiftUI

struct MarkdownEditor: View {
    var body: some View {
        VStack(alignment: .center) {
            TextEditor(text: /*@START_MENU_TOKEN@*/ .constant("Placeholder")/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    MarkdownEditor()
}

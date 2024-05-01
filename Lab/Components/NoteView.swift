import Dependencies
import MarkdownUI
import SwiftUI

struct NoteView: View {
    let note: Note

    @Dependency(\.datetimeFormatter) var datetimeFormmater

    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            HStack(alignment: .center, spacing: 8.0) {
                switch note.editor {
                case .ukitaka:
                    Image("ukitaka")
                        .resizable()
                        .frame(width: 16.0, height: 16.0)
                    Text("ukitaka")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.labText)

                case .ai:
                    Image(systemName: "brain.filled.head.profile")
                        .resizable()
                        .frame(width: 16.0, height: 16.0)
                    Text("AI要約")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.labText)
                }
                Spacer()
                Text(datetimeFormmater.string(from: note.createdAt))
                    .font(.caption2)
                    .fontWeight(.light)
            }
            switch note.status {
            case .completed:
                Markdown {
                    note.content
                }.markdownTheme(.labTheme)

            case .queued:
                HStack {
                    Text("要約を生成中です...")
                    LogoLoadingView(width: 16.0, height: 16.0)
                }
            }
        }
    }
}

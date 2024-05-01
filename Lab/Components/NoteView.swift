import Dependencies
import MarkdownUI
import SwiftUI

struct NoteView: View {
    let note: Note

    @Dependency(\.datetimeFormatter) var datetimeFormmater

    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            HStack(alignment: .bottom, spacing: 8.0) {
                switch note.editor {
                case .ukitaka:
                    Image("ukitaka")
                        .resizable()
                        .frame(width: 16.0, height: 16.0)
                        .cornerRadius(3.0)
                        .clipped()

                case .ai:
                    Image(systemName: "brain.filled.head.profile")
                        .resizable()
                        .frame(width: 16.0, height: 16.0)
                }
                HStack(alignment: .firstTextBaseline) {
                    switch note.editor {
                    case .ukitaka:
                        Text("ukitaka")
                            .fontWeight(.bold)
                            .font(.system(size: 15.0))
                            .foregroundStyle(Color.labText)

                    case .ai:
                        Text("AI要約")
                            .fontWeight(.bold)
                            .font(.system(size: 15.0))
                            .foregroundStyle(Color.labText)
                    }
                    Text(datetimeFormmater.string(from: note.createdAt))
                        .fontWeight(.light)
                        .font(.caption)
                    Spacer()
                }
                Spacer()
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
            Divider()
        }
    }
}

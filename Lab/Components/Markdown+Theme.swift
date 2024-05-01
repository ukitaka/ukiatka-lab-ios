import MarkdownUI

extension MarkdownUI.Theme {
    static let labTheme = Theme()
        .listItem { config in
            config.label.markdownMargin(top: .em(0.8))
        }
}

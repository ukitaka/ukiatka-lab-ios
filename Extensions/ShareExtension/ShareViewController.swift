import Auth
import Dependencies
import Social
import UIKit
import UniformTypeIdentifiers

class ShareViewController: UIViewController {
    @Dependency(\.loginSessionClient) var loginSessionClient
    @Dependency(\.labAPIClient) var labAPIClient

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem else {
            return close()
        }

        guard let itemProvider = extensionItem.attachments?.first else {
            return close()
        }

        guard itemProvider.hasItemConformingToTypeIdentifier(UTType.url.identifier) else {
            return close()
        }

        itemProvider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { item, _ in
            guard let url = item as? URL else {
                return self.close()
            }

            Task {
                try await self.addBookmark(url: url)
                self.extensionContext?.completeRequest(returningItems: []) { _ in }
            }
        }
    }

    func addBookmark(url: URL) async throws {
        let isLoggedIn = await loginSessionClient.isLoggedIn()
        let bookmark = try await labAPIClient.addBookmark(urlString: url.absoluteString)
    }

    func close() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}

import Social
import UIKit
import UniformTypeIdentifiers

class ShareViewController: UIViewController {
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
            var uc = URLComponents()
            uc.scheme = "app.ukitaka-lab"
            uc.host = "ukitaka-lab"
            uc.path = "/add_bookmarks"
            uc.queryItems = [URLQueryItem(name: "url", value: url.absoluteString)]
            print(uc.url)

            DispatchQueue.main.async {
                self.extensionContext?.completeRequest(returningItems: []) { _ in
                    self.extensionContext?.open(uc.url!)
                }
            }
        }

        // extensionContext.cancelRequest(withError: error)
    }

    func close() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}

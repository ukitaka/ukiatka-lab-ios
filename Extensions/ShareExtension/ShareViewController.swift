import Social
import UIKit
import UniformTypeIdentifiers

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let extensionContext else {
            return
        }

        guard let extensionItem = extensionContext.inputItems.first as? NSExtensionItem else {
            return
        }

        guard let itemProvider = extensionItem.attachments?.first else {
            return
        }

        guard itemProvider.hasItemConformingToTypeIdentifier(UTType.url.identifier) else {
            return
        }

        itemProvider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { item, _ in
            guard let url = item as? URL else { return }
            print(url)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.2) {
                extensionContext.completeRequest(returningItems: [], completionHandler: nil)
            }
        }
        // extensionContext.cancelRequest(withError: error)
    }
}

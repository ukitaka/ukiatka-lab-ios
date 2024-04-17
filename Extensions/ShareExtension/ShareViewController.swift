import Lab
import Social
import UIKit
import UniformTypeIdentifiers

class ShareViewController: SLComposeServiceViewController {
    override func presentationAnimationDidFinish() {
        super.presentationAnimationDidFinish()
        guard let extensionContext else {
            return cancel()
        }

        guard let extensionItem = extensionContext.inputItems.first as? NSExtensionItem else {
            return cancel()
        }

        guard let itemProvider = extensionItem.attachments?.first else {
            return cancel()
        }

        guard itemProvider.hasItemConformingToTypeIdentifier(UTType.url.identifier) else {
            return cancel()
        }

        itemProvider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { item, _ in
            guard let url = item as? URL else { return }
            print(url)
            extensionContext.completeRequest(returningItems: [], completionHandler: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    self.cancel()
                }
            })
        }
        // extensionContext.cancelRequest(withError: error)
    }
}

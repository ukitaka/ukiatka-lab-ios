import Auth
import Dependencies
import Social
import SwiftUI
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
            DispatchQueue.main.async {
                guard let url = item as? URL else {
                    return self.close()
                }

                let shareView = ShareView(store: .init(initialState: .adding, reducer: { [weak self] in
                    ShareFeature(url: url) {
                        DispatchQueue.main.async {
                            self?.close()
                        }
                    }
                }))

                let hostingViewController = UIHostingController(rootView: shareView)
                self.addChild(hostingViewController)
                self.view.addSubview(hostingViewController.view)
                hostingViewController.view.translatesAutoresizingMaskIntoConstraints = false
                hostingViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
                hostingViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
                hostingViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
                hostingViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
            }
        }
    }

    func close() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}

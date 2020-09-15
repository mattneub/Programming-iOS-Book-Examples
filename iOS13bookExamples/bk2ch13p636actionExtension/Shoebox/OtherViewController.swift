

import UIKit
import MobileCoreServices

class OtherViewController: UIViewController {
    
    let desiredType = kUTTypePlainText as String
    
    var s : String?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let items = self.extensionContext!.inputItems
        // open the envelopes
        guard let extensionItem = items[0] as? NSExtensionItem else {return}
        guard let provider = extensionItem.attachments?.first else {return}
        guard provider.hasItemConformingToTypeIdentifier(self.desiredType) else {return}
        provider.loadItem(forTypeIdentifier: self.desiredType) {
            (item:NSSecureCoding?, err:Error!) -> () in
            DispatchQueue.main.async {
                self.s = item as? String
            }
        }
    }
    
    @IBAction func doButton(_ sender: Any) {
        self.extensionContext!.completeRequest(returningItems:[])
    }

}



import UIKit
import MobileCoreServices

class OtherViewController: UIViewController {
    
    let desiredType = kUTTypePlainText as String
    
    var s : String?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let items = self.extensionContext!.inputItems
        // open the envelopes
        guard let extensionItem = items[0] as? NSExtensionItem,
            let provider = extensionItem.attachments?[0] as? NSItemProvider
            where provider.hasItemConformingToTypeIdentifier(self.desiredType)
            else {
                return
        }
        provider.loadItemForTypeIdentifier(self.desiredType, options: nil) {
            (item:NSSecureCoding?, err:NSError!) -> () in
            dispatch_async(dispatch_get_main_queue()) {
                self.s = item as? String
            }
        }
    }
    
    @IBAction func doButton(sender: AnyObject) {
        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
    }

}

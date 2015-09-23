

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController, SizeDelegate {
    
    var selectedText = "Large" {
        didSet {
            self.config?.value = self.selectedText
        }
    }
    weak var config : SLComposeSheetConfigurationItem?

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
    }

    override func configurationItems() -> [AnyObject]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        let c = SLComposeSheetConfigurationItem()
        c.title = "Size"
        c.value = self.selectedText
        c.tapHandler = {
            [unowned self] in
            let tvc = TableViewController(style: UITableViewStyle.Plain)
            tvc.selectedSize = self.selectedText
            tvc.delegate = self
            self.pushConfigurationViewController(tvc)
        }
        self.config = c
        return [c]
    }
    

}

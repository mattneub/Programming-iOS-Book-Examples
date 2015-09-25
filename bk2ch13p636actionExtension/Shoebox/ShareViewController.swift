

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
    
        let s = self.contentText // and do something with it
        
        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
    }

    override func configurationItems() -> [AnyObject]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        let c = SLComposeSheetConfigurationItem()
        c.title = "Size"
        c.value = self.selectedText
        c.tapHandler = {
            [unowned self] in
            let tvc = TableViewController(style: .Grouped)
            tvc.selectedSize = self.selectedText
            tvc.delegate = self
            self.pushConfigurationViewController(tvc)
        }
        self.config = c
        return [c]
    }
    

}

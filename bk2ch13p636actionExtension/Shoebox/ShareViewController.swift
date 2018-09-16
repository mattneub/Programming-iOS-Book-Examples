

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController, SizeDelegate {
    
    weak var config : SLComposeSheetConfigurationItem?
    var selectedText = "Large" {
        didSet {
            self.config?.value = self.selectedText
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.navigationBar.topItem?
            .rightBarButtonItem?.title = "Save"
    }


    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
    
        let s = self.contentText // and do something with it
        
        self.extensionContext?.completeRequest(returningItems:nil)
        
        if let s = s {
            NSLog("post was: %@", s as NSObject)
        }
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        let c = SLComposeSheetConfigurationItem()!
        c.title = "Size"
        c.value = self.selectedText
        c.tapHandler = { [unowned self] in
            let tvc = TableViewController(style: .grouped)
            tvc.selectedSize = self.selectedText
            tvc.delegate = self
            self.pushConfigurationViewController(tvc)
        }
        self.config = c
        return [c]
    }
    

}

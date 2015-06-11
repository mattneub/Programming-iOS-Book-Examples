

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    
    let desiredType = kUTTypePlainText as String
    var voltage = "High"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.placeholder = "I electrocute you!"
    }
    
    override func configurationItems() -> [AnyObject]! {
        let config = SLComposeSheetConfigurationItem()
        config.title = "Voltage"
        config.value = self.voltage
        config.tapHandler = {
            [unowned self] in
//            // should be able to get rid of sself at this point
//            if let sself = self { // one, two, cha-cha-cha
                // I tried to give VoltageChooser an init override but this caused a crash
                // so we set the delegate separately instead
                let vc = VoltageChooser()
                vc.delegate = self
                self.pushConfigurationViewController(vc)
//            }
        }
        return [config]
    }
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        
        // I don't actually run an "Electrocute" server so we just return without networking :)
        self.extensionContext!.completeRequestReturningItems([AnyObject](), completionHandler: nil)
    }

    func userChose (s : String) {
        self.popConfigurationViewController() // proves we were called
        self.voltage = s
        self.reloadConfigurationItems()
    }

}

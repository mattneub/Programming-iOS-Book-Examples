

import UIKit
import MobileCoreServices
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var tf : UITextField!
    let desiredType = kUTTypePlainText as String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tf.allowsEditingTextAttributes = false
    }
    
    @IBAction func doShare(sender: AnyObject) {
        self.view.endEditing(true)
        delay(0.2) {
            self.showActivityView()
        }
    }
    
    func showActivityView() {
        let things = self.tf.text
        let avc = UIActivityViewController(activityItems:[things], applicationActivities:nil)
        avc.completionWithItemsHandler = {
            (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
            println("completed \(s) \(ok) \(items) \(err)")
            if ok {
                if items == nil || items.count == 0 {
                    return // nothing returned, nothing to do
                }
                // open the envelopes
                if let extensionItem = items[0] as? NSExtensionItem {
                    if let provider = extensionItem.attachments?[0] as? NSItemProvider {
                        if provider.hasItemConformingToTypeIdentifier(self.desiredType) {
                            provider.loadItemForTypeIdentifier(self.desiredType, options: nil, completionHandler: {
                                (item:NSSecureCoding!, err:NSError!) -> () in
                                dispatch_async(dispatch_get_main_queue()) {
                                    if let s = item as? String {
                                        self.tf.text = s
                                    }
                                }
                                }
                            )
                        }
                    }
                }
            }
        }
        avc.excludedActivityTypes = [
            UIActivityTypePostToFacebook,
            UIActivityTypePostToTwitter,
            UIActivityTypePostToWeibo,
            UIActivityTypeMessage,
            UIActivityTypeMail,
            UIActivityTypePrint,
            // UIActivityTypeCopyToPasteboard,
            UIActivityTypeAssignToContact,
            UIActivityTypeSaveToCameraRoll
        ]
        self.presentViewController(avc, animated:true, completion:nil)

    }
    
    
    
}

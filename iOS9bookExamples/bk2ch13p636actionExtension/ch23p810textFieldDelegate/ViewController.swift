

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
        let things = self.tf.text!
        let avc = UIActivityViewController(activityItems:[things], applicationActivities:nil)
        // just showing it can be done this way
        /*
        let p = NSItemProvider()
        p.registerItemForTypeIdentifier(desiredType) {
            completion, klass, d in
            completion(self.tf.text!, nil)
        }
        let avc = UIActivityViewController(activityItems:[p], applicationActivities:nil)
*/
        
        avc.completionWithItemsHandler = {
            (s: String?, ok: Bool, items: [AnyObject]?, err:NSError?) -> Void in
            print("completed \(s) \(ok) \(items) \(err)")
            if ok {
                guard let items = items where items.count > 0 else {
                    return
                }
                guard let extensionItem = items[0] as? NSExtensionItem,
                    let provider = extensionItem.attachments?[0] as? NSItemProvider
                    where provider.hasItemConformingToTypeIdentifier(self.desiredType)
                    else {
                        return
                }
                provider.loadItemForTypeIdentifier(self.desiredType, options: nil) {
                    (item:NSSecureCoding?, err:NSError!) -> () in
                    dispatch_async(dispatch_get_main_queue()) {
                        if let s = item as? String {
                            self.tf.text = s
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
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypeAddToReadingList,
            UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo,
            UIActivityTypePostToTencentWeibo,
            UIActivityTypeAirDrop,
            UIActivityTypeOpenInIBooks,
        ]
        self.presentViewController(avc, animated:true, completion:nil)

    }
    
    
    
}

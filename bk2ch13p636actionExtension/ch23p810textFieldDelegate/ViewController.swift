

import UIKit
import MobileCoreServices
func delay(_ delay:Double, closure:()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.after(when: when, execute: closure)
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var tf : UITextField!
    let desiredType = kUTTypePlainText as String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tf.allowsEditingTextAttributes = false
    }
    
    @IBAction func doShare(_ sender: AnyObject) {
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
                provider.loadItem(forTypeIdentifier: self.desiredType) {
                    (item:NSSecureCoding?, err:NSError!) -> () in
                    DispatchQueue.main.async {
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
        self.present(avc, animated:true)

    }
    
    
    
}

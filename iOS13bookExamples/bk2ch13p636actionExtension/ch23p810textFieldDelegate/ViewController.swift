

import UIKit
import MobileCoreServices
func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var tf : UITextField!
    let desiredType = kUTTypePlainText as String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tf.allowsEditingTextAttributes = false
    }
    
    @IBAction func doShare(_ sender: Any) {
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
        
        avc.completionWithItemsHandler = { type, ok, items, err in
            print("completed \(type as Any) \(ok) \(items as Any) \(err as Any)")
            if ok {
                guard let items = items, items.count > 0 else {
                    return
                }
                guard let extensionItem = items[0] as? NSExtensionItem else {return}
                guard let provider = extensionItem.attachments?.first else {return}
                guard provider.hasItemConformingToTypeIdentifier(self.desiredType) else {return}
                provider.loadItem(forTypeIdentifier: self.desiredType) { item, err in
                    DispatchQueue.main.async {
                        if let s = item as? String {
                            self.tf.text = s
                        }
                    }
                }
            }
        }
        avc.excludedActivityTypes = [
            .postToFacebook,
            .postToTwitter,
            .postToWeibo,
            .message,
            .mail,
            .print,
            // UIActivityTypeCopyToPasteboard,
            .assignToContact,
            .saveToCameraRoll,
            .addToReadingList,
            .postToFlickr,
            .postToVimeo,
            .postToTencentWeibo,
            .airDrop,
            .openInIBooks,
        ]
        self.present(avc, animated:true)

    }
    
    
    
}

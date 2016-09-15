
import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var lab: UILabel!
    
    let list : [String] = {
        let path = NSBundle.mainBundle().URLForResource("abbreviations", withExtension:"txt")!
        let s = try! String(contentsOfURL:path, encoding:NSUTF8StringEncoding)
        return s.componentsSeparatedByString("\n")
        }()
    
    let desiredType = kUTTypePlainText as String
    var orig : String?
    var expansion : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneButton.enabled = false
        self.lab.text = "No expansion available."
        if self.extensionContext == nil {
            return
        }
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
                if let orig = item as? String {
                    self.orig = orig
                    if let exp = self.stateForAbbrev(orig) {
                        self.expansion = exp
                        self.lab.text = "Can expand to \(exp)."
                        self.doneButton.enabled = true
                    }
                }
            }
        }
    }
    
    func stateForAbbrev(abbrev:String) -> String? {
        let ix = list.indexOf(abbrev.uppercaseString)
        return ix != nil ? list[ix!+1] : nil
    }
    
    func stuffThatEnvelope(item:String) -> [NSExtensionItem] {
        // everything has to get stuck back into the right sort of envelope
        let extensionItem = NSExtensionItem()
        let itemProvider = NSItemProvider(item: item, typeIdentifier: desiredType)
        extensionItem.attachments = [itemProvider]
        return [extensionItem]
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.extensionContext?.completeRequestReturningItems(
            nil, completionHandler: nil)
    }
    
    @IBAction func done(sender: AnyObject) {
        self.extensionContext?.completeRequestReturningItems(
            self.stuffThatEnvelope(self.expansion!), completionHandler: nil)
    }
    
}

extension ActionViewController : UIBarPositioningDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}

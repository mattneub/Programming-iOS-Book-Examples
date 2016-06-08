
import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var lab: UILabel!
    
    let list : [String] = {
        let path = NSBundle.main().urlForResource("abbreviations", withExtension:"txt")!
        let s = try! String(contentsOf:path, encoding:NSUTF8StringEncoding)
        return s.components(separatedBy:"\n")
        }()
    
    let desiredType = kUTTypePlainText as String
    var orig : String?
    var expansion : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneButton.isEnabled = false
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
        provider.loadItem(forTypeIdentifier: self.desiredType) {
            (item:NSSecureCoding?, err:NSError!) -> () in
            dispatch_async(dispatch_get_main_queue()) {
                if let orig = item as? String {
                    self.orig = orig
                    if let exp = self.state(forAbbrev:orig) {
                        self.expansion = exp
                        self.lab.text = "Can expand to \(exp)."
                        self.doneButton.isEnabled = true
                    }
                }
            }
        }
    }
    
    func state(forAbbrev abbrev:String) -> String? {
        let ix = list.index(of:abbrev.uppercased())
        return ix != nil ? list[ix!+1] : nil
    }
    
    func stuffThatEnvelope(_ item:String) -> [NSExtensionItem] {
        // everything has to get stuck back into the right sort of envelope
        let extensionItem = NSExtensionItem()
        let itemProvider = NSItemProvider(item: item, typeIdentifier: desiredType)
        extensionItem.attachments = [itemProvider]
        return [extensionItem]
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        self.extensionContext?.completeRequest(
            returningItems: nil)
    }
    
    @IBAction func done(_ sender: AnyObject) {
        self.extensionContext?.completeRequest(
            returningItems: self.stuffThatEnvelope(self.expansion!))
    }
    
}

extension ActionViewController : UIBarPositioningDelegate {
    func positionForBar(forBar bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

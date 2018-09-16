
import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var lab: UILabel!
    
    let list : [String:String] = {
        let path = Bundle.main.url(forResource:"abbreviations", withExtension:"txt")!
        let s = try! String(contentsOf:path)
        let arr = s.components(separatedBy:"\n")
        var result : [String:String] = [:]
        stride(from: 0, to: arr.count, by: 2).map{($0,$0+1)}.forEach {
            result[arr[$0.0]] = arr[$0.1]
        }
        return result
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
        guard let extensionItem = items[0] as? NSExtensionItem else {return}
        guard let provider = extensionItem.attachments?.first else {return}
        guard provider.hasItemConformingToTypeIdentifier(self.desiredType) else {return}
        provider.loadItem(forTypeIdentifier: desiredType) { item, err in
            DispatchQueue.main.async {
                if let orig = (item as? String)?.uppercased() {
                    self.orig = orig
                    if let exp = self.state(for:orig) {
                        self.expansion = exp
                        self.lab.text = """
                            Can expand \(orig) to \(exp).
                            Tap Done to place on clipboard.
                            """
                        self.doneButton.isEnabled = true
                    }
                }
            }
        }
    }
    
    func state(for abbrev:String) -> String? {
        return self.list[abbrev]
    }
    
    func stuffThatEnvelope(_ item:String) -> [NSExtensionItem] {
        // everything has to get stuck back into the right sort of envelope
        let extensionItem = NSExtensionItem()
        let itemProvider = NSItemProvider(item: item as NSString, typeIdentifier: desiredType)
        extensionItem.attachments = [itemProvider]
        return [extensionItem]
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.extensionContext?.completeRequest(returningItems: nil)
        // self.extensionContext?.completeRequest(returningItems: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        UIPasteboard.general.string = self.expansion! // legal and works
        self.extensionContext?.completeRequest(returningItems: nil)

        // self.extensionContext?.completeRequest(
        //    returningItems: self.stuffThatEnvelope(self.expansion!))
    }
    
    deinit {
        print("farewell from action view controller")
    }
    
}

extension ActionViewController : UIBarPositioningDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

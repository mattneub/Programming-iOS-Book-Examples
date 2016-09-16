
import UIKit
import MobileCoreServices


class ActionRequestHandler: NSObject, NSExtensionRequestHandling {
    
    let list : [String] = {
        let path = Bundle.main.url(forResource:"abbreviations", withExtension:"txt")!
        let s = try! String(contentsOf:path)
        return s.components(separatedBy:"\n")
        }()
    
    var extensionContext: NSExtensionContext?
    // NSObject has no magically acquired extension context, we must keep a reference
    
    let desiredType = kUTTypePlainText as String
    
    func beginRequest(with context: NSExtensionContext) {
        // Do not call super in an Action extension with no user interface
        self.extensionContext = context
        let items = self.extensionContext!.inputItems
        // open the envelopes
        guard let extensionItem = items[0] as? NSExtensionItem,
            let provider = extensionItem.attachments?[0] as? NSItemProvider,
            provider.hasItemConformingToTypeIdentifier(self.desiredType)
            else {
                return self.process(item:nil)
        }
        provider.loadItem(forTypeIdentifier: self.desiredType) {
            (item:NSSecureCoding?, err:Error!) -> () in
            DispatchQueue.main.async {
                self.process(item: item as? String)
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
        let itemProvider = NSItemProvider(item: item as NSString, typeIdentifier: desiredType)
        extensionItem.attachments = [itemProvider]
        return [extensionItem]
    }
    
    func process(item:String?) {
        var result : [NSExtensionItem]? = nil
        if let item = item,
            let abbrev = self.state(forAbbrev:item) {
                result = self.stuffThatEnvelope(abbrev)
        }
        self.extensionContext?.completeRequest(
            returningItems: result)
        self.extensionContext = nil
    }
    
}


import UIKit
import MobileCoreServices


class ActionRequestHandler: NSObject, NSExtensionRequestHandling {
    
    let list : [String] = {
        let path = NSBundle.mainBundle().URLForResource("abbreviations", withExtension:"txt")!
        let s = try! String(contentsOfURL:path, encoding:NSUTF8StringEncoding)
        return s.componentsSeparatedByString("\n")
        }()
    
    var extensionContext: NSExtensionContext?
    // NSObject has no magically acquired extension context, we must keep a reference
    
    let desiredType = kUTTypePlainText as String
    
    func beginRequestWithExtensionContext(context: NSExtensionContext) {
        // Do not call super in an Action extension with no user interface
        self.extensionContext = context
        let items = self.extensionContext!.inputItems
        // open the envelopes
        guard let extensionItem = items[0] as? NSExtensionItem,
            let provider = extensionItem.attachments?[0] as? NSItemProvider
            where provider.hasItemConformingToTypeIdentifier(self.desiredType)
            else {
                return self.processItem(nil)
        }
        provider.loadItemForTypeIdentifier(self.desiredType, options: nil) {
            (item:NSSecureCoding?, err:NSError!) -> () in
            dispatch_async(dispatch_get_main_queue()) {
                self.processItem(item as? String)
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
    
    func processItem(item:String?) {
        var result : [NSExtensionItem]? = nil
        if let item = item,
            let abbrev = self.stateForAbbrev(item) {
                result = self.stuffThatEnvelope(abbrev)
        }
        self.extensionContext?.completeRequestReturningItems(
            result, completionHandler: nil)
        self.extensionContext = nil
    }
    
}

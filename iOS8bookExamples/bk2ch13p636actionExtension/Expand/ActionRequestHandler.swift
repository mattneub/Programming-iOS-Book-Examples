
import UIKit
import MobileCoreServices


class ActionRequestHandler: NSObject /*, NSExtensionRequestHandling */ { // ???
    
    let list : [String] = {
        let path = NSBundle.mainBundle().URLForResource("abbreviations", withExtension:"txt")!
        let s = String(contentsOfURL:path, encoding:NSUTF8StringEncoding, error:nil)!
        return s.componentsSeparatedByString("\n")
        }()

    var extensionContext: NSExtensionContext?
    // NSObject has no magically acquired extension context, we must keep a reference
    
    let desiredType = kUTTypePlainText as String
    
    func beginRequestWithExtensionContext(context: NSExtensionContext!) {
        // Do not call super in an Action extension with no user interface
        self.extensionContext = context
        let items = self.extensionContext!.inputItems
        // open the envelopes
        if let extensionItem = items[0] as? NSExtensionItem {
            if let provider = extensionItem.attachments?[0] as? NSItemProvider {
                if provider.hasItemConformingToTypeIdentifier(self.desiredType) {
                    provider.loadItemForTypeIdentifier(self.desiredType, options: nil) {
                        (item:NSSecureCoding!, err:NSError!) -> () in
                            dispatch_async(dispatch_get_main_queue()) {
                                self.processItem(item as? String)
                            }
                    }
                    return
                }
            }
        }
        self.processItem(nil)
    }
    
    func stateForAbbrev(abbrev:String) -> String? {
        let ix = find(list, abbrev.uppercaseString)
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
        // we _must_ call completeRequestReturningItems one way or another!
        if (item == nil) {
            // didn't get anything to process, pass nil back to host
            self.extensionContext?.completeRequestReturningItems(
                nil, completionHandler: nil)
        } else {
            if let abbrev = self.stateForAbbrev(item!) {
                self.extensionContext?.completeRequestReturningItems(
                    self.stuffThatEnvelope(abbrev), completionHandler: nil)
            } else {
                self.extensionContext?.completeRequestReturningItems(
                    nil, completionHandler: nil)
            }
        }
        // the template tells us to release this when done
        self.extensionContext = nil
    }

}

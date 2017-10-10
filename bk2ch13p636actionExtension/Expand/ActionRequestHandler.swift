
import UIKit
import MobileCoreServices


class ActionRequestHandler: NSObject, NSExtensionRequestHandling {
    
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
            else { self.process(item:nil); return }
        provider.loadItem(forTypeIdentifier: self.desiredType) {
            item, err in
            DispatchQueue.main.async {
                self.process(item: item as? String)
            }
        }
    }
    
    func state(for abbrev:String) -> String? {
        return self.list[abbrev.uppercased()]
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
            let state = self.state(for:item) {
                result = self.stuffThatEnvelope(state)
        }
        self.extensionContext?.completeRequest(returningItems: result)
        self.extensionContext = nil
    }
    
}

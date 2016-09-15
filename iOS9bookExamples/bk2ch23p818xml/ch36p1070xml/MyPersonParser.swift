

import UIKit

class MyPersonParser : MyXMLParserDelegate {
    
    var person = Person(firstName: "", lastName: "")
    
    func parser(parser: NSXMLParser, didStartElement elementName: String,
        namespaceURI: String?, qualifiedName qName: String?,
        attributes attributeDict: [NSObject : AnyObject]) {
            self.makeChild(MyXMLParserDelegate.self, elementName: elementName, parser: parser)
    }
    
    override func finishedChild(s: String) {
        self.person.setValue(s, forKey:self.child.name)
    }
    
}

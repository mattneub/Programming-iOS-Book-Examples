

import UIKit

class MyPersonParser : MyXMLParserDelegate {
    
    var person : Person! = nil
    
    func parser(parser: NSXMLParser, didStartElement elementName: String!,
        namespaceURI: String!, qualifiedName qName: String!,
        attributes attributeDict: [NSObject : AnyObject]!) {
            self.makeChild(MyXMLParserDelegate.self, elementName: elementName, parser: parser)
    }
    
    func finishedChild(s: String) {
        if self.person == nil {
            self.person = Person(firstName: "", lastName: "")
        }
        self.person.setValue(s, forKey:self.child.name)
    }
    
}

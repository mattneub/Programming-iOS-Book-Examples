

import UIKit

class MyPersonParser : MyXMLParserDelegate {
    
    var person = Person(firstName: "", lastName: "")
    
    func parser(_ parser: XMLParser, didStartElement elementName: String,
        namespaceURI: String?, qualifiedName qName: String?,
        attributes attributeDict: [String : String]) {
            self.makeChild(MyXMLParserDelegate.self, elementName: elementName, parser: parser)
    }
    
    override func finishedChild(_ s: String) {
        self.person.setValue(s, forKey:self.child.name)
    }
    
}



import UIKit

class MyPeopleParser : MyXMLParserDelegate {
    
    var people = [Person]()
    
    func parser(_ parser: XMLParser, didStartElement elementName: String,
        namespaceURI: String?, qualifiedName qName: String?,
        attributes attributeDict: [String : String]) {
            if elementName == "person" {
                self.makeChild(MyPersonParser.self, elementName: elementName, parser: parser)
            }
    }
    override func finishedChild(_ s: String) {
        self.people.append((self.child as! MyPersonParser).person)
    }
    
}



import UIKit

class MyPeopleParser : MyXMLParserDelegate {
    
    var people = [Person]()
    
    func parser(parser: NSXMLParser, didStartElement elementName: String,
        namespaceURI: String?, qualifiedName qName: String?,
        attributes attributeDict: [NSObject : AnyObject]!) {
            if elementName == "person" {
                self.makeChild(MyPersonParser.self, elementName: elementName, parser: parser)
            }
    }
    override func finishedChild(s: String) {
        self.people.append((self.child as! MyPersonParser).person)
    }
    
}

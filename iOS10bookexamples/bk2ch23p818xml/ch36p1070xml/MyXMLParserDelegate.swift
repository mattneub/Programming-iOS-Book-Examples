

import UIKit


class MyXMLParserDelegate : NSObject {
    var name : String!
    var text = ""
    weak var parent : MyXMLParserDelegate?
    var child : MyXMLParserDelegate!
    
    required init(name:String, parent:MyXMLParserDelegate?) {
        self.name = name
        self.parent = parent
        super.init()
    }
    
    func makeChild(_ klass:MyXMLParserDelegate.Type, elementName:String, parser:XMLParser) {
        let del = klass.init(name:elementName, parent:self)
        self.child = del
        parser.delegate = del
    }
    func finishedChild(_ s:String) {
        fatalError("Subclass must implement finishedChild:!")
    }
    
}

extension MyXMLParserDelegate : XMLParserDelegate {
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.text = self.text + string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if self.parent != nil {
            self.parent!.finishedChild(self.text)
            parser.delegate = self.parent
        }
    }
    
}



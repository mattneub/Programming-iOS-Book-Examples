

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
    
    func makeChild(klass:MyXMLParserDelegate.Type, elementName:String, parser:NSXMLParser) {
        let del = klass.init(name:elementName, parent:self)
        self.child = del
        parser.delegate = del
    }
    func finishedChild(s:String) {
        fatalError("Subclass must implement finishedChild:!")
    }
    
}

extension MyXMLParserDelegate : NSXMLParserDelegate {
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        self.text = self.text + string
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if self.parent != nil {
            self.parent!.finishedChild(self.text)
            parser.delegate = self.parent
        }
    }
    
}



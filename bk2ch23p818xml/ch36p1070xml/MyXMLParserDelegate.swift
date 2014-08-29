

import UIKit

class MyXMLParserDelegate : NSObject, NSXMLParserDelegate {
    var text : String!
    var name : String!
    weak var parent : MyXMLParserDelegate?
    var child : MyXMLParserDelegate!
    
    required override init() {
        super.init()
    }
    
    func start(el:String, parent:MyXMLParserDelegate) {
        self.name = el
        self.parent = parent
        if self.text == nil {
            self.text = ""
        }
    }
    
    func makeChild(klass:MyXMLParserDelegate.Type, elementName:String, parser:NSXMLParser) {
        let del = klass()
        self.child = del
        parser.delegate = del
        del.start(elementName, parent:self)
    }
    
    func finishedChild(s:String) {} // subclass must implement as desired
    
    // NSXMLParser delegate messages
    
    func parser(parser: NSXMLParser, foundCharacters string: String!) {
        if self.text == nil {
            return
        }
        self.text = self.text + string
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        if self.parent != nil {
            self.parent!.finishedChild(self.text)
            parser.delegate = self.parent
        }
    }
    
}

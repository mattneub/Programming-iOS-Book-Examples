

import UIKit

// protocol as a way of declaring an abstract method to be inherited and implemented by subclasses
@objc protocol MyXMLParserDelegateProtocol {
    optional func finishedChild(s:String)
}

class MyXMLParserDelegate : NSObject, NSXMLParserDelegate, MyXMLParserDelegateProtocol {
    var text = ""
    var name : String!
    weak var parent : MyXMLParserDelegate?
    var child : MyXMLParserDelegate!
    
    required init(name:String!, parent:MyXMLParserDelegate!) {
        self.name = name
        self.parent = parent
        super.init()
    }
    
    func makeChild(klass:MyXMLParserDelegate.Type, elementName:String, parser:NSXMLParser) {
        let del = klass(name:elementName, parent:self)
        self.child = del
        parser.delegate = del
    }
    
    // func finishedChild(s:String) {} // subclass may implement as desired
    
    // NSXMLParser delegate messages
    
    func parser(parser: NSXMLParser, foundCharacters string: String!) {
        self.text = self.text + string
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        if self.parent != nil {
            // rather tricky syntax to allow calling optional method; bug in Swift?
            (self.parent! as MyXMLParserDelegateProtocol).finishedChild?(self.text)
            parser.delegate = self.parent
        }
    }
    
}

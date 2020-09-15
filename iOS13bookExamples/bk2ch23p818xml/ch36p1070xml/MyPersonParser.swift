

import UIKit

enum PersonStringPropertyMapper : String {
    case firstName
    case lastName
    var personProperty : ReferenceWritableKeyPath<Person,String> {
        switch self {
        case .firstName : return \Person.firstName
        case .lastName : return \Person.lastName
        }
    }
}

class MyPersonParser : MyXMLParserDelegate {
    
    var person = Person(firstName: "", lastName: "")
    
    func parser(_ parser: XMLParser, didStartElement elementName: String,
        namespaceURI: String?, qualifiedName qName: String?,
        attributes attributeDict: [String : String]) {
            self.makeChild(MyXMLParserDelegate.self, elementName: elementName, parser: parser)
    }
    
    override func finishedChild(_ s: String) {
        self.person.setValue(s, forKey:self.child.name)
        
        // I'd like to avoid using KVC, but I don't see how to go from a string...
        // ...to a Swift key path, without an explicit mapper
        // I guess I could do this...
        
//        let kp = PersonStringPropertyMapper(rawValue:self.child.name)!.personProperty
//        self.person[keyPath:kp] = s
        
        // but really, why can't we map a string to a property somehow?
        // there are times when that's really useful (like, right here)
    }
    
}

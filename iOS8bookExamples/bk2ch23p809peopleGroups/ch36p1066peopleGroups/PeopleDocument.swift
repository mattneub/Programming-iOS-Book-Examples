

import UIKit

class PeopleDocument: UIDocument {
    
    var people = [Person]()
    
    override func loadFromContents(contents: AnyObject,
        ofType typeName: String,
        error outError: NSErrorPointer) -> Bool {
            println("loading \(typeName)")
            if let contents = contents as? NSData {
                let arr = NSKeyedUnarchiver.unarchiveObjectWithData(contents) as! [Person]
                self.people = arr
                return true
            }
            return false
    }
    
    override func contentsForType(typeName: String,
        error outError: NSErrorPointer) -> AnyObject? {
            println("archiving \(typeName)")
            let data = NSKeyedArchiver.archivedDataWithRootObject(self.people)
            return data
    }
    
}

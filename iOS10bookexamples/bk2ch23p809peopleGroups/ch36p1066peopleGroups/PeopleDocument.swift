

import UIKit

class PeopleDocument: UIDocument {
    
    var people = [Person]()
    
    override func load(fromContents contents: Any,
        ofType typeName: String?) throws {
            print("loading \(typeName)")
            if let contents = contents as? Data {
                if let arr = NSKeyedUnarchiver.unarchiveObject(with: contents) as? [Person] {
                    self.people = arr
                    print("loaded \(self.people)")
                    return // all's well that ends well
                }
            }
            throw NSError(domain: "NoDataDomain", code: -1, userInfo: nil)
    }
    
    override func contents(forType typeName: String) throws -> Any {
        print("archiving \(typeName)")
        let data = NSKeyedArchiver.archivedData(withRootObject: self.people)
        return data
    }
    
}

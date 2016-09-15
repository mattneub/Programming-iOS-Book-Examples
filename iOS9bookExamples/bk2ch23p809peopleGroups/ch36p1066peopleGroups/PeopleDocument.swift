

import UIKit

class PeopleDocument: UIDocument {
    
    var people = [Person]()
    
    override func loadFromContents(contents: AnyObject,
        ofType typeName: String?) throws {
            print("loading \(typeName)")
            if let contents = contents as? NSData {
                if let arr = NSKeyedUnarchiver.unarchiveObjectWithData(contents) as? [Person] {
                    self.people = arr
                    print("loaded \(self.people)")
                    return // all's well that ends well
                }
            }
            throw NSError(domain: "NoDataDomain", code: -1, userInfo: nil)
    }
    
    override func contentsForType(typeName: String) throws -> AnyObject {
        print("archiving \(typeName)")
        let data = NSKeyedArchiver.archivedDataWithRootObject(self.people)
        return data
    }
    
}

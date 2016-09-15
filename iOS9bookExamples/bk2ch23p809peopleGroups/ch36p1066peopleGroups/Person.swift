

import UIKit

class Person: NSObject, NSCoding {
    var firstName : String
    var lastName : String
    
    override var description : String {
        return self.firstName + " " + self.lastName
    }
    
    init(firstName:String, lastName:String) {
        self.firstName = firstName
        self.lastName = lastName
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        // do not call super in this case
        coder.encodeObject(self.lastName, forKey: "last")
        coder.encodeObject(self.firstName, forKey: "first")
    }
    
    required init(coder: NSCoder) {
        self.lastName = coder.decodeObjectForKey("last") as! String
        self.firstName = coder.decodeObjectForKey("first") as! String
        // do not call super init(coder:) in this case
        super.init()
    }

}

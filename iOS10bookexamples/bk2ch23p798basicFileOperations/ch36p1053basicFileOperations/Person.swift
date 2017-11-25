

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
    
    func encode(with coder: NSCoder) {
        // do not call super in this case
        coder.encode(self.lastName, forKey: "last")
        coder.encode(self.firstName, forKey: "first")
    }
    
    required init(coder: NSCoder) {
        self.lastName = coder.decodeObject(forKey:"last") as! String
        self.firstName = coder.decodeObject(forKey:"first") as! String
        // do not call super init(coder:) in this case
        super.init()
    }

}

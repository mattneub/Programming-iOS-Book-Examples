

import UIKit

class Person: NSObject, NSCoding {
    @NSCopying var firstName : NSString
    @NSCopying var lastName : NSString
    
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
        self.lastName = coder.decodeObjectForKey("last")! as NSString
        self.firstName = coder.decodeObjectForKey("first")! as NSString
        // do not call super init(coder:) in this case
        super.init()
    }

}

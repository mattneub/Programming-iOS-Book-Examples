

import UIKit

class Person: NSObject {
    // we're going to use KVC
    @objc var firstName : String
    @objc var lastName : String
    
    override var description : String {
        return self.firstName + " " + self.lastName
    }
    
    init(firstName:String, lastName:String) {
        self.firstName = firstName
        self.lastName = lastName
        super.init()
    }
    
}


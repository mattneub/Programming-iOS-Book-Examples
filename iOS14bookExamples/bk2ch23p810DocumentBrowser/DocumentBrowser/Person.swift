

import UIKit

class Person: NSObject, Codable {
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
    
}


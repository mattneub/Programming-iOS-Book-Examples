

import UIKit

// adopt secure coding for iOS 12

class Person: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool { return true }
    
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
        self.lastName = coder.decodeObject(of: NSString.self, forKey:"last")! as String
        self.firstName = coder.decodeObject(of: NSString.self, forKey:"first")! as String
        // do not call super init(coder:) in this case
        super.init()
    }
}

// but in Swift 4 we are more likely to do it this way

class Person2: NSObject, Codable {
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


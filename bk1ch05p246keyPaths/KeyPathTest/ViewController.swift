

import UIKit

struct Person {
    var firstName : String
    var lastName : String
}

class Person2 {
    var firstName : String = "Matt"
    var lastName : String = "Neuburg"
}

// ? So why do the examples mark the property as objc? Works fine without
// It must because they also want to use Objective-C KVC, which is a different animal

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        do {
            var p = Person(firstName:"Matt", lastName:"Neuburg")
            
            var getFirstName : Bool { return true }
            
            let name : String = {
                if getFirstName {
                    return p.firstName
                } else {
                    return p.lastName
                }
            }()
            print(name)
            
            var prop = \Person.firstName
            let proplet = prop // work around segfault
            
            let whatname = p[keyPath:proplet] // segfault here if path is a var
            print(whatname)
            
            prop = \Person.lastName
            let proplet2 = prop

            let whatname2 = p[keyPath:proplet2]
            print(whatname2)
            
            let newprop = prop.appending(path: \.utf8)
            _ = newprop

            p[keyPath:proplet] = "Amy"
            print(p)
        }
        
        do {
            let p = Person2()
            
            let prop = \Person2.firstName
            let proplet = prop // work around segfault

            let whatname = p[keyPath:proplet]
            print(whatname)

        }
        

        
        
        
        
        
    }



}


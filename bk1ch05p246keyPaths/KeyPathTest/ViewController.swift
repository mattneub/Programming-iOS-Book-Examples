

import UIKit

struct Person {
    var firstName : String
    var lastName : String
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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



}


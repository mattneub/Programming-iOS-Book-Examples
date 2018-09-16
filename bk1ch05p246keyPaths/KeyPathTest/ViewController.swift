

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
            
            let whatname = p[keyPath:prop]
            print(whatname)
            
            prop = \Person.lastName
            
            // no, don't be silly
            // prop = \Person2.lastName

            let whatname2 = p[keyPath:prop]
            print(whatname2)
            
            let newprop = prop.appending(path: \.utf8)
            _ = newprop

            p[keyPath:prop] = "Amy"
            print(p)
        }
        
        do {
            let p = Person2()
            
            let prop = \Person2.firstName

            let whatname = p[keyPath:prop]
            print(whatname)

        }
        
        // another example, a bit more vivid perhaps
        
        
        let v1 = self.view!
        v1.backgroundColor = .red
        let v2 = UIView(frame:.zero)
        v2.backgroundColor = .green
        v2.translatesAutoresizingMaskIntoConstraints = false
        v1.addSubview(v2)
        
        var which : Int { return 0 }
        switch which {
        case 0:
            let c1 = v2.topAnchor.constraint(equalTo:v1.topAnchor)
            c1.isActive = true
            let c2 = v2.bottomAnchor.constraint(equalTo:v1.bottomAnchor)
            c2.isActive = true
            let c3 = v2.leadingAnchor.constraint(equalTo:v1.leadingAnchor)
            c3.isActive = true
            let c4 = v2.trailingAnchor.constraint(equalTo:v1.trailingAnchor)
            c4.isActive = true
        case 1:
            // failed experiments
//            let kp : KeyPath<Any,Any> = \UIView.topAnchor
//            let arr : [KeyPath<UIView,Any>] = [
//                \UIView.topAnchor
//            ]
            let arr : [PartialKeyPath<UIView>] = [
                \UIView.topAnchor, \UIView.bottomAnchor,
                \UIView.leadingAnchor, \UIView.trailingAnchor
            ]
            for anch in arr {
                print(type(of:anch).valueType)
            }
            // but I think the experiment is doomed to failure because of the odd way
            // in which anchor types relate
            for anch in [\UIView.topAnchor, \UIView.bottomAnchor] {
                let c = v2[keyPath:anch].constraint(equalTo:v1[keyPath:anch])
                c.isActive = true
            }
            for anch in [\UIView.leadingAnchor, \UIView.trailingAnchor] {
                let c = v2[keyPath:anch].constraint(equalTo:v1[keyPath:anch])
                c.isActive = true
            }
        default: break
        }
                

        
        
        
        
        
    }



}




import UIKit

@dynamicMemberLookup
@dynamicCallable
class Flock {
    var d = [String:String]()
    subscript(dynamicMember s:String) -> String? {
        get { d[s] }
        set { d[s] = newValue }
    }
    func dynamicallyCall(withArguments args: [String]) {}
    func dynamicallyCall(withKeywordArguments kvs:KeyValuePairs<String, String>) {
        if kvs.count == 1 {
            if let (key,val) = kvs.first {
                if key == "remove" {
                    d[val] = nil
                }
            }
        }
    }
}



@dynamicMemberLookup
@objc protocol BetterNames { }
extension BetterNames where Self : UIView {
    subscript(dynamicMember s:String) -> Bool {
        set {
            if s == "translates" {
                self.translatesAutoresizingMaskIntoConstraints = newValue
            }
        }
        get {
            guard s == "translates" else { fatalError("no such property") }
            return self.translatesAutoresizingMaskIntoConstraints
        }
    }
}
extension UIView : BetterNames { }

// of course if that's _all_ I wanted to do, I could just write an extension
extension UIView {
    var trans : Bool {
        get {
            return self.translatesAutoresizingMaskIntoConstraints
        }
        set {
            self.translatesAutoresizingMaskIntoConstraints = newValue
        }
    }
}

struct Dog {
    let name : String
    func bark() { print("woof") }
}
@dynamicMemberLookup
struct Kennel {
    let dog : Dog
    subscript(dynamicMember kp:KeyPath<Dog,String>) -> String {
        self.dog[keyPath:kp]
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let flock = Flock()
        flock.chicken = "peep"
        flock.partridge = "covey"
        print(flock.d)
        if let s = flock.partridge {
            print(s) // covey
        }
        flock(remove:"partridge")
        flock(hello:"there")
        flock(remove:"partridge", "in a pear tree")
        print(flock.partridge as Any)
        print(flock.d)
        flock("hello")
        print(flock.d)
        
        let v = UIView()
        
        
        v.translates = false
        print(v.translates) // false
        v.testing = false // fails harmlessly
        // print(v.testing) // crashes deliberately
        
        v.trans = false
        print(v.trans)
        v.trans = true
        print(v.trans)
        
        let k = Kennel(dog: Dog(name:"Fido"))
        let name = k.name
        print(name)
        // let name2 = k.wigglywoggly // doesn't compile
    }


}


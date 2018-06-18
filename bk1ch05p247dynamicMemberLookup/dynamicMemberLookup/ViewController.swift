

import UIKit

@dynamicMemberLookup
struct Flock {
    var d = [String:String]()
    subscript(dynamicMember s:String) -> String? {
        get {
            return d[s]
        }
        set {
            d[s] = newValue
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



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var flock = Flock()
        flock.chicken = "peep"
        flock.partridge = "covey"
        if let s = flock.partridge {
            print(s) // covey
        }

        
        let v = UIView()
        
        
        v.translates = false
        print(v.translates) // false
        v.testing = false // fails harmlessly
        // print(v.testing) // crashes deliberately
        
        v.trans = false
        print(v.trans)
        v.trans = true
        print(v.trans)
    }


}


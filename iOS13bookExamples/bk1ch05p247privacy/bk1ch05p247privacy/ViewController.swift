

import UIKit

//extension CGAffineTransform : CustomStringConvertible {
//    public var description : String {
//        return NSStringFromCGAffineTransform(self)
//    }
//}

struct Dog2 : CustomStringConvertible {
    var name = "Fido"
    var license = 1
    var description : String {
        var desc = "Dog ("
        let mirror = Mirror(reflecting:self)
        for (k,v) in mirror.children {
            desc.append("\(k!): \(v), ")
        }
        return desc.dropLast(2) + ")"
    }
}

struct Dog3 : CustomReflectable {
    var name = "Fido"
    var license = 1
    var customMirror : Mirror { // now a var instead of a func
        let children : [Mirror.Child] = [
            ("ineffable name", self.name),
            ("license to kill", self.license)
        ]
        let m = Mirror(self, children:children)
        return m
    }
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let d = Dog()
        let _ = d.name // legal, it's visible from another file
        // let _ = d.whatADogSays // compile error, it's private
        d.bark()
        print(d)
        
        let d2 = Dog2()
        // testing difference circumstances under which we might see our custom output
        print("\(d2)")
        print(d2)
        debugPrint(d2)
        debugPrint("\(d2)")
        
        dump(Dog3())
        
        // just making sure the initializer visibility bug is fixed
        let _ = Cat()
        let _ = Cat2()

    }

}


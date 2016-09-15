

import UIKit

extension CGAffineTransform : CustomStringConvertible {
    public var description : String {
        return NSStringFromCGAffineTransform(self)
    }
}

struct Dog2 : CustomStringConvertible {
    var name = "Fido"
    var license = 1
    var description : String {
        var desc = "Dog ("
        let mirror = Mirror(reflecting:self)
        for (k,v) in mirror.children {
            desc.appendContentsOf("\(k!): \(v), ")
        }
        let c = desc.characters.count
        return String(desc.characters.prefix(c-2)) + ")"
    }
}

struct Dog3 : CustomReflectable {
    var name = "Fido"
    var license = 1
    func customMirror() -> Mirror {
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
        
        let d3 = Dog3()
        print(d3) // breakpoint this line and `po d3` to see our custom property names

        // just making sure the initializer visibility bug is fixed
        let _ = Cat()
        let _ = Cat2()

    }

}




import UIKit

extension CGAffineTransform : Printable {
    public var description : String {
        return NSStringFromCGAffineTransform(self)
    }
}

struct Dog2 : Printable {
    var name = "Fido"
    var license = 1
    var description : String {
        var desc = "Dog:\n"
        var properties = reflect(self)
        for ix in 0 ..< properties.count {
            let (s,m) = properties[ix]
            desc.extend(s); desc.extend(" : ")
            desc.extend(m.summary); desc.extend("\n")
        }
        return desc
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let d = Dog()
        let n = d.name
        // let b = d.whatADogSays // compile error, it's private
        d.bark()
        
        let d2 = Dog2()
        println(d2)

    }

}


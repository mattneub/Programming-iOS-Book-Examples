

import UIKit
import MyCoolFramework

extension UIButton {
    func setTitle(_ title: String?, for state: UIControl.State) {
        // super.setTitle(title, for:state)
        // can't say that, because UIButton is not `super`; UIControl is
    }
}

extension MyClass {
    func test() { // no "override"
        print("my extension test")
    }
    func test2() {
        print("my extension test2")
    }
}

/*
class MySubclass : MyClass {
    override func test() { // overriding non-@objc declarations from extension not supported
        print("my subclass test")
    }
}
 */

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let c = MyClass()
        c.test() // extension test2
        c.test2() // extension test3
        
        let b = UIButton()
        b.setTitle("hey", for: .normal)
        print(b.title(for:.normal) as Any) // nil
    }
}


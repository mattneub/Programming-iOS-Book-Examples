

import UIKit
import MyCoolFramework

extension UIButton {
    // the fact that this is allowed is somewhat horrifying
    func setTitle(_ title: String?, for state: UIControl.State) {
        // super.setTitle(title, for:state)
        // can't say that, because UIButton is not `super`; UIControl is
        print("kilroy was here")
    }
}

extension MyClass {
    func test() { // no "override"
        print("my extension test")
    }
    func test2() {
        print("my extension test2")
    }
    @objc func test3() {
        print("my extension test3")
    }
}

class MySubclass : MyClass {
//    override func test() { // Non-@objc instance method is declared in extension and cannot be overridden
//        print("my subclass test")
//    }
    override func test3() {
        print("my subclass test3")
    }
}

class Dog {
    func test() {}
    @objc func test2() {}
    @objc dynamic func test3() {}
}
extension Dog {
    func test4() {}
    @objc func test5() {}
}
class NoisyDog : Dog {
    // func test4() {} // Non-@objc instance method is declared in extension and cannot be overridden
    override func test5() {} // ok
}
extension NoisyDog {
    // override func test() {} // Non-@objc instance method is declared in extension and cannot be overridden
    // override func test2() {} // Cannot override a non-dynamic class declaration from an extension
    override func test3() {} // ok
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let c = MyClass()
        c.test() // extension test2
        c.test2() // extension test3
        
        let b = UIButton()
        b.setTitle("hey", for: .normal) // kilroy was here
        print(b.title(for:.normal) as Any) // nil
    }
}




import UIKit

class MyClass : NSObject {
}
class MyClass2 : NSObject {
    func woohoo() {
        print("woohoo")
    }
}
class MyOtherClass {
    @objc func woohoo() {}
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ignore warnings (new in Swift 2.2)
        
        let mc = MyClass()
        if mc.respondsToSelector(Selector("woohoo")) {
            print("here1")
            (mc as AnyObject).woohoo()
        }
        let mc2 = MyClass2()
        if mc2.respondsToSelector(Selector("woohoo")) {
            print("here2")
            (mc2 as AnyObject).woohoo()
        }
        (mc as AnyObject).woohoo?()
        (mc2 as AnyObject).woohoo?()



    }


}


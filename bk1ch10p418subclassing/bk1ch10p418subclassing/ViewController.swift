

import UIKit

class MyClass : NSObject {
}
class MyClass2 : NSObject {
    @objc func woohoo() {
        print("woohoo")
    }
}
@objc protocol Dummy {
    func woohoo()
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let mc = MyClass()
        if mc.responds(to: #selector(Dummy.woohoo)) {
            print("here1")
            (mc as AnyObject).woohoo()
        }
        let mc2 = MyClass2()
        if mc2.responds(to: #selector(Dummy.woohoo)) {
            print("here2")
            (mc2 as AnyObject).woohoo()
        }
        (mc as AnyObject).woohoo?()
        (mc2 as AnyObject).woohoo?()



    }


}


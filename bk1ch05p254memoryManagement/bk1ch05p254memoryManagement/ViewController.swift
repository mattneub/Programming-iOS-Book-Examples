

import UIKit
import WebKit

class HelpViewController: UIViewController {
    weak var wv : UIWebView?
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let wv = UIWebView(frame:self.view.bounds)
        // ... further configuration of wv here ...
        self.view.addSubview(wv)
        self.wv = wv
    }
    // ...
}

class MyDropBounceAndRollBehavior : UIDynamicBehavior {
    let v : UIView
    init(view v:UIView) {
        self.v = v
        super.init()
    }
    override func willMoveToAnimator(anim: UIDynamicAnimator!) {
        if anim == nil { return }
        let sup = self.v.superview!
        let grav = UIGravityBehavior()
        grav.action = {
            [unowned self] in
            let items = anim.itemsInRect(sup.bounds) as! [UIView]
            if items.indexOf(self.v) == nil {
                anim.removeBehavior(self)
                self.v.removeFromSuperview()
            }
        }
        self.addChildBehavior(grav)
        grav.addItem(self.v)
        // ...
    }
    // ...
}

class SecondViewController : UIViewController {
    weak var delegate : SecondViewControllerDelegate?
    // ...
}
protocol SecondViewControllerDelegate : class {
    func acceptData(data:AnyObject!)
}




class ViewController: UIViewController {
    
    weak var delegate : WKScriptMessageHandler?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            print(1)
            func testRetainCycle() {
                class Dog {
                    deinit {
                        print("farewell from Dog")
                    }
                }
                class Cat {
                    deinit {
                        print("farewell from Cat")
                    }
                }
                let d = Dog()
                let c = Cat()
                
                _ = d
                _ = c
            }
            testRetainCycle() // farewell from Cat, farewell from Dog
        }
        
        do {
            print(2)
            func testRetainCycle() {
                class Dog {
                    var cat : Cat?
                    deinit {
                        print("farewell from Dog")
                    }
                }
                class Cat {
                    var dog : Dog?
                    deinit {
                        print("farewell from Cat")
                    }
                }
                let d = Dog()
                let c = Cat()
                d.cat = c // create a...
                c.dog = d // ...retain cycle
            }
            testRetainCycle() // nothing in console
        }
        
        do {
            print(3)
            func testRetainCycle() {
                class Dog {
                    weak var cat : Cat?
                    deinit {
                        print("farewell from Dog")
                    }
                }
                class Cat {
                    weak var dog : Dog?
                    deinit {
                        print("farewell from Cat")
                    }
                }
                let d = Dog()
                let c = Cat()
                d.cat = c
                c.dog = d
            }
            testRetainCycle() // farewell from Cat, farewell from Dog
        }
        
        do {
            print(4)
            func testUnowned() {
                class Boy {
                    var dog : Dog?
                    deinit {
                        print("farewell from Boy")
                    }
                }
                class Dog {
                    let boy : Boy
                    init(boy:Boy) { self.boy = boy }
                    deinit {
                        print("farewell from Dog")
                    }
                }
                let b = Boy()
                let d = Dog(boy: b)
                b.dog = d
            }
            testUnowned() // nothing in console
        }
        
        do {
            print(5)
            func testUnowned() {
                class Boy {
                    var dog : Dog?
                    deinit {
                        print("farewell from Boy")
                    }
                }
                class Dog {
                    unowned let boy : Boy // *
                    init(boy:Boy) { self.boy = boy }
                    deinit {
                        print("farewell from Dog")
                    }
                }
                let b = Boy()
                let d = Dog(boy: b)
                b.dog = d
                return // uncomment me to test crashing
                var b2 = Optional(Boy())
                let d2 = Dog(boy: b2!)
                b2 = nil // destroy the Boy behind the Dog's back
                print(d2.boy) // crash

            }
            testUnowned() // farewell from Boy, farewell from Dog
        }
        
        do {
            print(6)
            class FunctionHolder {
                var function : (Void -> Void)?
                deinit {
                    print("farewell from FunctionHolder")
                }
            }
            func testFunctionHolder() {
                let f = FunctionHolder()
                f.function = {
                    print(f)
                }
            }
            testFunctionHolder() // nothing in console
        }
        
        do {
            print(7)
            class FunctionHolder {
                var function : (Void -> Void)?
                deinit {
                    print("farewell from FunctionHolder")
                }
            }
            func testFunctionHolder() {
                let f = FunctionHolder()
                f.function = {
                    [weak f] in
                    print(f)
                }
                f.function!() // proving that what's printed is Optional
            }
            testFunctionHolder() // farewell from FunctionHolder
        }
        
        do {
            print(8)
            class FunctionHolder {
                var function : (Void -> Void)?
                deinit {
                    print("farewell from FunctionHolder")
                }
            }
            func testFunctionHolder() {
                let f = FunctionHolder()
                f.function = {      // here comes the weak–strong dance
                    [weak f] in     // weak
                    guard let f = f else { return }
                    print(f)        // strong
                }
                f.function!() // proving that what's printed is non-Optional
            }
            testFunctionHolder() // farewell from FunctionHolder
        }
        
    }



}




import UIKit
import WebKit

class HelpViewController: UIViewController {
    weak var wv : UIWebView? = nil
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
            if find(items, self.v) == nil {
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
        
        if true {
            println(1)
            func testRetainCycle() {
                class Dog {
                    deinit {
                        println("farewell from Dog")
                    }
                }
                class Cat {
                    deinit {
                        println("farewell from Cat")
                    }
                }
                let d = Dog()
                let c = Cat()
            }
            testRetainCycle() // farewell from Cat, farewell from Dog
        }
        
        if true {
            println(2)
            func testRetainCycle() {
                class Dog {
                    var cat : Cat? = nil
                    deinit {
                        println("farewell from Dog")
                    }
                }
                class Cat {
                    var dog : Dog? = nil
                    deinit {
                        println("farewell from Cat")
                    }
                }
                let d = Dog()
                let c = Cat()
                d.cat = c // create a...
                c.dog = d // ...retain cycle
            }
            testRetainCycle() // nothing in console
        }
        
        if true {
            println(3)
            func testRetainCycle() {
                class Dog {
                    weak var cat : Cat? = nil
                    deinit {
                        println("farewell from Dog")
                    }
                }
                class Cat {
                    weak var dog : Dog? = nil
                    deinit {
                        println("farewell from Cat")
                    }
                }
                let d = Dog()
                let c = Cat()
                d.cat = c
                c.dog = d
            }
            testRetainCycle() // farewell from Cat, farewell from Dog
        }
        
        if true {
            println(4)
            func testUnowned() {
                class Boy {
                    var dog : Dog? = nil
                    deinit {
                        println("farewell from Boy")
                    }
                }
                class Dog {
                    let boy : Boy
                    init(boy:Boy) { self.boy = boy }
                    deinit {
                        println("farewell from Dog")
                    }
                }
                let b = Boy()
                let d = Dog(boy: b)
                b.dog = d
            }
            testUnowned() // nothing in console
        }
        
        if true {
            println(5)
            func testUnowned() {
                class Boy {
                    var dog : Dog? = nil
                    deinit {
                        println("farewell from Boy")
                    }
                }
                class Dog {
                    unowned let boy : Boy // *
                    init(boy:Boy) { self.boy = boy }
                    deinit {
                        println("farewell from Dog")
                    }
                }
                let b = Boy()
                let d = Dog(boy: b)
                b.dog = d
                return // uncomment me to test crashing
                var b2 = Optional(Boy())
                let d2 = Dog(boy: b2!)
                b2 = nil // destroy the Boy behind the Dog's back
                println(d2.boy) // crash

            }
            testUnowned() // farewell from Boy, farewell from Dog
        }
        
        if true {
            println(6)
            class FunctionHolder {
                var function : (Void -> Void)? = nil
                deinit {
                    println("farewell from FunctionHolder")
                }
            }
            func testFunctionHolder() {
                let f = FunctionHolder()
                f.function = {
                    println(f)
                }
            }
            testFunctionHolder() // nothing in console
        }
        
        if true {
            println(7)
            class FunctionHolder {
                var function : (Void -> Void)? = nil
                deinit {
                    println("farewell from FunctionHolder")
                }
            }
            func testFunctionHolder() {
                let f = FunctionHolder()
                f.function = {
                    [weak f] in
                    println(f)
                }
            }
            testFunctionHolder() // farewell from FunctionHolder
        }
        
        if true {
            println(8)
            class FunctionHolder {
                var function : (Void -> Void)? = nil
                deinit {
                    println("farewell from FunctionHolder")
                }
            }
            func testFunctionHolder() {
                let f = FunctionHolder()
                f.function = {      // here comes the weak–strong dance
                    [weak f] in     // weak
                    if let f = f {  // strong
                        println(f)
                    }
                }
            }
            testFunctionHolder() // farewell from FunctionHolder
        }
        
    }



}


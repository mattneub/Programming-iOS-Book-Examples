
import UIKit

class Dog {
    func bark() {
        println("woof")
    }
    func speak() {
        self.bark()
    }
}
class NoisyDog : Dog {
    override func bark() {
        super.bark(); super.bark()
    }
    func beQuiet() {
        self.bark()
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if true {
            func tellToBark(d:Dog) {
                d.bark()
            }
            var d : Dog
            d = NoisyDog()
            tellToBark(d) // woof woof
            let d2 : NoisyDog = NoisyDog()
            tellToBark(d2) // woof woof
        }

        if true {
            let d : NoisyDog = NoisyDog()
            d.speak() // woof woof
            let d2 : Dog = NoisyDog()
            d2.speak() // woof woof
        }
        
        if true {
            func tellToHush(d:Dog) {
                // d.beQuiet() // compile error
                (d as! NoisyDog).beQuiet()
                // or:
                let d2 = d as! NoisyDog
                d2.beQuiet()
                d2.beQuiet()
            }
            let d: NoisyDog = NoisyDog()
            tellToHush(d)
        }
        
        if true {
            func tellToHush(d:Dog) {
                // (d as! NoisyDog).beQuiet() // compiles, but prepare to crash...!
                if d is NoisyDog {
                    let d2 = d as! NoisyDog
                    d2.beQuiet()
                }
                let noisyMaybe = d as? NoisyDog // an Optional wrapping a NoisyDog
                if noisyMaybe != nil {
                    noisyMaybe!.beQuiet()
                }
                (d as? NoisyDog)?.beQuiet()

            }
            let d: Dog = Dog()
            tellToHush(d)
        }
        
        if true {
            let d : Dog? = NoisyDog()
            if d is NoisyDog { println("yep") }
        }
        
        if true {
            let d : Dog? = NoisyDog()
            let d2 = d as! NoisyDog
            d2.beQuiet()
        }
        
        if true {
            let d : Dog? = NoisyDog()
            let d2 = d as? NoisyDog
            d2?.beQuiet()
        }
        
        if true {
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setObject(1, forKey: "Test")
            let i = ud.objectForKey("Test") as! Int
        }

    }

}



import UIKit

class Dog {
    func bark() {
        print("woof")
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

        do {
            func tellToBark(_ d:Dog) {
                d.bark()
            }
            var d : Dog
            d = NoisyDog()
            tellToBark(d) // woof woof
            let nd : NoisyDog = NoisyDog()
            tellToBark(nd) // woof woof
        }

        do {
            let nd : NoisyDog = NoisyDog()
            nd.speak() // woof woof
            let d : Dog = NoisyDog()
            d.speak() // woof woof
        }
        
        do {
            func tellToHush(_ d:Dog) {
                // d.beQuiet() // compile error
                (d as! NoisyDog).beQuiet()
                // or:
                let d2 = d as! NoisyDog
                d2.beQuiet()
                d2.beQuiet()
            }
            let nd: NoisyDog = NoisyDog()
            tellToHush(nd)
        }
        
        do {
            func tellToHush(_ d:Dog) {
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
        
        do {
            func tellToHush(_ d:Dog) {
                (d as! NoisyDog).beQuiet()
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
            let d: Dog = NoisyDog()
            tellToHush(d)
        }

        
        do {
            let d : Dog? = NoisyDog()
            if d is NoisyDog { print("yep") }
        }
        
        do {
            let d : Dog? = NoisyDog()
            let d2 = d as! NoisyDog
            d2.beQuiet()
        }
        
        do {
            let d : Dog? = NoisyDog()
            let d2 = d as? NoisyDog
            d2?.beQuiet()
        }
        
        do {
            // my old example here no longer works, because renamification has cut me off...
            // ... from being able to call setObject:forKey: with a number
            let ud = NSUserDefaults.standard()
            let iii = 1
            let ii : NSNumber = iii as NSNumber // explicit "as" now required
            ud.set(ii, forKey: "Test")
            let i = ud.object(forKey: "Test") as! Int
            _ = i
            let s : NSString = "howdy" // so why isn't it required here???
            // maybe it will be, but not now?
            _ = s
        }
        
        do {
            let ud = NSUserDefaults.standard()
            ud.set("howdy", forKey:"Test")
            let test = ud.object(forKey:"Test") as! String
            print(test)
        }
        
        do {
            var d : Dog?
            d = Dog()
            d = NoisyDog()
            d = Optional(NoisyDog())
            _ = d
        }
        
        let y = 0 as CGFloat // I didn't realize this sort of literal numeric cast was legal
        _ = y

    }

}



import UIKit
import Swift

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
        for _ in 1...3 {
            super.bark()
        }
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
            tellToBark(d) // woof woof woof
            let nd : NoisyDog = NoisyDog()
            tellToBark(nd) // woof woof woof
        }

        do {
            let nd : NoisyDog = NoisyDog()
            nd.speak() // woof woof woof
            let d : Dog = NoisyDog()
            d.speak() // woof woof woof
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
            let ud = UserDefaults.standard
            let iii = 1
            let ii : NSNumber = iii as NSNumber // explicit "as" now required // no it isn't // yes it is, I wish they would make up their minds
            ud.set(ii, forKey: "Test")
            ud.set(iii, forKey: "Test") // this is legal because this is now Any
            let i = ud.object(forKey: "Test") as! Int
            _ = i
            let s : NSString = "howdy" // so why isn't it required here???
            // maybe it will be, but not now?
            _ = s
        }
        
        do {
            // wait, maybe that was because it's a literal;
            // what if it's a variable?
            let s = "howdy"
            let s2 : NSString = s as NSString // yes, must say "as NSString"
            let any : Any = s
            _ = (s2, any)
        }
        
        do {
            let ud = UserDefaults.standard
            ud.set("howdy", forKey:"greeting")
            let test = ud.object(forKey:"greeting") as! String
            print(test)
            let test2 = ud.object(forKey:"greeting") as AnyObject // no forced cast needed
            let test3 = test2 as! String
            _ = test3
        }
        
        do {
            let ud = UserDefaults.standard
            ud.set(Date(), forKey:"now")
            // let d = ud.object(forKey:"now") as! Date
            let d = ud.object(forKey:"now")
            if d is Date {
                let d = d as! Date
                print(d)
            }
        }
        
        do {
            let s = "howdy"
            let any : Any = s
            print(type(of:any)) // merely casting / typing as Any does nothing
            let anyo = any as AnyObject
            print(type(of:anyo)) // but casting to AnyObject crosses the bridge
            
            let r = CGRect.zero
            let any2 : Any = r
            print(type(of:any2)) // merely casting / typing as Any does nothing
            let anyo2 = any2 as AnyObject
            print(type(of:anyo2)) // but casting to AnyObject crosses the bridge

        }
        
        do {
            NotificationCenter.default.addObserver(forName: Notification.Name("test"), object: nil, queue: nil) { n in
                print(type(of:n.object!)) // here, it will have crossed the bridge
            }
            let n1 = Notification(name: Notification.Name("test"), object: CGRect.zero, userInfo: nil)
            print(type(of:n1.object!)) // CGRect; it hasn't crossed the bridge yet
            let n2 = Notification(name: Notification.Name("test"), object: Dog(), userInfo:nil)
            print(type(of:n2.object!))
            let n3 = Notification(name: Notification.Name("test"), object: 1, userInfo:nil)
            print(type(of:n3.object!))
            let n4 = Notification(name: Notification.Name("test"), object: [CGRect.zero], userInfo:nil)
            print(type(of:n4.object!))

            
            
            NotificationCenter.default.post(n1)
            NotificationCenter.default.post(n2)
            NotificationCenter.default.post(n3)
            NotificationCenter.default.post(n4)
            
        }
        
        do {
            // what about AnyObject?
            let s = "howdy"
            let any1 : AnyObject = s as AnyObject // must cast
            print(type(of:any1)) // some special bridging type
            let i = 1
            let any2 : AnyObject = i as AnyObject // must cast
            print(type(of:any2)) // some special bridging type
            
            let any3 : Any = i
            print(type(of:any3)) // Int
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


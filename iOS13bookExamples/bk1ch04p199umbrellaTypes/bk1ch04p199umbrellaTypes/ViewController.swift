

import UIKit
import MediaPlayer

class Dog : Codable {
    @objc var noise : String = "woof"
    @objc func bark() -> String {
        return "woof"
    }
    @objc static var whatADogSays : String = "woof"
}
class Cat {}

class Dog2 : NSObject {
    
}

@objc protocol P {
    func meow()
}

class NoisyDog : Dog {}

func anyExpecter(_ a:Any) {}

protocol Flier {
    associatedtype Other
}
struct Bird : Flier {
    typealias Other = Insect
}
struct Insect : Flier {
    typealias Other = Bird
}
func flockTwoTogether<T:Flier>(_ flier:T, _ other:Any) {
    if other is T.Other {
        print("they can flock together")
    } else {
        print("they can't")
    }
}

func typeTester(_ d:Dog, _ whattype:Dog.Type) {
    // if d.dynamicType is whattype {} // compile error, "not a type" (i.e. a not a type literal)
    if type(of:d) === whattype {
        print("yep")
    } else {
        print("nope")
    }
    
//    print(d.dynamicType is AnyObject)
//    print(whattype is AnyObject)
//    print(d.dynamicType is AnyClass)
//    print(whattype is AnyClass)

    let _ = d as AnyObject
    let _ = whattype as AnyObject
}




class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    @IBAction func doButton(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("changed"), object: sender)
        NotificationCenter.default.post(name: Notification.Name("changed"), object: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changed), name: NSNotification.Name("changed"), object: nil)
        
        do {
            let d = Dog()
            let anyo : AnyObject = d
            let d2 = anyo as! Dog
            
            _ = d2
        }
        
        // but...
        
        do {
            let s = "howdy"
            let anyo : AnyObject = s as AnyObject
            let s2 = anyo as! String
            
            _ = s2
        }

        
        do {
            let s = "howdy"
            let any = s as AnyObject // implicitly casts to NSString
            // can also say:
            let anyy : AnyObject = s as NSString
            let s2 = any as! String
            let i = 1
            let any2 = i as AnyObject // implicitly casts to NSNumber
            // can also say:
            let anyy2 : AnyObject = i as NSNumber
            let i2 = any2 as! Int
            print(s2, i2)
        
            _ = s2
            _ = i2
            _ = anyy
            _ = anyy2
        }
        
        do {
            let r = CGRect() as AnyObject
            print(type(of:r))
        }
        
        do {
            // assigning nonclass to AnyObject type now requires a cast *
            let s : AnyObject = "howdy" as AnyObject // String to NSString to AnyObject
            let i : AnyObject = 1 as AnyObject // Int to NSNumber to AnyObject
            let ss = s as! NSString as String
            let sss = s as! String
            _ = (s,i, ss, sss)
        }
        
        do {
            let b = Bird() as AnyObject
            print(type(of:b))
        }
        
        do {
            // these are all now Any (wrapped in an Optional)
            let any1 = UserDefaults.standard.object(forKey: "myObject")
            let any2 = self.view.value(forKey:"backgroundColor")
            let data = try! NSKeyedArchiver.archivedData(withRootObject: "howdy", requiringSecureCoding: true)
            let c = try! NSKeyedUnarchiver(forReadingFrom: data)
            let any3 = c.decodeObject(forKey:"myKey")
            
            // however, we should call decodeObject(of:forKey:) which specifies class up front

            _ = any1
            _ = any2
            _ = c
            _ = any3
        }
        
        do {
            // but it is better to fetch from UserDefaults using a convenience method
            UserDefaults.standard.set(7, forKey: "Test")
            let s = UserDefaults.standard.string(forKey:"Test")
            print(s as Any)
        }
        
        /*
        do {
            // try to round-trip a Dog into coding
            let c1 = NSKeyedArchiver()
            let d = Dog()
            c1.encodeCodable(d, forKey: "Dog")
            print(c1)
        }
 */
        
        do {
            let c : AnyObject = Cat()
            let s = c.noise
            let s2 = c.bark?()
            var which : Bool {return false}
            if which {
                _ = c.bark() // legal, but we will crash
            }
            
            _ = s
            _ = s2
            
            let d : AnyObject = Dog()
            let ss = d.noise
            print(ss as Any)
            

        }

        do {
            let d = Dog()
            let d2 = d
            if d === d2 {
                print("they are the same object")
            }
        }
        
        do {
            let c : AnyClass = Cat.self
            // let s = c.noise
            let s = c.whatADogSays
            
            _ = s
        }
        
        do {
            let d : AnyObject = Dog2()
            d.meow?()
            // let a : AnyObject = d.copy()

        }
        
        do {
            typeTester(Dog(), Dog.self)
            typeTester(NoisyDog(), NoisyDog.self)
            typeTester(NoisyDog(), Dog.self)
            typeTester(Dog(), NoisyDog.self)
        }
        
        
        anyExpecter("howdy") // a struct instance
        anyExpecter(String.self) // a struct
        anyExpecter(Dog()) // a class instance
        anyExpecter(Dog.self) // a class
        anyExpecter(anyExpecter) // a function
        
        do {
        
            let anything : Any = "howdy"
            if anything is String {
                let s = anything as! String
                print(s) // howdy
            }
            if anything is NSString {
                let s = anything as! NSString
                print(s) // howdy
            }
            
        }
        
        do {
            let anything : Any = anyExpecter
            let anyobject = anything as AnyObject
            let anyobject2 : AnyObject = anything as AnyObject
            print(anyobject)
            _ = anyobject2
        }
        
        flockTwoTogether(Bird(), Insect())
        flockTwoTogether(Bird(), String())
        
        do {
            let d1 = Dog()
            let d2 : Dog? = nil
            let any : Any? = d2
            print(any as AnyObject? === d1) // false
            
            let any2 : Any? = d1
            print(any2 as AnyObject === d1) // false! huh?
            print(any2 as AnyObject? === d1) // true
            
            let any3 : Any = d1
            print(any3 as AnyObject === d1) // true
        }
        
        
    }
    
    @objc func changed(_ n:Notification) {
        let player = MPMusicPlayerController.applicationMusicPlayer // * no longer a func
        if n.object as AnyObject? === player { // *
            print("same")
        }
        if n.object as AnyObject === self.button {
            print("really same")
        }
        if n.object as AnyObject? === self.button {
            print("really same 2")
        }

    }



}




import UIKit
import MediaPlayer

class Dog {
    @objc var noise : String = "woof"
    @objc func bark() -> String {
        return "woof"
    }
    @objc static var whatADogSays : String = "woof"
}
class Cat {}

class NoisyDog : Dog {}

func anyExpecter(a:Any) {}

protocol Flier {
    typealias Other
}
struct Bird : Flier {
    typealias Other = Insect
}
struct Insect : Flier {
    typealias Other = Bird
}
func flockTwoTogether<T:Flier>(flier:T, _ other:Any) {
    if other is T.Other {
        print("they can flock together")
    } else {
        print("they can't")
    }
}

func typeTester(d:Dog, _ whattype:Dog.Type) {
    // if d.dynamicType is whattype { // compile error, "not a type" (i.e. a not a type literal)
    if d.dynamicType === whattype {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let d = Dog()
            let any : AnyObject = d
            let d2 = any as! Dog
            
            _ = d2
        }
        
        do {
            let s = "howdy"
            let any : AnyObject = s // implicitly casts to NSString
            let s2 = any as! String
            let i = 1
            let any2 : AnyObject = i // implicitly casts to NSNumber
            let i2 = any2 as! Int
        
            _ = s2
            _ = i2
        }
        
        do {
            // common ways to encounter an AnyObject (wrapped in an Optional)
            let any1 = NSUserDefaults.standardUserDefaults().objectForKey("myObject")
            let any2 = self.view.valueForKey("backgroundColor")
            let c = NSKeyedUnarchiver(forReadingWithData: NSData())
            let any3 = c.decodeObjectForKey("myKey")

            _ = any1
            _ = any2
            _ = c
            _ = any3
        }
        
        do {
            let c : AnyObject = Cat()
            let s = c.noise
            let s2 = c.bark?()
            // let s3 = c.bark() // legal, but we will crash
            
            _ = s
            _ = s2
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
            typeTester(Dog(), Dog.self)
            typeTester(NoisyDog(), NoisyDog.self)
            typeTester(NoisyDog(), Dog.self)
            typeTester(Dog(), NoisyDog.self)
        }
        
        
        anyExpecter("howdy") // a struct instance
        anyExpecter(String) // a struct
        anyExpecter(Dog()) // a class instance
        anyExpecter(Dog) // a class
        anyExpecter(anyExpecter) // a function
        
        flockTwoTogether(Bird(), Insect())
        flockTwoTogether(Bird(), String())
        
        
    }
    
    func changed(n:NSNotification) {
        let player = MPMusicPlayerController.applicationMusicPlayer()
        if n.object === player { // ...
        }
    }



}


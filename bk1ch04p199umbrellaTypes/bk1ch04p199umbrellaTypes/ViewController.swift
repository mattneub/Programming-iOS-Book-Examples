

import UIKit

class Dog {
    @objc var noise : String = "woof"
    @objc func bark() -> String {
        return "woof"
    }
}
class Cat {}

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
func flockTwoTogether<T:Flier>(flier:T, other:Any) {
    if other is T.Other {
        println("they can flock together")
    } else {
        println("they can't")
    }
}



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if true {
            let d = Dog()
            let any : AnyObject = d
            let d2 = any as! Dog
        }
        
        if true {
            let s = "howdy"
            let any : AnyObject = s // implicitly casts to NSString
            let s2 = any as! String
            let i = 1
            let any2 : AnyObject = i // implicitly casts to NSNumber
            let i2 = any2 as! Int
        }

        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("vc") // compiler warns
        let vc2 : AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("vc")
        let vc3 = self.storyboard!.instantiateViewControllerWithIdentifier("vc") as! UIViewController

        let c : AnyObject = Cat()
        let s = c.noise
        let s2 = c.bark?()
        // let s3 = c.bark() // legal, but we will crash

        if true {
            let d = Dog()
            let d2 = d
            if d === d2 {
                println("they are the same object")
            }
        }
        
        anyExpecter("howdy") // a struct instance
        anyExpecter(String) // a struct
        anyExpecter(Dog()) // a class instance
        anyExpecter(Dog) // a class
        anyExpecter(anyExpecter) // a function
        
        flockTwoTogether(Bird(), Insect())
        flockTwoTogether(Bird(), String())
        
        
    }



}


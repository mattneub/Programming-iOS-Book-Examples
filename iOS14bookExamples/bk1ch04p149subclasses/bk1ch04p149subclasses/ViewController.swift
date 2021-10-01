

import UIKit

class Quadruped {
    func walk () {
        print("walk walk walk")
    }
}
class Dog : Quadruped {
    func bark () {
        print("woof")
    }
    func bark2 () {
        print("woof")
    }
    func barkAndWalk() {
        self.bark()
        self.walk()
    }
    func barkAt(cat:Kitten) {}
    func barkAt1(cat:Kitten) {}
    func barkAt2a(cat:Cat) {}
    func barkAt2(cat:Cat) {}
    func barkAt3(cat:Kitten?) {}

}
class Cat : Quadruped {}
class Kitten : Cat {}
class NoisyDog : Dog {
    override func bark () {
        print("woof woof woof")
    }
    override func bark2 () {
        for _ in 1...3 {
            super.bark()
        }
    }
    override func barkAt(cat:Cat) {}
    override func barkAt1(cat:Cat?) {}
    // override func barkAt2a(cat:Kitten) {}
    override func barkAt2(cat:Cat?) {}
    override func barkAt3(cat:Cat?) {}
}



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let fido = Dog()
        fido.walk() // walk walk walk
        fido.bark() // woof
        fido.barkAndWalk() // woof walk walk walk

        let rover = NoisyDog()
        rover.bark() // woof woof woof
        rover.bark2() // woof woof woof

    }



}


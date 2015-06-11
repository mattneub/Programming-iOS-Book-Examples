

import UIKit

class Quadruped {
    func walk () {
        println("walk walk walk")
    }
}
class Dog : Quadruped {
    func bark () {
        println("woof")
    }
    func bark2 () {
        println("woof")
    }
    func barkAndWalk() {
        self.bark()
        self.walk()
    }
}
class Cat : Quadruped {}
class NoisyDog : Dog {
    override func bark () {
        println("woof woof woof")
    }
    override func bark2 () {
        for _ in 1...3 {
            super.bark()
        }
    }
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


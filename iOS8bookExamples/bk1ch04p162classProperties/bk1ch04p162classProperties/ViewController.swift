

import UIKit

class Dog {
    static func whatDogsSay() -> String {
        return "woof"
    }
    func bark() {
        println(Dog.whatDogsSay())
    }
}

// compile error:
/*

class NoisyDog : Dog {
    override class func whatDogsSay() -> String {
        return "WOOF"
    }
}

*/


class Dog2 {
    class func whatDogsSay() -> String {
        return "woof"
    }
    func bark() {
        println(Dog.whatDogsSay())
    }
}

class NoisyDog2 : Dog2 {
    override class func whatDogsSay() -> String {
        return "WOOF"
    }
}

class Dog3 {
    static var whatDogsSay = "woof"
    func bark() {
        println(Dog.whatDogsSay)
    }
}

// compile error (and so for other variants):
/*
class NoisyDog3 : Dog3 {
    override static var whatDogsSay : String {return "WOOF"}
}
*/

class Dog4 {
    class var whatDogsSay : String {
        return "woof"
    }
    func bark() {
        println(Dog.whatDogsSay)
    }
}

class NoisyDog4 : Dog4 {
    override static var whatDogsSay : String {
        return "WOOF"
    }
}




class ViewController: UIViewController {


}


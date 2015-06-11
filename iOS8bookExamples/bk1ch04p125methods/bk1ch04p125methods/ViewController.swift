

import UIKit

class Dog {
    let name : String
    let license : Int
    let whatDogsSay = "Woof"
    init(name:String, license:Int) {
        self.name = name
        self.license = license
    }
    func bark() {
        println(self.whatDogsSay)
    }
    func speak() {
        self.bark()
        println("I'm \(self.name)")
    }
    func speak2() { // legal, but I never intentionally write code like this
        bark()
        println("I'm \(name)")
    }
}

class Dog2 {
    func say(s:String, times:Int) {
        for _ in 1...times {
            println(s)
        }
    }
}

struct Greeting {
    static let friendly = "hello there"
    static let hostile = "go away"
    static var ambivalent : String {
        return self.friendly + " but " + self.hostile
    }
    static func beFriendly() {
        println(self.friendly)
    }
}

class Dog3 {
    static var whatDogsSay = "Woof"
    func bark() {
        println(Dog3.whatDogsSay)
    }
}

class MyClass {
    var s = ""
    func store(s:String) {
        self.s = s
    }
}



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let fido = Dog(name:"Fido", license:1234)
        fido.speak() // Woof I'm Fido

        let d = Dog2()
        d.say("woof", times:3)

        Greeting.beFriendly() // hello there

        let fido3 = Dog3()
        fido3.bark() // Woof

        let m = MyClass()
        let f = MyClass.store(m) // what just happened!?
        f("howdy")
        println(m.s) // howdy

    
    }


}


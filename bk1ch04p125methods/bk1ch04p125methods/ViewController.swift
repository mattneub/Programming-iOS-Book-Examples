

import UIKit

class Dog {
    let name : String
    let license : Int
    let whatDogsSay = "woof"
    init(name:String, license:Int) {
        self.name = name
        self.license = license
    }
    func bark() {
        print(self.whatDogsSay)
    }
    func speak() {
        self.bark()
        print("I'm \(self.name)")
    }
    func speak2() { // legal, but I never intentionally write code like this
        bark()
        print("I'm \(name)")
    }
}

class Dog2 {
    func say(_ s:String, times:Int) {
        for _ in 1...times {
            print(s)
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
        print(self.friendly)
    }
}

class Dog3 {
    static var whatDogsSay = "woof"
    func bark() {
        print(Dog3.whatDogsSay)
    }
}

class MyClass {
    var s = ""
    func store(_ s:String) {
        self.s = s
    }
}



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let fido = Dog(name:"Fido", license:1234)
        fido.speak() // woof I'm Fido

        let d = Dog2()
        d.say("woof", times:3)

        Greeting.beFriendly() // hello there

        let fido3 = Dog3()
        fido3.bark() // woof

        let m = MyClass()
        let f = MyClass.store(m) // what just happened!?
        f("howdy")
        print(m.s) // howdy

    
    }


}


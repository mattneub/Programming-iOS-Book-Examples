
import UIKit

class Dog {
    class var whatDogsSay : String {
        return "woof"
    }
    func bark() {
        print(type(of:self).whatDogsSay)
    }
    func bark2() {
        print(Self.whatDogsSay) // new, legal in Swift 5.1
    }
    func describeYourself() {
        let t1 = type(of:self)
        print(t1)
        // print(Self) // illegal
        // so you can use Self only as a message recipient
        // but therefore this is legal:
        let t2 = Self.self
        print(t2)
    }
    func dogTypeExpecter(_ whattype:Dog.Type) {
        _ = whattype == Dog.self // legal
        _ = whattype is Dog.Type // legal but silly
        _ = Self.self == Dog.self // legal
        _ = Self.self is Dog.Type // legal but silly
    }
}
class NoisyDog : Dog {
    override class var whatDogsSay : String {
        return "woof woof woof"
    }
}

struct S {
    static let greeting = "Hello"
    func greet() {
        print(Self.greeting) // legal too, so it isn't just classes or anything
    }
}

func dogTypeExpecter(_ whattype:Dog.Type) {
    let equality = whattype == Dog.self
    print("is it Dog?", equality)
    let typology = whattype is Dog.Type
    print("is it any kind of Dog?", typology) // always true, as compiler warns
    print("is it any kind of Noisy dog?", whattype is NoisyDog.Type) // always true, as compiler warns
    
    do { // legal but pointless
        _ = NoisyDog.self == Dog.self
        _ = NoisyDog.self is Dog.Type
    }
}

func typeTester(_ d:Dog, _ whattype:Dog.Type) {
    let identity = type(of:d) == whattype
    print("are they identical?", identity)
    // let typology2 = type(of:d) is whattype // compile error, undeclared type
    let equality = type(of:d) == Dog.self
    print("is it Dog?", equality)
    let typology = type(of:d) is NoisyDog.Type
    print("is it any kind of NoisyDog?", typology)
    
    _ = Dog.self == type(of:d)
    // Dog.self is type(of:d) // so illegal you could plotz
    // Dog.Type is NoisyDog.self // not sure what I was aiming at here
}



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        let d = Dog()
        d.bark()
        d.bark2()
        let nd = NoisyDog()
        nd.bark() // woof woof woof
        nd.bark2() // woof woof woof, using Self, hooray!
        print(nd)
        print(type(of:nd)) // still need type(of:) to examine an object's type _externally_
        // print(nd.Self) // not legal; this syntax was part of Erica's original proposal but it was not accepted
        
        do {
            let d : Dog = NoisyDog()
            print(type(of:d))
        }
    
        nd.describeYourself() // NoisyDog, both ways
        
        // dogTypeExpecter(Dog) // oooh, compiler now warns // now an error! beta 3
        dogTypeExpecter(Dog.self) // true
        // dogTypeExpecter(NoisyDog) // ditto // now an error! beta 3
        dogTypeExpecter(NoisyDog.self) // false; it is _a_ Dog type, but it is not Dog itself
        dogTypeExpecter(type(of:d))
        dogTypeExpecter(type(of:d).self)
        dogTypeExpecter(type(of:nd))
        dogTypeExpecter(type(of:nd).self)
        
        typeTester(Dog(), NoisyDog.self)
        typeTester(Dog(), Dog.self)
        typeTester(NoisyDog(), NoisyDog.self)
        typeTester(NoisyDog(), Dog.self)

        
        let ddd = Dog.self
        let dddd = type(of:ddd)
        print(ddd == Dog.self)
        print(dddd == type(of:Dog.self)) // oooookay...


    }



}


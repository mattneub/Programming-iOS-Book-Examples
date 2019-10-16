
import UIKit

class Dog {
    class var whatDogsSay : String {
        return "woof"
    }
    func bark() {
        print(type(of:self).whatDogsSay)
    }
}
class NoisyDog : Dog {
    override class var whatDogsSay : String {
        return "woof woof woof"
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
        let nd = NoisyDog()
        nd.bark() // woof woof woof
        print(nd)
        print(type(of:nd))
    
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


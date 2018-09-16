
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
        dogTypeExpecter(Dog.self)
        // dogTypeExpecter(NoisyDog) // ditto // now an error! beta 3
        dogTypeExpecter(NoisyDog.self)
        dogTypeExpecter(type(of:d))
        dogTypeExpecter(type(of:d).self)
        dogTypeExpecter(type(of:nd))
        dogTypeExpecter(type(of:nd).self)
        
        let ddd = Dog.self
        let dddd = type(of:ddd)
        print(ddd == Dog.self)
        print(dddd == type(of:Dog.self)) // oooookay...


    }



}


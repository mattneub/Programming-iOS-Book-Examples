
import UIKit

class Dog {
    class var whatDogsSay : String {
        return "Woof"
    }
    func bark() {
        print(self.dynamicType.whatDogsSay)
    }
}
class NoisyDog : Dog {
    override class var whatDogsSay : String {
        return "Woof woof woof"
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
        nd.bark() // Woof woof woof
        print(nd.dynamicType)
    
        dogTypeExpecter(Dog) // oooh, compiler now warns
        dogTypeExpecter(Dog.self)
        dogTypeExpecter(NoisyDog) // ditto
        dogTypeExpecter(NoisyDog.self)
        dogTypeExpecter(d.dynamicType)
        dogTypeExpecter(d.dynamicType.self)
        dogTypeExpecter(nd.dynamicType)
        dogTypeExpecter(nd.dynamicType.self)
        
        let ddd = Dog.self
        let dddd = ddd.dynamicType
        print(ddd == Dog.self)
        print(dddd == Dog.self.dynamicType) // oooookay...


    }



}


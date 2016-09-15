
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

func typeExpecter(whattype:Dog.Type) {
}



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        let d = Dog()
        d.bark()
        let nd = NoisyDog()
        nd.bark() // Woof woof woof
        print(nd.dynamicType)
    
        typeExpecter(Dog)
        typeExpecter(Dog.self)
        typeExpecter(d.dynamicType)
        typeExpecter(d.dynamicType.self)
        typeExpecter(nd.dynamicType)
        typeExpecter(nd.dynamicType.self)


    }



}


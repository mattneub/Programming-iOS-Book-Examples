

import UIKit

class Dog {
    var name : String
    required init(name:String) {
        self.name = name
    }
    class func makeAndName() -> Dog {
        let d = self(name:"Fido")
        return d
    }
    class func makeAndName2() -> Self {
        let d = self(name:"Fido")
        return d
    }
    func havePuppy(#name:String) -> Self {
        return self.dynamicType(name:name)
    }
}
class NoisyDog : Dog {
}
func dogMakerAndNamer(whattype:Dog.Type) -> Dog {
    let d = whattype(name:"Fido") // compile error, unless `init(name:)` is `required`
    return d
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let d = dogMakerAndNamer(Dog) // d is a Dog named Fido
        let d2 = dogMakerAndNamer(NoisyDog) // d2 is a NoisyDog named Fido

        let dd = Dog.makeAndName() // d is a Dog named Fido
        let dd2 = NoisyDog.makeAndName() // d2 is a NoisyDog named Fido - but typed as Dog
        
        let ddd = Dog.makeAndName2() // d is a Dog named Fido
        let ddd2 = NoisyDog.makeAndName2() // d2 is a NoisyDog named Fido, typed as NoisyDog

        if true {
            let d = Dog(name:"Fido")
            let d2 = d.havePuppy(name:"Fido Junior")
            let nd = NoisyDog(name:"Rover")
            let nd2 = nd.havePuppy(name:"Rover Junior")
        }
    }

}


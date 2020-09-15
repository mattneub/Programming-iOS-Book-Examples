

import UIKit

class Dog {
    var name : String
    required init(name:String) {
        self.name = name
    }
    class func makeAndName() -> Dog {
        let d = Self(name:"Fido") // newly required in Swift 2.0
        return d
    }
    class func makeAndName2() -> Self {
        let d = Self(name:"Fido") // newly required in Swift 2.0
        return d
    }
    func havePuppy(name:String) -> Self {
        return Self(name:name) // ditto
    }
}
class NoisyDog : Dog {
}
func dogMakerAndNamer(_ whattype:Dog.Type) -> Dog {
    let d = whattype.init(name:"Fido")
    return d
}


// just for completeness, this is how you solve the "return Self" problem for the global function
// but we aren't ready for that until we discuss generics
func dogMakerAndNamer2<WhatType:Dog>(_:WhatType.Type) -> WhatType {
    let d = WhatType.init(name:"Fido")
    return d
}

// pseudocode: this is what the generic turns into if NoisyDog.self is passed as parameter
func dogMakerAndNamer3(_:NoisyDog.Type) -> NoisyDog {
    let d = NoisyDog.init(name:"Fido")
    return d
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dd = Dog.makeAndName() // d is a Dog named Fido
        print(dd, dd.name)
        let dd2 = NoisyDog.makeAndName() // d2 is a NoisyDog named Fido - but typed as Dog
        print(dd2, dd2.name)
        
        let ddd = Dog.makeAndName2() // d is a Dog named Fido
        print(ddd, ddd.name)
        let ddd2 = NoisyDog.makeAndName2() // d2 is a NoisyDog named Fido, typed as NoisyDog
        print(ddd2, ddd2.name)

        


        do {
            let d = Dog(name:"Fido")
            let d2 = d.havePuppy(name:"Fido Junior")
            print(d2, d2.name)
            let nd = NoisyDog(name:"Rover")
            let nd2 = nd.havePuppy(name:"Rover Junior")
            print(nd2, nd2.name)
            
        }
        
        let d = dogMakerAndNamer(Dog.self) // d is a Dog named Fido
        print(d, d.name)
        let d2 = dogMakerAndNamer(NoisyDog.self) // d2 is a NoisyDog named Fido - but typed as Dog
        print(d2, d2.name)

        
        // contradiction: the compiler stops us up front
        // let d3 : NoisyDog = dogMakerAndNamer(Dog.self)
        
        do { // d2 is typed by inference as a NoisyDog, thanks to generics
            let d = dogMakerAndNamer2(Dog.self) // d is a Dog named Fido
            print(d, d.name)
            let d2 = dogMakerAndNamer2(NoisyDog.self) // d2 is a NoisyDog named Fido
            print(d2, d2.name)
        }
        

        
    }

}


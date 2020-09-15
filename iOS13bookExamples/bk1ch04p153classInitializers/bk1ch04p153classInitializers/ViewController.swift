

import UIKit

class Dog {
}
class Dog2 {
    var name = "Fido"
}
class Dog2b {
    var name = "Fido"
    init(name:String) {self.name = name}
}
class Dog2c {
    var name = "Fido"
    convenience init(name:String) {
        self.init()
        self.name = name
    }
}
class Dog3 {
    var name : String
    var license : Int
    init(name:String, license:Int) {
        self.name = name
        let whatever = self.name
        _ = whatever
        self.license = license
    }
}
class Dog4 {
    var testing = "testing"
    var name : String
    var license : Int
    init(name:String, license:Int) {
        self.name = name
        self.license = license
    }
    convenience init(license:Int) {
        self.init(name:"Fido", license:license)
    }
    convenience init() {
        // print(self.testing) // illegal
        self.init(license:1)
    }
}


class Dog5 {
    var name : String
    var license : Int
    init(name:String, license:Int) {
        self.name = name
        self.license = license
    }
    convenience init(license:Int) {
        self.init(name:"Fido", license:license)
    }
}
class NoisyDog5 : Dog5 {
}

class Dog6 {
    var name : String
    var license : Int
    init(name:String, license:Int) {
        self.name = name
        self.license = license
    }
    convenience init(license:Int) {
        self.init(name:"Fido", license:license)
    }
}
class NoisyDog6 : Dog6 {
    convenience init(name:String) {
        self.init(name:name, license:1)
    }
}

class Dog7 {
    var name : String
    var license : Int
    init(name:String, license:Int) {
        self.name = name
        self.license = license
    }
    convenience init(license:Int) {
        self.init(name:"Fido", license:license)
    }
}
class NoisyDog7 : Dog7 {
    init(name:String) {
        super.init(name:name, license:1)
    }
    init(license:Int) { // no "override", can be "convenience" or not
        super.init(name:"Rover", license:license)
    }
    // or:
//    convenience init(license:Int) { // no "override", can be "convenience" or not
//        self.init(name:"Rover")
//    }

}
class Dog8 {
    var name : String
    var license : Int
    init(name:String, license:Int) {
        self.name = name
        self.license = license
    }
    convenience init(license:Int) {
        self.init(name:"Fido", license:license)
    }
}
class NoisyDog8 : Dog8 {
    override init(name:String, license:Int) {
        super.init(name:name, license:license)
    }
}

class Dog9 {
    var name : String
    var license : Int
    init(name:String, license:Int) {
        self.name = name
        self.license = license
    }
}
class NoisyDog9 : Dog9 {
    convenience init?() {
        return nil // legal
    }
    init?(ok:Bool) {
        if !ok {return nil}
        // used to give compile error: "all stored properties... must be initialized..."
        // now legal starting in Swift 2.2
        super.init(name:"Fido", license:123)
    }
    // illegal: init? cannot override init
//    override init?(name:String, license:Int) {
//        super.init(name:name, license:license)
//    }
    override init(name:String, license:Int) {
        super.init(name:name, license:license)
    }
}
class ObnoxiousDog9 : NoisyDog9 {
    // legal, init can override init?
    override init(ok:Bool) {
        super.init(name:"Fido", license:123)
    }
}
class CrazyDog9 : NoisyDog9 {
    override init(ok:Bool) {
        super.init(ok:ok)! // legal: call super's designated init? without ? and by adding !
    }
}
class Dog10 {
    init() {
        print("Dog10 init was called")
    }
}
class NoisyDog10 : Dog10 {
    init(name:String = "Fido") {
        print("NoisyDog10 init(name:) was called")
        // note that this is legal even though we don't explicitly call super.init
        // the print messages prove that it is called anyway
    }
}

class A:NSObject {
    init?(ok:Bool) {
        super.init()
    }
}
class B:A {
    override init(ok:Bool) {
        super.init(ok:ok)!
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let d = Dog()
            let d2 = Dog2()
            // let d2b = Dog2b() // nope, lost the implicit initializer
            let d2b = Dog2b(name:"Rover")
            let d2c = Dog2c() // kept the implicit initializer
            let d2c2 = Dog2c(name:"Rover")
            let d3 = Dog3(name:"Rover", license:42)
            let d4 = Dog4()
            
            _ = d
            _ = d2
            _ = d3
            _ = d4
            _ = d2b
            _ = d2c
            _ = d2c2
        }
        
        do {
            let nd1 = NoisyDog5(name:"Fido", license:1)
            let nd2 = NoisyDog5(license:2)
            // let nd3 = NoisyDog5() // compile error
            
            _ = nd1
            _ = nd2
        }
        
        do {
            let nd1 = NoisyDog6(name:"Fido", license:1)
            let nd2 = NoisyDog6(license:2)
            let nd3 = NoisyDog6(name:"Rover")
            
            _ = nd1
            _ = nd2
            _ = nd3
        }

        do {
            let nd1 = NoisyDog7(name:"Rover")
            // let nd2 = NoisyDog7(name:"Fido", license:1) // compile error
            // let nd3 = NoisyDog7(license:2) // compile error
            
            _ = nd1

        }
        
        do {
            let nd1 = NoisyDog8(name:"Rover", license:1)
            let nd2 = NoisyDog8(license:2)
        
            _ = nd1
            _ = nd2

        }
        
        do {
            let nd = NoisyDog10()
            _ = nd
        }
    
        
        
    }


}




import UIKit

class Dog {
}

class Dog2 {
    var name = ""
    var license = 0
    init(name:String) {
        self.name = name
    }
    init(license:Int) {
        self.license = license
    }
    init(name:String, license:Int) {
        self.name = name
        self.license = license
    }
}

class Dog3 {
    var name = ""
    var license = 0
    init() {
    }
    init(name:String) {
        self.name = name
    }
    init(license:Int) {
        self.license = license
    }
    init(name:String, license:Int) {
        self.name = name
        self.license = license
    }
}

class Dog4 {
    var name = ""
    var license = 0
    init(name:String = "", license:Int = 0) {
        self.name = name
        self.license = license
    }
}

class Dog5 {
    var name : String // no default value!
    var license : Int // no default value!
    init(name:String = "", license:Int = 0) {
        self.name = name
        self.license = license
    }
}

/*
class Dog5not {
    var name : String
    var license : Int
    init(name:String = "") {
        self.name = name // compile error
    }
}
*/

class Dog6 {
    let name : String
    let license : Int
    init(name:String = "", license:Int = 0) {
        self.name = name
        self.license = license
    }
}

class DogReal {
    let name : String
    let license : Int
    init(name:String, license:Int) {
        self.name = name
        self.license = license
    }
}


struct Cat {
    var name : String
    var license : Int
    init(name:String, license:Int) {
        self.name = name
        // meow() // too soon - compile error
        self.license = license
    }
    func meow() {
        print("meow")
    }
}

struct Digit {
    var number : Int
    var meaningOfLife : Bool
    // let meaningOfLife : Bool // would be legal but delegating initializer cannot set it
    init(number:Int) {
        self.number = number
        self.meaningOfLife = false
    }
    init() { // delegating initializer
        self.init(number:42)
        self.meaningOfLife = true
    }
}

struct Digit2 { // I regard the legality of this as a compiler bug
    var number : Int = 100
    init(value:Int) {
        self.init(number:value)
    }
    init(number:Int) {
        self.init(value:number)
    }
}

class DogFailable {
    let name : String
    let license : Int
    init!(name:String, license:Int) {
        self.name = name
        self.license = license
        if name.isEmpty {
            return nil
        }
        if license <= 0 {
            return nil
        }
    }
}

struct DigitFailable {
    var number : Int
    var meaningOfLife : Bool
    init?(number:Int) {
        if number != 42 {
            return nil // early exit is legal for a struct in Swift 2.0
        }
        self.number = number
        self.meaningOfLife = false
    }
}




class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Dog() // silly - compiler now warns
        let fido = Dog()
        
        let fido2 = Dog2(name:"Fido")
        let rover2 = Dog2(license:1234)
        let spot2 = Dog2(name:"Spot", license:1357)
        // let puff2 = Dog2() // compile error

        let fido3 = Dog3(name:"Fido")
        let rover3 = Dog3(license:1234)
        let spot3 = Dog3(name:"Spot", license:1357)
        let puff3 = Dog3()

        let fido4 = Dog4(name:"Fido")
        let rover4 = Dog4(license:1234)
        let spot4 = Dog4(name:"Spot", license:1357)
        let puff4 = Dog4()
        
        let fido5 = Dog5(name:"Fido")
        let rover5 = Dog5(license:1234)
        let spot5 = Dog5(name:"Spot", license:1357)
        let puff5 = Dog5()
        
        let fido6 = Dog6(name:"Fido")
        let rover6 = Dog6(license:1234)
        let spot6 = Dog6(name:"Spot", license:1357)
        let puff6 = Dog6()
        
        // let fido7 = DogReal(name:"Fido")
        // let rover7 = DogReal(license:1234)
        let spot7 = DogReal(name:"Spot", license:1357)
        // let puff7 = DogReal()
        
        let fido8 = DogFailable(name:"", license:0)
        let name = fido8.name // crash
        
        let im = UIImage(named:"dummy")

        _ = fido
        _ = fido2
        _ = fido3
        _ = fido4
        _ = fido5
        _ = fido6
        //_ = fido7
        _ = fido8
        //_ = rover
        _ = rover2
        _ = rover3
        _ = rover4
        _ = rover5
        _ = rover6
        //_ = rover7
        //_ = rover8
        //_ = spot
        _ = spot2
        _ = spot3
        _ = spot4
        _ = spot5
        _ = spot6
        _ = spot7
        //_ = spot8
        //_ = puff
        //_ = puff2
        _ = puff3
        _ = puff4
        _ = puff5
        _ = puff6
        //_ = puff7
        //_ = puff8
        
        _ = name
        _ = im



        
    }


}


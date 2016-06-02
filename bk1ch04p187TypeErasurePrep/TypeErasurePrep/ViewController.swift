

import UIKit

protocol Flier {
    associatedtype Other
    func fly()
}

struct Bird : Flier {
    var noise = ""
    typealias Other = Insect
    func fly() { print(noise) }
}
struct Insect : Flier {
    var noise = ""
    typealias Other = Bird
    func fly() { print(noise) }
}

struct FlierStruct {
    let flierAdopterFlyMethod : (Void) -> Void
    init<FlierAdopter:Flier>(_ flierAdopter:FlierAdopter) {
        self.flierAdopterFlyMethod = flierAdopter.fly
    }
    func fly() {
        self.flierAdopterFlyMethod()
    }
}

// =============

protocol Flier2 {
    associatedtype Other
    func flockTogetherWith(_ other:Other)
}
struct Bird2 : Flier2 {
    typealias Other = Insect2
    func flockTogetherWith(_ other:Other) {
        print("flap flap flap, I'm flocking with some \(other.dynamicType)")
    }
}
struct Insect2 : Flier2 {
    typealias Other = Bird2
    func flockTogetherWith(_ other:Other) {
        print("whirrrrr, I'm flocking with some \(other.dynamicType)")
    }
}

struct FlierStruct2<Other> {
    let flierAdopterFlockMethod : (Other) -> Void
    init<FlierAdopter:Flier2 where Other == FlierAdopter.Other>(_ flierAdopter:FlierAdopter) {
        self.flierAdopterFlockMethod = flierAdopter.flockTogetherWith
    }
    func flockTogetherWith(_ other:Other) {
        self.flierAdopterFlockMethod(other)
    }
}



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var b = Bird()
        b.noise = "flap flap flap"
        let f = FlierStruct(b)
        f.fly() // flap flap flap
        var i = Insect()
        i.noise = "whirrrrr"
        let f2 = FlierStruct(i)
        f2.fly() // whirrrrr
        
        // ==== acid test!
        
        do {
            let f = FlierStruct2(Bird2())
            f.flockTogetherWith(Insect2())
            // f.flockTogetherWith(Bird2()) // and this correctly fails to compile! hoorah!
            let arr = [FlierStruct2(Bird2()), FlierStruct2(Bird2())]
            // let arr2 = [FlierStruct2(Bird2()), FlierStruct2(Insect2())]
            _ = arr
        }
    }

}


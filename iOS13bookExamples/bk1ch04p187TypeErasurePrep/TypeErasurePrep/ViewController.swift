

import UIKit

protocol Flier {
    associatedtype Other
    func fly()
}

struct Bird : Flier {
    let noise : String
    typealias Other = Insect
    func fly() { print(self.noise) }
}
struct Insect : Flier {
    let noise : String
    typealias Other = Bird
    func fly() { print(self.noise) }
}

struct FlierStruct /* : Flier */ {
    let flierAdopterFlyMethod : () -> ()
    init<FlierAdopter:Flier>(_ flierAdopter:FlierAdopter) {
        self.flierAdopterFlyMethod = flierAdopter.fly
    }
    func fly() {
        self.flierAdopterFlyMethod()
    }
}

// =============

protocol Flier2 {
    associatedtype Other2
    func fly()
    func flockTogetherWith(other:Other2)
}
struct Bird2 : Flier2 {
    let noise : String
    typealias Other2 = Insect2
    func fly() { print(self.noise) }
    func flockTogetherWith(other:Other2) {
        print("\(self.noise), I'm flocking with some \(type(of:other))")
    }
}
struct Insect2 : Flier2 {
    let noise : String
    typealias Other2 = Bird2
    func fly() { print(self.noise) }
    func flockTogetherWith(other:Other2) {
        print("\(self.noise), I'm flocking with some \(type(of:other))")
    }
}

struct FlierStruct2<Other2> : Flier2 {
    let flierAdopterFlyMethod : () -> ()
    let flierAdopterFlockMethod : (Other2) -> ()
    init<FlierAdopter:Flier2>(_ flierAdopter:FlierAdopter) where Other2 == FlierAdopter.Other2 {
        self.flierAdopterFlyMethod = flierAdopter.fly
        self.flierAdopterFlockMethod = flierAdopter.flockTogetherWith
    }
    func fly() {
        self.flierAdopterFlyMethod()
    }
    func flockTogetherWith(other:Other2) {
        self.flierAdopterFlockMethod(other)
    }
}



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let b = Bird(noise:"flap flap flap")
        let f = FlierStruct(b)
        f.fly() // flap flap flap
        let i = Insect(noise:"whirrrrr")
        let f2 = FlierStruct(i)
        f2.fly() // whirrrrr
        
        // ==== acid test!
        
        do {
            let f = FlierStruct2(Bird2(noise:"flap flap flap"))
            f.flockTogetherWith(other:Insect2(noise:"whirrrrr"))
            // f.flockTogetherWith(other:Bird2(noise:"flap flap flap")) // and this correctly fails to compile! hoorah!
            let arr = [FlierStruct2(Bird2(noise:"flap flap flap")), FlierStruct2(Bird2(noise:"flap flap flap"))]
            // let arr2 = [FlierStruct2(Bird2(noise:"flap flap flap")), FlierStruct2(Insect2(noise:"whirrrrr"))]
            _ = arr
        }
    }

}


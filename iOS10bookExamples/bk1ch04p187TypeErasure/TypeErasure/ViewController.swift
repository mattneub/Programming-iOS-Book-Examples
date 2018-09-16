

import UIKit

// not in book, but I might put it in

protocol Flier {
    associatedtype Other
    func flockTogetherWith(_ other:Other)
}
struct Bird : Flier {
    typealias Other = Insect
    func flockTogetherWith(_ other:Other) {
        print("tweet tweet, I'm flocking with some \(type(of:other))")
    }
}
struct Insect : Flier {
    typealias Other = Insect
    func flockTogetherWith(_ other:Other) {
        print("buzz buzz, I'm flocking with some \(type(of:other))")
    }
}
struct Helicopter : Flier {
    typealias Other = Helicopter
    func flockTogetherWith(_ other:Other) {
        print("whrrrrrrrrr!")
    }
}

// =======

struct FlierStruct1<T> {
    init<FlierAdopter:Flier>(_ flierAdopter:FlierAdopter) {
    }
}

struct FlierStruct2<T> {
    init<FlierAdopter:Flier>(_ flierAdopter:FlierAdopter) where T == FlierAdopter.Other {
    }
}


struct FlierStruct<T>:Flier {
    // let flierAdopter : Flier // can't make a wrapper like this
    // let flierAdopter : Flier where T == FlierAdopter.Other // or like this
    // but we _can_ store a function reference taken from the init parameter Flier!

    let flockFunction : (T) -> ()
    init<FlierAdopter : Flier>(_ flierAdopter:FlierAdopter) where FlierAdopter.Other == T {
        self.flockFunction = flierAdopter.flockTogetherWith
    }
    func flockTogetherWith(_ other:T) {
        self.flockFunction(other)
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            // let aFlier : Flier = Bird() // no, Flier is not a type in this sense
        }

        do {
            let aFlier : FlierStruct1 = FlierStruct1<Insect>(Bird())
            _ = aFlier
        }

        do {
            let aFlier : FlierStruct2 = FlierStruct2(Bird())
            _ = aFlier
        }

        do {
            //let fliers : [Flier] = [Bird(), Insect()] // can't do this
            //fliers.forEach {$0.flockTogetherWith(Insect())}
            let fliers : [Any] = [Bird(), Insect()] // ... unless we throw away types completely
            // (in which case we can't send flockTogetherWith to it)
            _ = fliers
        }
        
        
        do {
            // the solution is our FlierStruct
            let fliers = [FlierStruct(Bird()), FlierStruct(Insect())]
            // fliers is an Array<FlierStruct<Insect>>
            fliers.forEach {$0.flockTogetherWith(Insect())}
            // tweet tweet, I'm flocking with some Insect
            // buzz buzz, I'm flocking with some Insect
        }

        do {
            // the placeholder resolution type is preserved! so:
            let fliers = [FlierStruct(Bird()), FlierStruct(Insect())]
            // fliers.forEach {$0.flockTogetherWith(Bird())}
            // can't do that, because they resolve Other to Insect, not Bird
            _ = fliers
        }
        
        do {
            // let fliers = [FlierStruct(Bird()), FlierStruct(Helicopter())]
            // can't do that either, because they resolve Other differently
        }



    
        do {
            let rangeOfInt = 1...3
            let arrayOfInt = [4,5,6]
            // let arrr : [SequenceType] = [rangeOfInt, arrayOfInt]
            let arr = [AnySequence(rangeOfInt), AnySequence(arrayOfInt)]
            let sums = arr.map {$0.reduce(0,+)}
            print(sums)
        }
    
    }



}


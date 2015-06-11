

import UIKit


let s : Optional<String> = "howdy"

protocol Flier {
    func flockTogetherWith(f:Self)
}
struct Bird : Flier {
    func flockTogetherWith(f:Bird) {}
}

protocol Flier2 {
    typealias Other
    func flockTogetherWith(f:Other)
    func mateWith(f:Other)
}
struct Bird2 : Flier2 {
    func flockTogetherWith(f:Bird2) {}
    func mateWith(f:Bird2) {}
}

func takeAndReturnSameThing<T> (t:T) -> T {
    return t
}
let thing = takeAndReturnSameThing("howdy")

struct HolderOfTwoSameThings<T> {
    var firstThing : T
    var secondThing : T
    init(thingOne:T, thingTwo:T) {
        self.firstThing = thingOne
        self.secondThing = thingTwo
    }
}
let holder = HolderOfTwoSameThings(thingOne:"howdy", thingTwo:"getLost")

func flockTwoTogether<T, U>(f1:T, f2:U) {}
let vd : Void = flockTwoTogether("hey", 1)

protocol Flier3 {
    typealias Other : Flier3
    func flockTogetherWith(f:Other)
}
struct Bird3 : Flier3 {
    func flockTogetherWith(f:Insect3) {}
}
struct Insect3 : Flier3 {
    func flockTogetherWith(f:Insect3) {}
}

func flockTwoTogether2<T:Flier3>(f1:T, f2:T) {}
let vd2 : Void = flockTwoTogether2(Bird3(), Bird3())
// let vd3 : Void = flockTwoTogether2(Bird3(), Insect3())
// let vd4 : Void = flockTwoTogether2("hey", "ho")

func myMin<T:Comparable>(things:T ...) -> T {
    var minimum = things[0]
    for ix in 1..<things.count {
        if things[ix] < minimum { // compile error if you remove Comparable constraint
            minimum = things[ix]
        }
    }
    return minimum
}

// a generic protocol like Flier3 cannot be used as a type
// func flockTwoTogether3(f1:Flier3, f2:Flier3) {}
// it can _only_ be used as a type constraint, as in flockTwoTogether2

protocol Flier4 {
    typealias Other
}
struct Bird4 : Flier4 {
    typealias Other = String
}

class Dog<T> {
    var name : T? = nil
}
let d = Dog<String>()

protocol Flier5 {
    init()
}
struct Bird5 : Flier5 {
    init() {}
}
struct FlierMaker<T:Flier5> {
    static func makeFlier() -> T {
        return T()
    }
}
let f = FlierMaker<Bird5>.makeFlier() // returns a Bird5

// class NoisyDog : Dog {} // nope
// class NoisyDog : Dog<String> {} // nope
class NoisyDog<U> : Dog<String> {}
let nd = NoisyDog<Int>() // the Int is pointless



class ViewController: UIViewController {
}


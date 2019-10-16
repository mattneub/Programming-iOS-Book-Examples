

import UIKit


let s : Optional<String> = "howdy"

protocol Flier {
    func flockTogetherWith(_ f:Self)
}
struct Bird : Flier {
    func flockTogetherWith(_ f:Bird) {}
}

protocol Flier2 {
    associatedtype Other
    func flockTogetherWith(_ f:Self.Other) // just showing that this is legal
    func mateWith(_ f:Other)
}
struct Bird2 : Flier2 {
    func flockTogetherWith(_ f:Bird2) {}
    func mateWith(_ f:Bird2) {}
}
/*
struct Bird2Not : Flier2 { // does not conform
    func flockTogetherWith(_ f: String) {}
    func mateWith(_ f:Int) {}
}
 */

func takeAndReturnSameThing<T> (_ t:T) -> T {
    if T.self is String.Type {
        print("hey, it's a string")
    }
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

func flockTwoTogether<T, U>(_ f1:T, _ f2:U) {}
let vd : Void = flockTwoTogether("hey", 1)

// WHOA! Using a `where` clause in Swift 4 works around the weird rule where you can't say Other : Flier3a
// however, I'm told that's a bug; recursive constraints are not ready for prime time and this should not have been allowed

protocol Flier3a {
    associatedtype Other where Other : Flier3a
    func flockTogetherWith(f:Other)
}

struct Bird3a : Flier3a {
    func flockTogetherWith(f:Bird3a) {}
}


// illegal in Xcode 7 beta 5!
// still illegal in Swift 2.2, it seems
// still illegal in Swift 3 toolchain
// still illegal in Swift 4

/*

protocol Flier3aa {
    associatedtype Other : Flier3aa
    func flockTogetherWith(f:Other)
}
struct Bird3aa : Flier3aa {
    func flockTogetherWith(f:Insect3aa) {}
}
struct Insect3aa : Flier3aa {
    func flockTogetherWith(f:Insect3aa) {}
}

*/

// workaround:

///*

protocol Superflier3 {}

protocol Flier3 : Superflier3 {
    associatedtype Other : Superflier3
    func flockTogetherWith(f:Other)
}
struct Bird3 : Flier3 {
    func flockTogetherWith(f:Insect3) {}
}
struct Insect3 : Flier3 {
    func flockTogetherWith(f:Insect3) {}
}

//*/

// okay but I'm sort of sorry I used that example at all; here's something a bit clearer that avoids the whole self-reference issue:

protocol Flier7 {
    func fly()
}
protocol Flocker7 {
    associatedtype Other : Flier7
    func flockTogetherWith(f:Other)
}
struct Bird7 : Flocker7, Flier7 {
    func fly() {}
    func flockTogetherWith(f:Bird7) {}
}

// ========

func flockTwoTogether2<T:Flier3>(_ f1:T, _ f2:T) {}
let vd2 : Void = flockTwoTogether2(Bird3(), Bird3())
// let vd3 : Void = flockTwoTogether2(Bird3(), Insect3())
// let vd4 : Void = flockTwoTogether2("hey", "ho")

func myMin<T:Comparable>(_ things:T...) -> T {
    var minimum = things.first!
    for item in things.dropFirst() {
        if item < minimum { // compile error if you remove Comparable constraint
            minimum = item
        }
    }
    return minimum
}

// a generic protocol like Flier3 cannot be used as a type
// func flockTwoTogether3(f1:Flier3, f2:Flier3) {}
// it can _only_ be used as a type constraint, as in flockTwoTogether2

protocol Flier4 {
    associatedtype Other
}
struct Bird4 : Flier4 {
    typealias Other = String
}

class Dog<T> {
    func speak(_ what:T) {}
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
        return T() // a little surprising I don't have to say T.init(), but I guess it is a real type
    }
}
let f = FlierMaker<Bird5>.makeFlier() // returns a Bird5

class NoisyDog : Dog<String> {
    override func speak(_ what:String) {} // this is new in Swift 4? or maybe just non-crashing is what's new?
} // yes! This is new in Swift 2.0
class NoisyDog2<T> : Dog<T> {
    override func speak(_ what:T) {}
} // and this is also legal!
// class NoisyDog3 : Dog<T> {} // but this is not; the superclass generic must be resolved somehow

struct Wrapper<T> {
    
}
struct Wrapper2<T> {
    var thing : T
    init(_ thing : T) {
        self.thing = thing
    }
}
class Cat {
}
class CalicoCat : Cat {
}

protocol Meower3 {
    func meow()
}
struct Wrapper3<T:Meower3> {
    let meower : T
}
class Cat3 : Meower3 {
    func meow() { print("meow") }
}
class CalicoCat3 : Cat3 {
}


protocol Walker {}
struct Quadruped : Walker {}

protocol Flier6 {
    associatedtype Other
    func fly()
}

/*
func flockTwoTogether6(f1:Flier6, _ f2:Flier6) { // compile error
    f1.fly()
    f2.fly()
}
*/

func flockTwoTogether6<T1:Flier6, T2:Flier6>(f1:T1, _ f2:T2) {
    f1.fly()
    f2.fly()
}

// just testing: this one actually segfaults
// but not any more! In Swift 2.2 (Xcode 7.3b) this is fine; not sure when that happened
// but in Swift 3 is segfaults again, taking it back out
// in Swift 4 it errors coherently as being "recursive"
// class Dog2<T:Dog2> {}



class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(thing)
        
        let min = myMin(1,8,5,2)
        print(min)
        
        do {
            // let w : Wrapper<Cat> = Wrapper<CalicoCat>() // error
            var w2 : Wrapper2<Cat> = Wrapper2(CalicoCat()) // fine
            let w3 = Wrapper2(CalicoCat())
            // w2 = w3 // error
            // ==== shut up the compiler
            w2 = Wrapper2(CalicoCat())
            _ = w2
            _ = w3
        }
        
        do { // same thing as before except with a protocol and struct
            // let w : Wrapper<Walker> = Wrapper<Quadruped>() // error
        }
        
        do {
            var o = Optional(Cat())
            let o2 = Optional(CalicoCat())
            o = o2 // yep
            var w = Wrapper2(Cat())
            let w2 = Wrapper2(CalicoCat())
            // w = w2 // nope
            _ = (o, w, w2)
        }
        
        do {
            let w2 : Wrapper3<Cat3> = Wrapper3(meower:CalicoCat3())
            
        }
        
        do {
            // not in book, but I suppose it should be: how to check type of resolved generic placeholder
            // From https://stackoverflow.com/a/46249717/341994
            
            func get<T>() -> T? {
                if T.self is Int.Type { print("int") } // WOW!!!
                return nil
            }
            let _ : Int? = get()
            let _ : String? = get()
        }
        
    }
}


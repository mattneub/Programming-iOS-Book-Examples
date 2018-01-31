

import UIKit

// =====

protocol Wieldable {
}
struct Sword : Wieldable {
}
struct Bow : Wieldable {
}
protocol Fighter {
    // associatedtype Enemy where Enemy : Fighter // in Swift 4.1, we can recurse directly
    associatedtype Enemy : Fighter
    associatedtype Weapon : Wieldable
    func steal(weapon:Self.Enemy.Weapon, from:Self.Enemy)
}
struct Soldier : Fighter {
    typealias Weapon = Sword
    typealias Enemy = Archer
    func steal(weapon:Bow, from:Archer) {
    }
}
struct Archer : Fighter {
    typealias Weapon = Bow
    typealias Enemy = Soldier
    func steal (weapon:Sword, from:Soldier) {
    }
}

struct Camp<T:Fighter> {
    var spy : T.Enemy?
}

// =====

class Dog {}
class FlyingDog : Dog, Flier {}
protocol Flier {
}
protocol Walker {
}
protocol Generic {
    associatedtype T : Flier, Walker // T must adopt Flier and Walker
    associatedtype UU where UU:Flier // STOP PRESS! this is legal in Swift 4!
    // and == would have been legal here too!
    associatedtype U : Dog, Flier // legal: this is basically an inheritance declaration!
}
protocol JustKidding {
    func flyAndWalk<T> (_ f:T) -> String where T:Walker, T:Flier
}

struct JustTesting {
    func flyAndWalk<T: Flier> (_ f:T) {}
    func flyAndWalk2<T: Flier & Walker> (_ f:T) {}
    func flyAndWalk3<T: Flier & Dog> (_ f:T) {}
}

struct JustTesting2 {
    func flyAndWalk<T> (_ f:T) where T: Flier {}
    func flyAndWalk2<T> (_ f:T) where T: Flier & Walker {}
    func flyAndWalk2a<T> (_ f:T) where T: Flier, T: Walker {}
    func flyAndWalk3<T> (_ f:T) where T: Flier & Dog {}
    func flyAndWalk3a<T> (_ f:T) where T: Flier, T: Dog {}
}

func flyAndWalk<T> (_ f:T) -> String where T:Walker, T:Flier {return "ha"}
// func flyAndWalkNOT<T:Walker, T: Flier>(_ f: T) {}
func flyAndWalkBis<T> (_ f:T) where T:Walker & Flier {}
func flyAndWalk2<T : Walker & Flier> (_ f:T) {}
func flyAndWalk3<T> (_ f:T) where T:Flier, T:Dog {}
func flyAndWalk3Bis<T> (_ f:T) where T:Flier & Dog {} // Legal in Swift 4!
func flyAndWalk3BisBis<T: Flier & Dog> (_ f:T) {} // Legal in Swift 4!
// func flyAndWalk4<T where T == Dog> (f:T) {}

struct Bird : Flier, Walker {}
struct Kiwi : Walker {}
struct S : Generic {
    typealias T = Bird
    typealias UU = Bird
    typealias U = FlyingDog
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var c = Camp<Soldier>()
        c.spy = Archer()
        // c.spy = Soldier() // nope
        
        var c2 = Camp<Archer>()
        c2.spy = Soldier()
        // c2.spy = Archer()
        

        
        // flyAndWalk(Kiwi())
        // flyAndWalk2(Kiwi())
        _ = flyAndWalk(Bird())
        flyAndWalk2(Bird())
        flyAndWalk3(FlyingDog())
        
        
    }


}


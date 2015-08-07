

import UIKit

// =====

protocol Wieldable {
}
struct Sword : Wieldable {
}
struct Bow : Wieldable {
}
protocol Superfighter {
    typealias Weapon : Wieldable
}
protocol Fighter : Superfighter {
    typealias Enemy : Superfighter
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
    typealias T : Flier, Walker // T must adopt Flier and Walker
    // typealias U where U:Flier // no where clauses on typealias
    typealias U : Dog, Flier // legal: this is basically an inheritance declaration!
}
func flyAndWalk<T where T:Walker, T:Flier> (f:T) {}
func flyAndWalk2<T : protocol<Walker, Flier>> (f:T) {}
func flyAndWalk3<T where T:Flier, T:Dog> (f:T) {}
// func flyAndWalk4<T where T == Dog> (f:T) {}

struct Bird : Flier, Walker {}
struct Kiwi : Walker {}
struct S : Generic {
    typealias T = Bird
    typealias U = FlyingDog
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var c = Camp<Soldier>()
        c.spy = Archer()
        
        var c2 = Camp<Archer>()
        c2.spy = Soldier()
        

        
        // flyAndWalk(Kiwi())
        // flyAndWalk2(Kiwi())
        flyAndWalk(Bird())
        flyAndWalk2(Bird())
        flyAndWalk3(FlyingDog())
        
        
    }


}


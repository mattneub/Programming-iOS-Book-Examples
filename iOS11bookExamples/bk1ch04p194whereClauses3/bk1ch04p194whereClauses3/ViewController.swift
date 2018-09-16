

import UIKit

// shortening an associated type chain by using an intermediate associated type with a where clause

protocol Wieldable {
}
struct Sword : Wieldable {
}
struct Bow : Wieldable {
}
protocol Fighter {
    // associatedtype Enemy where Enemy : Fighter
    associatedtype Enemy : Fighter
    associatedtype Weapon : Wieldable
    associatedtype EnemyWeapon where EnemyWeapon == Enemy.Weapon // *
    func steal(weapon:EnemyWeapon, from:Enemy) // *
}
struct Soldier : Fighter {
    typealias Weapon = Sword
    typealias Enemy = Archer
    typealias EnemyWeapon = Bow
    func steal(weapon:Bow, from:Archer) {
    }
}
struct Archer : Fighter {
    typealias Weapon = Bow
    typealias Enemy = Soldier
    typealias EnemyWeapon = Sword
    func steal (weapon:Sword, from:Soldier) {
    }
}

struct Camp<T:Fighter> {
    var spy : T.Enemy?
}


class ViewController: UIViewController {


}


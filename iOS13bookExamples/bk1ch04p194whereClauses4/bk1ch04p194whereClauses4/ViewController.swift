

import UIKit

protocol Flier {
    func fly()
}
struct Animal<Parent> {
    var parent : Parent
}

// new in Swift 4.1: conditional conformances
// the typical use case is like this: an extension on a generic,
// adopting a protocol only just in case the parameterized type meets some condition

extension Animal : Flier where Parent : Flier {
    func fly() {parent.fly()}
    // we must implement fly because we are saying what to do...
    // when we adopt Flier
    // we can tell parent to fly because we implement fly only if parent is a Flier
}

// we could say this, without the extension, but that can hardly be called conditional
struct Animal2<Parent> : Flier where Parent : Flier {
    func fly() {
    }
    var parent : Parent
}

// the above is merely a reexpression of
struct Animal3<Parent:Flier> : Flier {
    func fly() {
    }
    var parent : Parent
}

// note that conditional conformance does not automatically bring in super-protocols

protocol Bear {associatedtype T; func growl() }
protocol Grizzly : Bear { func kill() }
struct Thing<T> {}
// if you comment out this first extension, compiler stops you
// you must somehow say what you want done _explicitly_ for all superprotocols
// you cannot adopt _just_ Grizzy conditionally
extension Thing: Bear where T == String {
    func growl() {
    }
}
extension Thing : Grizzly where T == String {
    func kill() {
    }
}

struct Bird : Flier {
    func fly() {print("flap flap flap")}
}
struct Cat {}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cat = Animal(parent:Cat())
        // cat.fly() // Type 'Cat' does not conform to protocol 'Flier'
        _ = cat
        
        let bird = Animal(parent:Bird())
        bird.fly()
        
        // here's a consequence of the new dispensation: nested Optionals can be Equatable
        
        let outer1 = Optional(Optional("inner"))
        let outer2 = Optional(Optional("inner"))
        
        if outer1 == outer2 {
            // before Swift 4.1, error: Binary operator '==' cannot be applied to two 'String??' operands
            // in Swift 4.1, no problem
            print("same")
        }

    }


    

}


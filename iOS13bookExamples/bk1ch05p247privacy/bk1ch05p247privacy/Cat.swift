import MyCoolModule

class Cat2 {
    private var secretName : String?
    // let k = Kangaroo() // nope, never heard of that class
    // let z = Zebra() // never heard of that either
    let w = Warthog()
}

class Screechowl : Owl { // legal because "name" is open
    override var name : String { // legal only if "name" is also open
        get {return "Cutie"}
        set {}
    }
}

extension Eagle {}



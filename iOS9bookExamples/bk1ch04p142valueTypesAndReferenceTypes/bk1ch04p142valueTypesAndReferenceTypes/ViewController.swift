

import UIKit

struct Digit {
    var number : Int
    init(_ n:Int) {
        self.number = n
    }
    mutating func changeNumberTo(n:Int) {
        self.number = n
    }
    // illegal without "mutating"
    /*
    func changeNumberTo2(n:Int) {
        self.number = n // compile error
    }
*/
}

class Dog {
    var name : String = "Fido"
}

/*
func digitChanger(d:Digit) {
    d.number = 42 // compile error: cannot assign to 'number' in 'd'
}
*/

// currently works, but deprecated in Swift 2.2 and will be removed in Swift 3
// the example exactly illustrates the reason: you probably _think_ you are changing the original Digit object...
// but you're just changing a copy
// hence you now have two options: either redeclare var d = d to make local d mutable...
// or, if you really intended to change the original Digit, use inout

/*

func digitChanger(var d:Digit) {
    d.number = 42
}
 
 */

func digitChanger(d:Digit) {
    var d = d
    d.number = 42
}

func dogChanger(d:Dog) {
    d.name = "Rover"
}

/*

struct RecursiveDog { // compile error
    var puppy : RecursiveDog?
}

*/

// but this is now legal:

enum Node {
    case None(Int)
    indirect case Left(Int, Node)
    indirect case Right(Int, Node)
    indirect case Both(Int, Node, Node)
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    
        let d = Digit(123)
        // d.number = 42 // compile error: cannot assign to property: 'd' is a 'let' constant

        var d2 : Digit = Digit(123) {
            didSet {
                print("d2 was set")
            }
        }
        d2.number = 42 // "d2 was set"
        
        do {
            var d = Digit(123)
            // let d = Digit(123)
            d.changeNumberTo(42) // compile error if d is `let`
        }

        let rover = Dog()
        rover.name = "Rover" // fine
        
        var rover2 : Dog = Dog() {
            didSet {
                print("did set rover2")
            }
        }
        rover2.name = "Rover" // nothing in console

        do {
            let d = Digit(123)
            print(d.number) // 123
            var d2 = d // assignment!
            d2.number = 42
            print(d.number) // 123
            
        }
        
        do {
            let fido = Dog()
            print(fido.name) // Fido
            let rover = fido // assignment!
            rover.name = "Rover"
            print(fido.name) // Rover
            
        }
        
        do {
            let d = Digit(123)
            print(d.number) // 123
            digitChanger(d)
            print(d.number) // 123
            
        }

        do {
            let fido = Dog()
            print(fido.name) // "Fido"
            dogChanger(fido)
            print(fido.name) // "Rover"
            
        }
    }


}


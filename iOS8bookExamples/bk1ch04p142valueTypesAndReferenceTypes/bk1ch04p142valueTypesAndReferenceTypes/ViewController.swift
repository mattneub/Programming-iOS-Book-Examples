

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

func digitChanger(var d:Digit) {
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




class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    
        let d = Digit(123)
        // d.number = 42 // compile error: cannot assign to 'number' in 'd'

        var d2 : Digit = Digit(123) {
            didSet {
                println("d2 was set")
            }
        }
        d2.number = 42 // "d2 was set"

        let rover = Dog()
        rover.name = "Rover" // fine
        
        var rover2 : Dog = Dog() {
            didSet {
                println("did set rover2")
            }
        }
        rover2.name = "Rover" // nothing in console

        if true {
            var d = Digit(123)
            println(d.number) // 123
            var d2 = d // assignment!
            d2.number = 42
            println(d.number) // 123
        }
        
        if true {
            var fido = Dog()
            println(fido.name) // Fido
            var rover = fido // assignment!
            rover.name = "Rover"
            println(fido.name) // Rover
        }
        
        if true {
            var d = Digit(123)
            println(d.number) // 123
            digitChanger(d)
            println(d.number) // 123
        }

        if true {
            var fido = Dog()
            println(fido.name) // "Fido"
            dogChanger(fido)
            println(fido.name) // "Rover"
        }
    }


}


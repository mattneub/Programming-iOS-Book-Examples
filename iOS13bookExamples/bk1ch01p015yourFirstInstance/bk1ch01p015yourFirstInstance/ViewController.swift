

import UIKit
import Swift

let sss : NSString = "howdy"

let gOne = 1
var gTwo = 2
// gTwo = gOne // "Expressions are not allowed at the top level"

class Dog {
    func bark() {
        print("woof")
    }
}

class Dog2 { func bark() { print("woof") }}

extension Int {
    func sayHello() {
        print("Hello, I'm \(self)")
    }
}

func go() {
    let one = 1
    var two = 2
    two = one
    let _ = (one,two)
    
    let three = 3
    // three = one // compile error
    _ = three
}

func doGo() {
    go()
}

// let class = 1 // Keyword 'class' cannot be used as an identifier here
// func if() { } // Keyword 'if' cannot be used as an identifier here
class `func` {
    func `if`() {
        let `class` = 1
        _ = `class`
    }
}


func silly() {
    if true {
        class Cat {}
        var one = 1
        one = one + 1
    }
}

class ViewController: UIViewController {
    
    // gTwo = gOne // "Expected declaration"
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        print("hello")
        print("world")
        print("hello"); print("world")
        print("hello");
        print("world");
        print(
        "world")
        print("world") // this is a comment, so Swift ignores it
        
        let sum = 1 + 2
        let s = 1.description
        
        _ = sum
        _ = s
        
        1.sayHello() // outputs: "Hello, I'm 1"

        let one = 1
        var two = 2
        two = one
        // one = two // compile error
        // two = "hello" // compile error

        
        var three = 3 // compiler warns, new in Swift 2.0
        
        let _ = (one, two, three)

        
        let fido = Dog()
        fido.bark()

        // Dog.bark() // error: no, it's an _instance_ method
        // think the error message is weird? see the explanation on p. 127
        
        let rover = Dog.init() // I noticed this in Swift 1.2, definitely permitted in Swift 2.0
        // I'm betting that some day the Dog() syntax will be deprecated
        rover.bark()
        
    }



}




import UIKit

func sum (_ x:Int, _ y:Int) -> Int {
    let result = x + y
    return result
}

// the rest just illustrates some declaration syntax

func say1(_ s:String) -> Void { print(s) }
func say2(_ s:String) -> () { print(s) }
func say3(_ s:String) { print(s) }
func say4(_ s:String) -> (Void) {print(s)}

// crazy but true

@discardableResult // this is how to prevent the unused result warning
func greet1(_ unused:Void) -> String { return "howdy" }
@discardableResult
func greet2() -> String { return "howdy" }

func greeet1() -> Void { print("howdy") }
func greeet2() -> () { print("howdy") }
func greeet3() { print("howdy") }

typealias VoidVoid1 = () -> ()
// typealias VoidVoid2 = (Void) -> Void // not in Swift 4!
typealias VoidVoid1b = ((Void)) -> Void // but this is legal
typealias VoidVoid2 = () -> Void
typealias VoidVoid3 = ((Void)) -> Void
typealias VoidVoid4 = (()) -> ()

func testReturnVoid() {
    func f() {}
    // let f2 : VoidVoid3 = f // Swift 4.1, no longer compiles; (()) is not the same as ()
    // let f3 : VoidVoid4 = f // ditto
    return ()
    // return Void // no, not the same
    return Void() // okay
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let _ = sum(4,5)
        
        let x = 4
        let y = 5
        let z = sum(y,x)
        
        print(z)
        
        sum(4,5) // compiler warns
        
        // let _ = sum(4,5) + "howdy" // compile error
        
        let z2 = sum(4,sum(5,6))
        
        print(z2)
        
        say1("howdy")
        say2("howdy")
        say3("howdy")
        say4("howdy")
        // greet1() // takes Void, we must now _pass_ Void, somehow
        greet1(Void())
        greet2()
        greeet1()
        greeet2()
        greeet3()
        
        // to be quite honest I've no idea what I was trying to prove with the example
        // but at least now we compile
        
        let pointless : Void = say1("howdy") // showing that we actually return void
        print("pointless is \(pointless)") // showing that we captured the returned void
        
        let v : Void = () // passing a void is the same as no parameters
        greet1(v)
        greet1(Void())
        greet1(())
        greet2()
        
        testReturnVoid()
        let xx : () = testReturnVoid()
        _ = xx
    }
    
    
}


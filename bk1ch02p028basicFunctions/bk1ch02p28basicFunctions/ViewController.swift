

import UIKit

func sum (x:Int, _ y:Int) -> Int {
    let result = x + y
    return result
}

// the rest just illustrates some declaration syntax

func say1(s:String) -> Void { print(s) }
func say2(s:String) -> () { print(s) }
func say3(s:String) { print(s) }

// crazy but true

func greet1(unused:Void) -> String { return "howdy" }
func greet2() -> String { return "howdy" }

func greeet1(unused:Void) -> Void { print("howdy") }
func greeet2() -> () { print("howdy") }
func greeet3() { print("howdy") }



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let _ = sum(4,5)

        let x = 4
        let y = 5
        let z = sum(y,x)

        print(z)
        
        sum(4,5)
        
        // let _ = sum(4,5) + "howdy" // compile error
        
        let z2 = sum(4,sum(5,6))
        
        print(z2)
        
        say1("howdy")
        say2("howdy")
        say3("howdy")
        greet1()
        greet2()
        greeet1()
        greeet2()
        greeet3()
        
        let pointless : Void = say1("howdy") // showing that we actually return void
        print("pointless is \(pointless)") // showing that we captured the returned void

        let v : Void = () // passing a void is the same as no parameters
        greet1(v)
        greet2(v)


    }


}




import UIKit

func sum (x:Int, y:Int) -> Int {
    let result = x + y
    return result
}

// the rest just illustrates some declaration syntax

func say1(s:String) -> Void { println(s) }
func say2(s:String) -> () { println(s) }
func say3(s:String) { println(s) }


func greet1(Void) -> String { return "howdy" }
func greet2() -> String { return "howdy" }

func greeet1(Void) -> Void { println("howdy") }
func greeet2() -> () { println("howdy") }
func greeet3() { println("howdy") }



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        

        let x = 4
        let y = 5
        let z = sum(y,x)

        println(z)
        
        let z2 = sum(4,sum(5,6))
        
        println(z2)
        
        let pointless : Void = say1("howdy") // showing that we actually return void
        println("pointless is ", pointless) // showing that we captured the returned void

        


    }


}


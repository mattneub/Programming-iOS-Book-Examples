
import UIKit

func pass100 (f:(Int)->()) {
    f(100)
}

func countAdder(f:()->()) -> () -> () {
    var ct = 0
    return {
        ct = ct + 1
        println("count is \(ct)")
        f()
    }
}



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var x = 0
        println(x)
        func setX(newX:Int) {
            x = newX
        }
        pass100(setX)
        println(x)

        
        
        func greet () {
            println("howdy")
        }
        let countedGreet = countAdder(greet)
        countedGreet()
        countedGreet()
        countedGreet()

        let countedGreet2 = countedGreet
        countedGreet2() // shows that functions are reference types

        
        
    }



}


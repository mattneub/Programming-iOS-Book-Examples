
import UIKit




class ViewController: UIViewController {
    
    func pass100 (f:(Int)->()) {
        f(100)
    }
    
    func countAdder(f:()->()) -> () -> () {
        var ct = 0
        return {
            ct = ct + 1
            print("count is \(ct)")
            f()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var x = 0
        print(x)
        func setX(newX:Int) {
            x = newX
        }
        pass100(setX)
        print(x)

        
        
        func greet () {
            print("howdy")
        }
        let countedGreet = countAdder(greet)
        countedGreet()
        countedGreet()
        countedGreet()

        do {
            let countedGreet = countAdder(greet)
            let countedGreet2 = countAdder(greet)
            countedGreet() // count is 1
            countedGreet2() // count is 1
        }
        
        do { // showing that functions are reference types
            let countedGreet = countAdder(greet)
            let countedGreet2 = countedGreet
            countedGreet() // count is 1
            countedGreet2() // count is 2
        }
        
        
    }



}




import UIKit

// this is legal
func say (what:String) {
}
func say (what:Int) {
}

// this is legal too, but _calling_ is trickier

func say() -> String {
    return "one"
}
func say() -> Int {
    return 1
}

func giveMeAString(s:String) {
    println("thanks!")
}


class ViewController: UIViewController {
    
    // this is not legal, because Objective-C can't deal with it:
    /*
    func say (what:String) {
    }
    func say (what:Int) {
    }
*/

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        say("howdy")
        say(1)
        
        // say() // ambiguous, therefore illegal
        // but these are fine:
        giveMeAString(say())
        let result = say() + "two"
        println(result)
    
    }


}


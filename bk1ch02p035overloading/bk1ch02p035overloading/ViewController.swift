

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
    print("thanks!")
}


class ViewController: UIViewController {
    
    // if you delete `@nonobject`, this is not legal, because Objective-C can't deal with it:
    func sayy (what:String) {
    }
    @nonobjc func sayy (what:Int) {
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // but overloading is _not_ legal at the local level
        // I take it that is because we have no dynamic dispatch here?
        /*
        func sayyy (what:String) {
        }
        func sayyy (what:Int) {
        }
*/

        say("howdy")
        say(1)
        
        // say() // ambiguous, therefore illegal
        // but these are fine:
        giveMeAString(say())
        let result = say() + "two"
        print(result)
    
    }


}


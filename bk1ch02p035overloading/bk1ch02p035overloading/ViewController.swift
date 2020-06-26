

import UIKit

// this is legal
// this is legal
func say (_ what:String) {
}
func say (_ what:Int) {
}

// this is legal too, but _calling_ is trickier

func say() -> String {
    return "one"
}
func say() -> Int {
    return 1
}

func giveMeAString(_ s:String) {
    print("thanks!")
}


class ViewController: UIViewController {
    
    // if you delete `@nonobjc`, this is not legal, because Objective-C can't deal with it:
    // okay, that's no longer true; in Swift 4, we are NOT automatically exposed!
    // thus I have deleted @nonobjc from both pairs; we are non-objc by default
    
    func sayy (what:String) {
    }
    func sayy (what:Int) {
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // but overloading is _not_ legal at the local level
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
        
        // new in Swift 5.2, there's another way to disambiguate:
        // use the function signature
        do {
            let result = (say as () -> String)()
            print(result)
        }
        do {
            let result: String = say()
            print(result)
        }
    
    }


}


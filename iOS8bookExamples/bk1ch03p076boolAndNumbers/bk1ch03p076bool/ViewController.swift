

import UIKit

class ViewController: UIViewController {
    
    var selected : Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()

        if self.traitCollection.horizontalSizeClass == .Compact {}
    
        let comp = self.traitCollection.horizontalSizeClass == .Compact
        if comp {}
        
        if 3e2 == 300 {
            println("yep")
        }

        if 0x10p2 == 64 {
            println("yep")
        }
        
        // let d : Double = .64 // illegal in Swift
        
        // coercion
        
        let i = 10
        let x = Double(i)
        println(x) // 10.0, a Double
        let y = 3.8
        let j = Int(y)
        println(j) // 3, an Int
        
        // no implicit coercion for variables
        
        let d : Double = 10
        // let d2 : Double = i // compile error; you need to say Double(i)

        let n = 3.0
        // let x2 = i / n // compile error; you need to say Double(i)

        // how to make a bitmask
        let opts : UIViewAnimationOptions = .Autoreverse | .Repeat
        
        let ii = Int.max - 2
        // let jj = ii + 12/2 // crash
        let (jj, over) = Int.addWithOverflow(ii,12/2)
        println(jj)
        println(over)


        // how to compare doubles for equality
        let isEqual = abs(x - y) < 0.000001

        
    }
    
    // the ugliest code in the world:
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
        // can also be written like this:
        // return numericCast(UIInterfaceOrientationMask.Portrait.rawValue)

    }



}

class MyTableViewCell : UITableViewCell {
    // how to test a bit in a bitmask
    override func didTransitionToState(state: UITableViewCellStateMask) {
        let editing = UITableViewCellStateMask.ShowingEditControlMask.rawValue
        if state.rawValue & editing != 0 {
            // ... the ShowingEditControlMask bit is set ...
        }
    }

}


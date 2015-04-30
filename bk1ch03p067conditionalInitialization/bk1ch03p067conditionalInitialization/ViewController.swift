

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    // wrapped in a function so that `val` is unknown to the compiler
    func conditionalInitializationExample(val:Int) {
        
        let timed : Bool
        if val == 1 {
            timed = true
        } else {
            timed = false
        }
        
    }
    
    // but in that case I would rather use a computed initializer:
    func computedInitializerExample(val:Int) {
        
        let timed : Bool = {
            if val == 1 {
                return true
            } else {
                return false
            }
        }()

        
        
    }
    


}


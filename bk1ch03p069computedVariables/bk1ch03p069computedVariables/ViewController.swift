

import UIKit

var now : String {
    get {
        return NSDate().description
    }
    set {
        println(newValue)
    }
}

var now2 : String { // showing you can omit "get" if there is no "set"
    return NSDate().description
}



class ViewController: UIViewController {
    
    // typical "facade" structure
    private var _p : String = ""
    var p : String {
        get {
            return self._p
        }
        set {
            self._p = newValue
        }
    }
    
    // observer
    var s = "whatever" {
        willSet {
            println(newValue)
        }
        didSet {
            println(oldValue)
            // self.s = "something else"
        }
    }



    override func viewDidLoad() {
        super.viewDidLoad()

    
    
        now = "Howdy"
        println(now)
        
        self.s = "Hello"
        self.s = "Bonjour"

    
    
    }


}


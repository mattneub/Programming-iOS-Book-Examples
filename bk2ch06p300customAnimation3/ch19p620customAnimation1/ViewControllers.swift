

import UIKit

/*
Logging to prove that on a partial gesture (with cancellation),
viewWillAppear (1st) and viewWillDisappear(2nd) are called...
...without the corresponding "did"
*/

class FirstViewController : UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("\(self) " + __FUNCTION__)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("\(self) " + __FUNCTION__)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        println("\(self) " + __FUNCTION__)
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        println("\(self) " + __FUNCTION__)
    }
    
    
}

class SecondViewController : UIViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("\(self) " + __FUNCTION__)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("\(self) " + __FUNCTION__)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        println("\(self) " + __FUNCTION__)
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        println("\(self) " + __FUNCTION__)
    }

}



import UIKit

/*
Logging to prove that on a partial gesture (with cancellation),
viewWillAppear (1st) and viewWillDisappear(2nd) are called...
...without the corresponding "did"
*/

class FirstViewController : UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("\(self) " + #function)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self) " + #function)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(self) " + #function)
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(self) " + #function)
    }
    
    
}

class SecondViewController : UIViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("\(self) " + #function)
        if let tc = self.transitionCoordinator() {
            print(tc)
        }

    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self) " + #function)
        if let tc = self.transitionCoordinator() {
            print(tc)
        }

    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(self) " + #function)
        
        if let tc = self.transitionCoordinator() {
            print(tc)
        }
        
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(self) " + #function)
        if let tc = self.transitionCoordinator() {
            print(tc)
        }

    }

}

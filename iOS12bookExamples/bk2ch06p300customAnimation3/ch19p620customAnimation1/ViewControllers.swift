

import UIKit

/*
Logging to prove that on a partial gesture (with cancellation),
viewWillAppear (1st) and viewWillDisappear(2nd) are called...
...without the corresponding "did"
*/

class FirstViewController : UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(self) " + #function)
        
        guard let tc = self.transitionCoordinator else {print("no tc"); return}
        guard tc.initiallyInteractive else {return}
        tc.notifyWhenInteractionChanges { // "changes" instead of "ends"
            context in
            if context.isCancelled {
                print("we got cancelled")
            }
        }

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self) " + #function)
        
        guard let tc = self.transitionCoordinator else {print("no tc"); return}
        guard tc.initiallyInteractive else {return}
        tc.notifyWhenInteractionChanges { // "changes" instead of "ends"
            context in
            if context.isCancelled {
                print("we got cancelled")
            }
        }

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(self) " + #function)
        
        // proving there's no transition coordinator; I regard this as a bug
        guard let tc = self.transitionCoordinator else {print("no tc"); return}
        guard tc.initiallyInteractive else {return}
        tc.notifyWhenInteractionChanges { // "changes" instead of "ends"
            context in
            if context.isCancelled {
                print("we got cancelled")
            }
        }

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(self) " + #function)
        
        guard let tc = self.transitionCoordinator else {print("no tc"); return}
        guard tc.initiallyInteractive else {return}
        tc.notifyWhenInteractionChanges { // "changes" instead of "ends"
            context in
            if context.isCancelled {
                print("we got cancelled")
            }
        }

    }
    
    
}

class SecondViewController : UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(self) " + #function)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self) " + #function)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(self) " + #function)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(self) " + #function)
    }

}

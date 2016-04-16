
import UIKit

class SecondViewController : UIViewController {
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        print(self, terminator: "")
        print(" ", terminator: "")
        print(#function)
        return .landscape // called, but pointless
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .lightContent
    }
    

    
}

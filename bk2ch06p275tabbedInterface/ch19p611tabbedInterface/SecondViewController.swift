
import UIKit

class SecondViewController : UIViewController {
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        print(self, terminator: "")
        print(" ", terminator: "")
        print(__FUNCTION__)
        return .Landscape // called, but pointless
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    

    
}

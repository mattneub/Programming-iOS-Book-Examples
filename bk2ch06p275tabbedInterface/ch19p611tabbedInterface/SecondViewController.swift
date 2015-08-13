
import UIKit

class SecondViewController : UIViewController {
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        print(self, appendNewline:false)
        print(" ", appendNewline:false)
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

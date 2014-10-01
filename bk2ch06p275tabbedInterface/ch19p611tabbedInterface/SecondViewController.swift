
import UIKit

class SecondViewController : UIViewController {
    
    override func supportedInterfaceOrientations() -> Int {
        print(self)
        print(" ")
        println(__FUNCTION__)
        return Int(UIInterfaceOrientationMask.Landscape.rawValue) // called, but pointless
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    

    
}


import UIKit

class SecondViewController : UIViewController {
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        print(self, terminator: "")
        print(" ", terminator: "")
        print(#function)
        return .landscape // called, but pointless
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    

    
}

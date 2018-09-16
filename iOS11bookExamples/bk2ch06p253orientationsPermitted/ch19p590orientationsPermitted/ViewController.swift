

import UIKit

class ViewController : UIViewController {
    
    // how to override the application's list of possible orientations
    // at the view controller level
    
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        
        print(UIApplication.shared.statusBarOrientation.rawValue)
        
        print(UIDevice.current.orientation.rawValue)
        
        let result = UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
        print(result)
        
        print("supported") // called 7 times at launch! WTF?
        
        // wait! now, .all means .all!
        return .all
        
        return .portrait
    }
 
    
    // we are called *every time* the device rotates (twice, it seems)

    
}

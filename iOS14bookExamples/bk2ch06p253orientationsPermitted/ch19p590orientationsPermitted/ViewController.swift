

import UIKit

class ViewController : UIViewController {
    
    // how to override the application's list of possible orientations
    // at the view controller level
    
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        
        print(self.view.window?.windowScene?.interfaceOrientation.rawValue as Any)
        
        print(UIDevice.current.orientation.rawValue)
        
        let result = UIDevice.current.orientation.isLandscape
        print(result)
        
        print("supported") // called 7 times at launch! WTF?
        // okay now it's 12 times, I guess that's better LOL
        
        // wait! now, .all means .all!
        return .all
        
        return .portrait
    }
 
    
    // we are called *every time* the device rotates (twice, it seems)

    
}

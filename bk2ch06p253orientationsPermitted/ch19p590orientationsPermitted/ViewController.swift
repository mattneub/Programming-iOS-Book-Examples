

import UIKit

class ViewController : UIViewController {
    
    // how to override the application's list of possible orientations
    // at the view controller level
    
    // big news, this API is now much nicer
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        
        print(UIApplication.shared.statusBarOrientation.rawValue)
        
        print(UIDevice.current.orientation.rawValue)
        
        let result = UIDeviceOrientationIsLandscape(UIDevice.current.orientation)
        print(result)
        
        // more big news, this next line now won't compile! Swift protects you
        // return UIInterfaceOrientation.Portrait // crash!
        
        print("supported") // called 7 times at launch! WTF?
        
        // trick to get iPhone to assume portrait upside down
        // saying it in the supported interface orientations Info.plist key is ignored
        // return [.Portrait, .PortraitUpsideDown]
        
        return .portrait
    }
    
    
    // we are called *every time* the device rotates (twice, it seems)

    
}


import UIKit

class ViewController : UIViewController {
    
    // how to override the application's list of possible orientations
    // at the view controller level
    
    // big news, this API is now much nicer
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        print(UIApplication.sharedApplication().statusBarOrientation.rawValue)
        
        print(UIDevice.currentDevice().orientation.rawValue)
        
        let result = UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)
        print(result)
        
        // more big news, this next line now won't compile! Swift protects you
        // return UIInterfaceOrientation.Portrait // crash!
        
        print("supported") // called 7 times at launch! WTF?
        
        // trick to get iPhone to assume portrait upside down
        // saying it in the supported interface orientations Info.plist key is ignored
        // return [.Portrait, .PortraitUpsideDown]
        
        return .Portrait
    }
    
    
    // we are called *every time* the device rotates (twice, it seems)

    
}
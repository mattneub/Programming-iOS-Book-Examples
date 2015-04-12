

import UIKit

class ViewController : UIViewController {
    
    // how to override the application's list of possible orientations
    // at the view controller level
    
    override func supportedInterfaceOrientations() -> Int {
        
        println(UIApplication.sharedApplication().statusBarOrientation.rawValue)
        println(UIDevice.currentDevice().orientation.rawValue)
        let result = UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)
        println(result)
        
        // uncomment next line in order to crash
        // return UIInterfaceOrientation.Portrait.rawValue // crash!
        
        // ha ha, you didn't read the docs
        // you don't return an orientation; you return an orientation *mask*
        // (UIInterfaceOrientationMask)
        // Unfortunately, Swift does not help prevent this mistake
        // (because once you call rawValue you're on your own)

        // further complication: UIInterfaceOrientation is typed as UInt,
        // so there's an impedance mismatch and you have to case in order to compile

        println("supported") // called 10 times at launch! WTF?
        // and then 6 more times if you tap on the interface!
        // okay, in my latest test it's only 5 times at launch
        // I guess that's, uh, better...
        
        return Int(UIInterfaceOrientationMask.Portrait.rawValue) // gag me with a spoon
    }
    
    // quite tricky to get iPhone to assume portrait upside down
    // saying it in the supported interface orientations Info.plist key is ignored
    // you can try to force it at a lower level such as here
    // return Int(UIInterfaceOrientationMask.Portrait.rawValue |
    // UIInterfaceOrientationMask.PortraitUpsideDown.rawValue)
    // however, I find that in iOS 8 this crashes the app when you try to rotate

    
    // we are called *every time* the device rotates (twice, it seems)

    
}
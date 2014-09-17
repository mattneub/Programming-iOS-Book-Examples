

import UIKit

class ViewController : UIViewController {
    
    // how to override the application's list of possible orientations
    // at the view controller level

    // something weird is going on in the Swift version of this
    // why does supportedInterfaceOrientations() was to return Int?
    // should be UInt...
    
    // And then, how are we supposed to obtain the necessary Int?
    // Apparently you have to call toRaw(), which is annoying
    
    override func supportedInterfaceOrientations() -> Int {
        
        println(UIApplication.sharedApplication().statusBarOrientation.toRaw())
        println(UIDevice.currentDevice().orientation.toRaw())
        let result = UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)
        println(result)
        
        // return UIInterfaceOrientation.Portrait.toRaw() // crash!
        // ha ha, you didn't read the docs
        // you don't return an orientation; you return an orientation *mask*
        // (UIInterfaceOrientationMask)
        // Unfortunately, Swift does not help prevent this mistake
        // (because once you call toRaw() you're on your own)

        // further complication: UIInterfaceOrientation is typed as UInt,
        // so there's an impedance mismatch and you have to case in order to compile

        println("supported") // called 10 times at launch! WTF?
        // and then 6 more times if you tap on the interface!
        
        return Int(UIInterfaceOrientationMask.Portrait.toRaw()) // gag me with a spoon
    }
    
    // quite tricky to get iPhone to assume portrait upside down
    // saying it in the supported interface orientations Info.plist key is ignored
    // you can try to force it at a lower level such as here
    // return Int(UIInterfaceOrientationMask.Portrait.toRaw() |
    // UIInterfaceOrientationMask.PortraitUpsideDown.toRaw())
    // however, I find that in iOS 8 this crashes the app when you try to rotate

    
    // we are called *every time* the device rotates (twice, it seems)

    
}